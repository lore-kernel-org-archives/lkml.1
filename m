Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXDZDEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXDZDEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbXDZDEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:04:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbXDZDEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:04:33 -0400
Date: Wed, 25 Apr 2007 20:03:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <1177553635.5025.159.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0704251933300.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu>  <20070424202336.GC16503@elf.ucw.cz>
  <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> 
 <20070424212408.GD16457@elf.ucw.cz>  <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
  <20070425072350.GA6866@ucw.cz>  <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
  <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> 
 <20070425202741.GC17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
  <20070425214420.GG17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
  <1177540027.5025.87.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org> 
 <1177551601.5025.131.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704251847310.9964@woody.linux-foundation.org>
 <1177553635.5025.159.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Nigel Cunningham wrote:
> 
> Sorry. I wasn't clear. I wasn't saying that suspend to ram has a
> snapshot point. I was trying to say it has a point where you're seeking
> to save information (PCI state / SCSI transaction number or whatever)
> that you'll need to get the hardware into the same state at a later
> stage. That (saving information) is the point of similarity.

Yes, they do both save information, but I'm not actually convinced they 
would necessarily even save the *same* information.

Let's just take an example of USB, and to make things more interesting, 
say that the disk you want to suspend to is itself over USB (not 
necessarily something you _want_ to do, but I think we can all agree that 
it's something that should potentially work, no?)

Now, USB devices actually have per-connection state (at a minimum, the 
"toggle" bit or whatever), and that's obviously something that will 
inevitably *change* as a result of the device being used after 
snapshotting (and even if not used, by the rediscovery by the first kernel 
to boot), and we fundamentally cannot put the final toggle state in the 
snapshot.

So in the snapshot-to-disk scenario, there are some pieces of data that 
simply fundamentally *cannot* be snapshotted, because they are not 
controller state, they are "connection" state.

So in that case, you basically know that you *have* to rebuild the 
connection when you do the "snapshot_resume()" thing. So there's no point 
in even keeping these kinds of connection states (the same is true of 
keyboards, mice, anything else - it's how USB works).

In contrast, in suspend-to-RAM, USB connections might just be things you 
actually want to keep open and active, and you *can* do so, in ways you 
simply cannot do with "snapshot to disk". In fact, if you are something 
like an OLPC and actually go to s2ram very aggressively, you might well 
want to keep the connection established, because it's conceivable that you 
might otherwise lose keypresses etc issues)

See? There are real *technical* reasons to believe that the two "save 
state" operations are really fundamentally different. There are reasons to 
believe that a s2ram can actually happen while keeping some connections 
open that cannot be kept open over a disk snapshot.

Do they *have* to be different? Of course not. For many devices the "save" 
and "freeze" operations will likely all be no-ops, and there would be 
absolutely no difference between suspending and snapshotting, because the 
driver state already natively contains all the information needed to get 
the device going again.

Equally, I don't doubt that in many drivers you'll have very similar "save 
state" logic, but in fact I believe that in many cases that "save state" 
logic will often just be a simple

	pci_save_state(dev);

call, so it's literally the case that they will not be just shared between 
the "suspend" and "snapshot" case, they'll be shared across all simple PCI 
devices too!

But that doesn't mean that the functions to do so should be the same. You 
might have

	static int mypcidevice_suspend(struct pci_dev *dev)
	{
		pci_save_state(dev);
		pci_set_power_state(dev, PCI_D3);
		return 0;
	}

	static int mupcidevice_snapshot(struct pci_dev *dev)
	{
		pci_save_state(dev);
		return 0;
	}

and who cares if they both have that same call to a shared "save state" 
function? They're still totally different operations, and the fact that 
*some* devices may save the same things doesn't make them any more 
similar! See above why some devices might save totally *different* things 
for a "snapshot" vs a "suspend" event.

> I suppose that's another point of similarity - for snapshotting, the
> same ordering is probably needed?

I agree that you're likely to walk the device list in the same order. The 
whole "shut down leaf devices first", "start up root devices first" is 
pretty fundamental.

But that's true of reboot and device discovery too. Should that ordering 
mean that we should use the "discovery()" function and pass it a flag and 
say "you shouldn't discover, you should snapshot or suspend now"? No. 
Everybody agrees that device discovery is something different from device 
suspend. The fact that it's done in a topological order and thus they bear 
some kind of inverse relationship to each other doesn't make them "the 
same".

> > And yes, the _individual_ "save-and-suspend" events obviously needs to be 
> > "atomic", but it's purely about that particular individual device, so 
> > there's never any cross-device issues about that.
> 
> No interdependencies? I'm not sure.

Well, we pretty much count on it, since we will *suspend* the devices at 
the same time. So if they had interdependencies that aren't described by 
the ordering we enforce, they are pretty much screwed anyway ;)

So yes, the device list needs to be topologically sorted (and you need to 
walk it in the right direction), but apart from that we'd *better* not 
have any interdependencies, or we simply cannot suspend at all.

			Linus
