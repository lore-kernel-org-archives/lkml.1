Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYHXShG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYHXShG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 14:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYHXSgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 14:36:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519AbYHXSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 14:36:54 -0400
Date: Sun, 24 Aug 2008 11:34:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@redhat.com>,
       Peter Osterlund <petero2@telia.com>, Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
Message-ID: <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11401
> Subject		: pktcdvd: BUG, NULL pointer dereference in pkt_ioctl, bisected
> Submitter	: Laurent Riffard <laurent.riffard@free.fr>
> Date		: 2008-08-22 08:16 (2 days old)

This one looks irritating.

It's bisected to 5b6155ee70e9c4d2ad7e6f514c8eee06e2711c3a ("pktcdvd: push 
BKL down into driver"), but the problem goes deeper than that.

The "unlocked" ioctl's do not get a "struct inode *" pointer, they _only_ 
get the "struct file *". And this is very much historical usage, where 
some internal functions only passed in the inode (good or not, whatever).

And ioctl_by_bdev() doesn't have a "struct file *" and has depended on 
passing in a NUMM "struct file *" and its own "struct inode *", and 
expects the ioctl's to just use that instead. But the unlocked ioctl just 
drops it on the floor, and uses just the (unusable) file pointer.

Grr.

And some other cases (like pkt_ioctl() itself) that simply pass in a 
_different_ inode than the file itself is attached to. It does

	blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);

where "file" points to the pkt_ioctl thing, but "inode" points to the 
inode "behind" the pkt interface.

Double grr.

I really think the only sane model is to literally make "unlocked_ioctl()" 
have the same calling convention as the old "ioctl()" thing had, and pass 
in both file * and inode *. It was a stupid "cleanup" to try to have a 
simpler interface for the unlocked version. Having two different models, 
where we have actually _depended_ on the old model and then are trying to 
convert to a (weaker) new model, is not a good idea.

The alternative is to do this _only_ for the blkdev_ioctl's, and have 
those only take the "inode *", and then create a new fake "struct file *" 
to go with it, regardless of what "struct file" was passed in (exactly 
because the blockdev ones really think that the inode is the important 
part).

Hmm?

We need to fix this.

		Linus
