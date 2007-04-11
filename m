Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXDKTPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXDKTPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965025AbXDKTPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:15:21 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57239 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964893AbXDKTPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:15:19 -0400
Date: Wed, 11 Apr 2007 12:15:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-04-11-02-24.tar.gz uploaded
Message-Id: <20070411121515.56425c23.akpm@linux-foundation.org>
In-Reply-To: <461D22E5.9030705@googlemail.com>
References: <200704110926.l3B9Qe3D000895@shell0.pdx.osdl.net>
	<461D22E5.9030705@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 20:03:17 +0200
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> akpm@linux-foundation.org napisa__(a):
> > The mm snapshot broken-out-2007-04-11-02-24.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-11-02-24.tar.gz
> > 
> > It contains the following patches against 2.6.21-rc6:
> > 
> 
> After a few seconds of running test_mount_fs.sh
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/test_mount_fs.sh
> I get this
> 
> [11083.747512] Filesystem "loop4": Disabling barriers, not supported by the underlying device
> [11083.759050] XFS mounting filesystem loop4
> [11083.763769] Slab corruption: xfs_buf start=cce14938, len=272
> [11083.769986] Redzone: 0x5a2cf071/0x5a2cf071.
> [11083.774575] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
> [11083.781146] 0b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6c 6b 6b 6b
> [11083.787988] Prev obj: start=cce1481c, len=272
> [11083.792488] Redzone: 0x5a2cf071/0x5a2cf071.
> [11083.796828] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
> [11083.803131] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> [11083.810392] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> [11083.817677] Next obj: start=cce14a54, len=272
> [11083.822146] Redzone: 0x5a2cf071/0x5a2cf071.
> [11083.826415] Last user: [<fddaacde>](xfs_buf_free+0x77/0x7b [xfs])
> [11083.832784] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> [11083.839403] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> [11083.852797] Ending clean XFS mount for filesystem: loop4
> [11083.865789] SELinux: initialized (dev loop4, type xfs), uses xattr
> 

It does appear that someone (probably XFS) has done a use-after-free.

One way in which you perhaps catch this is to do:

--- a/fs/xfs/linux-2.6/xfs_buf.h~a
+++ a/fs/xfs/linux-2.6/xfs_buf.h
@@ -151,6 +151,7 @@ typedef struct xfs_buf {
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
+	char crap[1024];
 } xfs_buf_t;
 

and to then compile with CONFIG_DEBUG_PAGEALLOC.  The enlarged xfs_buf will
then get unmap-when-freed treatment and hopefully you'll get a nice oops
from the instruction which is corrupting that memory.  

>
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/serialconsole.log
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-11-02-24/mm-config
> 
> BTW. I wonder when this bug will be fixed
> [11050.534896] =============================================
> [11050.541883] [ INFO: possible recursive locking detected ]
> [11050.547425] 2.6.21-rc6-mm1-1 #1
> [11050.550630] ---------------------------------------------
> [11050.556142] umount/3359 is trying to acquire lock:
> [11050.561060]  (&(&ip->i_lock)->mr_lock){----}, at: [<fdd8729a>] xfs_ilock+0x4d/0x6e [xfs]
> [11050.569565] 
> [11050.569567] but task is already holding lock:
> [11050.575487]  (&(&ip->i_lock)->mr_lock){----}, at: [<fdd8729a>] xfs_ilock+0x4d/0x6e [xfs]

An xfs thing.

> Otherwise, for me it's another stable kernel

Thanks again.

