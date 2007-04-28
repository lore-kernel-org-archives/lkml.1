Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbXD1Kbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbXD1Kbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbXD1Kbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:31:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60902 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262AbXD1Kbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:31:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 12:35:36 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704271150.55701.oliver@neukum.org> <Pine.LNX.4.64.0704271303260.925@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704271303260.925@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281235.37102.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 12:12, Pekka J Enberg wrote:
> Am Freitag, 27. April 2007 08:18 schrieb Pekka J Enberg:
> > > No. The snapshot is just that. A snapshot in time. From kernel point of 
> > > view, it doesn't matter one bit what when you did it or if the state has 
> > > changed before you resume. It's up to userspace to make sure the user 
> > > doesn't do real work while the snapshot is being written to disk and 
> > > machine is shut down.
> 
> On Fri, 27 Apr 2007, Oliver Neukum wrote:
> > And where is the benefit in that? How is such user space freezing logic
> > simpler than having the kernel do the write?
> >
> > What can you do in user space if all filesystems are r/o that is worth the
> > hassle?
> 
> I am talking about snapshot_system() here. It's not given that the 
> filesystems need to be read-only (you can snapshot them too). The benefit 
> here is that you can do whatever you want with the snapshot (encrypt, 
> compress, send over the network)  and have a clean well-defined interface 
> in the kernel. In addition, aborting the snapshot is simpler, simply 
> munmap() the snapshot.

Well, swsusp currently does almost the same, except that you can read the
image from the kernel as a stream of bytes, using read() and, during the
restore phase, upload the same image using write().  The advantage of this
is that the interface is symmetrical from the user space's point of view.
[You're cancelling the hibernation by closing /dev/snapshot, which also is
quite natural.]

If you look at the interface in user.c, there are only two ioctls really needed
for that in there, SNAPSHOT_ATOMIC_SNAPSHOT and
SNAPSHOT_ATOMIC_RESTORE.  Two more are handy for freezing
tasks, SNAPSHOT_FREEZE and SNAPSHOT_UNFREEZE.  The others were added
later, to make the user space part simpler or capable of doing some fancy
stuff, which I am ready to admit was a mistake.

> The problem with writing in the kernel is obvious: we need to add new code 
> to the kernel for compression, encryption, and userspace interaction 
> (graphical progress bar) that are important for user experience.

Yes, and that's why we wanted to introduce the userland part.  The problem
with this approach, as it's turned out, is that the userland part must be a
very specialized piece of software, really careful of what it's doing, mainly
because of the inability to checkpoint filesystems.  If we could checkpoint
filesystems and were able to unfreeze the user space after creating the
snapshot without the risk of corrupting filesystems in the restore phase,
the userland part could be much simpler (even as simple as Linus suggested).

Greetings,
Rafael
