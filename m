Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZBHXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZBHXYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZBHXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:24:29 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:36498 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZBHXY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:24:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dUv8kIUtFvSdZZfsBg29mLKn1fvhWDENMIo3y/SHta2fMdrw2E07CFH2H1rRT8M49l
         geF2YywMRgAPnnAKy+FAbXXyfzYc3+IPg1jngSRsPD5T1szTrYb7PxC780UYDuKRWIcj
         g2LDlWP3XBem4vq4HUP+w0AO0a6Y/KWXFKR4M=
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-xfs <linux-xfs@oss.sgi.com>
In-Reply-To: <20090208221625.GB8830@disturbed>
References: <1234011974.7435.11.camel@champagne.cantina>
	 <20090208221625.GB8830@disturbed>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 00:24:23 +0100
Message-Id: <1234135463.12370.47.camel@champagne.cantina>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 09:16 +1100, Dave Chinner wrote:
> On Sat, Feb 07, 2009 at 02:06:13PM +0100, Alessandro Bono wrote:
> > Hi all
> > 
> > This time I hit kernel bug without any particular operation, normal
> > browsing, mail, news, etc
> > tell me if you need info asap because I want to reformat this machine
> > and switch back to ext3.
> >
> > xfs seems really unstable in this particular
> > machine and after this crash I lose again configuration file of opened
> > program at crash time
> 
> That's not XFS's fault - that's a broken application that does not
> safely overwrite files and hence you lose data on crash.

In the past I lose configuration files from kde, gconf based programs (gnome), pan, firefox, etc
maybe xfs expose more this problem  

> 
> > Feb  7 12:43:12 champagne kernel: [ 5828.167041] ------------[ cut
> > here ]------------
> > Feb  7 12:43:12 champagne kernel: [ 5828.167048] kernel BUG at
> > fs/buffer.c:470!
> 
> I can't remember seeing that problem before.
> 
> > Call Trace:
> >  [<ffffffff8022806f>] ?  need_resched+0x1e/0x28
> >  [<ffffffff8030be35>] ?  __up_write+0x12/0x45
> >  [<ffffffffa01c2269>] ?  xfs_destroy_ioend+0x23/0x71 [xfs]
> >  [<ffffffffa01c23db>] ?  xfs_end_bio_delalloc+0x0/0x19 [xfs]
> >  [<ffffffffa01c23db>] ?  xfs_end_bio_delalloc+0x0/0x19 [xfs]
> >  [<ffffffff80242d5e>] ?  run_workqueue+0x79/0xfe
> >  [<ffffffff80242ed3>] ?  worker_thread+0xf0/0x102
> >  [<ffffffff802461cd>] ?  autoremove_wake_function+0x0/0x2e
> >  [<ffffffff80242de3>] ?  worker_thread+0x0/0x102
> >  [<ffffffff80245ea2>] ?  kthread+0x47/0x73
> >  [<ffffffff80231bfa>] ?  schedule_tail+0x27/0x60
> >  [<ffffffff8020c3f9>] ?  child_rip+0xa/0x11
> >  [<ffffffff80245e5b>] ?  kthread+0x0/0x73
> >  [<ffffffff8020c3ef>] ?  child_rip+0x0/0x11
> 
> Standard delayed allocation IO completion trace. No idea what
> could have caused it. Perhaps a memory error? 

I'm starting to think the same thing
If needed I can replace memory dimm, this is my principal notebook and I
need it to work

> 
> Can you send the output of xfs_info on that filesystem, and
> perhaps run an xfs_repair -n  on it to see if there are any
> undetected errors on disk?

root@champagne:/home/sandro# xfs_info /
meta-data=/dev/mapper/vol00-root isize=256    agcount=17, agsize=1600000
blks
         =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=26781696,
imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=12500, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


root fs on lvm on dm_crypt
to run xfs_repair I have to boot from a live distribution that support
this stack, I need some time

> 
> Also, I note that you are using ext4 on some disks. Does this
> problem show up if you don't use ext4 at all? (We have had problems
> in the past with one filesystem not leaving bufferheads in the
> correct state and the system crashing when a different type of
> filesystem got them reallocated).

First time of this bug, not sure if it's ext4 related 
Ext4 disk is my personal mirror of data taken from my server, I can
reformat ext4 disk to xfs
Ironically I started test ext4 to replace xfs on this machine :-(

thanks 

> 
> Cheers,
> 
> Dave.
-- 
---
Cordiali Saluti
Alessandro Bono

