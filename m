Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZFWTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZFWTIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZFWTI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:08:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42852 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZFWTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:08:26 -0400
Date: Tue, 23 Jun 2009 13:08:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Alex Chiang <achiang@hp.com>,
       jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
Message-ID: <20090623190826.GJ19977@parisc-linux.org>
References: <20090622140807.25509.54448.stgit@bob.kio> <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org> <20090622183056.GY19977@parisc-linux.org> <1245714008.4017.7.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245714008.4017.7.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:40:08AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-22 at 12:30 -0600, Matthew Wilcox wrote:
> > 
> > That would be correct.  I'm guessing your out-of-tree code sets
> > pcibios_scan_all_fns()?
> > 
> > Now, there are various options.  One is that you could remap config
> > space accesses -- domain:bus:dev.fn in the guest don't have to match
> > domain:bus:dev.fn in the host.  That's a certain amount of overhead in
> > every config space access, but it doesn't have to be a large one.
> > 
> That's tricky. Some devices have internal registers that -do- depend on
> what function they are on. In fact, I remember seeing that in
> multifunction devices that are meant to be virtualized but still need to
> have some registers be accessed differently depending on the function
> (ugh) though don't ask me who that was ...

That's pretty horrific.  PA-RISC has a NS87415 superio chip that is
full of that kind of bogosity, but nobody's ever suggested it should
support v12n.

> > Another would be that you could create dummy devices in the guest at
> > function 0, and then the guest would scan all the functions.  A little
> > ugly, perhaps.
> 
> But less ugly than the above.

There's some nastiness when you want to later migrate function 0 into
the VM, and it looks a little ugly to have a fake func 0 in the VM with
nothing attached to it.

> > A third would be for guests to not do this scanning at all.  You could
> > present the devices through something like the openfirmware tree, and
> > create them insteaqd of scanning for them.  If you care about startup
> > time, this is probably the way to go.
> 
> Which is what we do on powerpc nowadays. In fact, this code is currently
> inside arch/powerpc and arch/sparc (2 copies slightly diverged) but I
> had plans to make it common at move it over to either drivers/of or
> drivers/pci (most probably the later).

I'd support a drivers/pci/of.c.  Definitely better than having two copies
of it under arch/, and you'd be well within your rights to complain if
we changed something and didn't fix it up.

> > There's probably other ways I haven't thought of ...
> 
> Well, making up the devices without actual config space probing is nice
> and fast but I don't think we want to see too many occurences of such
> code in the kernel. We already had breakage once in powerpc land iirc
> due to changes in drivers/pci/probe.c that we didn't reflect properly. I
> think the normal and OF methods should be enough.

Particularly since we have these people creating fake OF trees for
embedded platforms so we don't have to probe them.  The v12n people
should definitely take advantage of this work.

> At this stage, it does look to me like a trivial tweak like
> pcibios_scan_all_fns() but maybe done a bit nicely, would still be the
> simplest solution in term of amount of code involved etc...
> 
> Maybe something like
> 
> pcibios_get_slot_fn_mask() which returns a bitmask of functions to be
> scanned, whose default implementation (weak) would basically check
> the header type for function 0 ? As I said, I don't -need- that right
> now on powerpc "server" platforms but heh... 

So we need to tweak this code anyway for Alternate RoutingID Interpretation,
and what I've ended up doing is creating a bunch of different functions that
can be called to determine what the next function to probe should be, given
the current device and function.

Take a look: http://marc.info/?l=linux-pci&m=124578246906927&w=2

It wouldn't be hard to continue supporting pcibios_scan_all_fns() with
this scheme; it's an extra two lines:

+	else if (pcibios_scan_all_fns())
+		next_fn = next_trad_fn;

I think simply materialising them, either the way the OF code does,
or the way the IOV code does is the best route forwards.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
