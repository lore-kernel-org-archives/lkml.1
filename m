Return-Path: <linux-kernel-owner+w=401wt.eu-S1422943AbXDYW4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422943AbXDYW4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422957AbXDYW4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:56:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422943AbXDYW4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:56:44 -0400
Date: Wed, 25 Apr 2007 15:55:58 -0700 (PDT)
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
In-Reply-To: <1177540027.5025.87.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu>  <20070424202336.GC16503@elf.ucw.cz>
  <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> 
 <20070424212408.GD16457@elf.ucw.cz>  <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
  <20070425072350.GA6866@ucw.cz>  <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
  <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> 
 <20070425202741.GC17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
  <20070425214420.GG17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <1177540027.5025.87.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Nigel Cunningham wrote:
> > 
> > And name *one* thing that have in common.
> 
> Set/reset the scsi transaction id thingy? Hibernation didn't work with
> SCSI for a long time precisely because that support was missing.

And by "hibernation", you mean what? You mean "snapshot + shutdown", 
right?

Think about it for five seconds, and then ask yourself: at which point in 
the "snapshot + shutdown" sequence would you actually tell a disk to shut 
down?

If you said "snapshot", then you'd be *wrong*. 

That's my _point_. The snapshot() function should not (and MUST NOT) tell 
disks to shut down, because unlike suspend(), we're still going to _use_ 
those disks afterwards (why? To write out the snapshot image!).

In other words, the act of creating a snapshot has *nothing* to do with 
suspend.

Now, after you've created (and written out) the snapshot, what do you 
actually end up doing?

That's right - you end up _shutting down_ the machine, and yes, as part 
of the _shutdown_ sequence you may actually end up doing a lot of the 
things that a suspend would do. But that's long *after* you've actually 
done the "snapshot" part, and has absolutely nothing to do with it.

That's where I started: whole "suspend to disk" thing actually has _more_ 
to do with "shutdown" than with "suspend". 

			Linus
