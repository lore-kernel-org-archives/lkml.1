Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbXKOHv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbXKOHv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXKOHvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:51:48 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:56309 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXKOHvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:51:47 -0500
Date: Thu, 15 Nov 2007 08:51:36 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Benny Halevy <bhalevy@panasas.com>, Chris Wedgwood <cw@f00f.org>,
       linux-xfs@oss.sgi.com
Subject: Re: 2.6.24-rc2 XFS nfsd hang / smbd too
In-Reply-To: <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
Message-ID: <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Christian Kujau wrote:
> Yes, the nfsd process only got stuck when I did ls(1) (with or without -l) on 
> a NFS share which contained a XFS partition.

Since NFS was not working (the nfsd processes were already in D state), to 
mount a CIFS share from the very same server (and the same client). I'm 
exporting the same /data share (JFS), but, since it's smbd I don't have to 
export every single submount (as it is with NFS):

* with NFS:
server:/data      (jfs)
server:/data/sub  (xfs)

* with CIFS:
server:/data      (containing both the jfs and the xfs partition as one
                    single share to mount)

Upon accessing the /data/sub part of the CIFS share, the client hung, 
waiting for the server to respond (the [cifs] kernel thread on the client 
was spinning, waiting for i/o). On the server, similar things as with the 
nfsd processes happened (although I know that the smbd (Samba) processes 
are running completely in userspace):

http://nerdbynature.de/bits/2.6.24-rc2/nfsd/debug.3.txt.gz

Sysrq-t again on the server:
http://nerdbynature.de/bits/2.6.24-rc2/nfsd/dmesg.3.gz

smbd          D c04131c0     0 22782   3039
       e242ad60 00000046 e242a000 c04131c0 00000001 e7875264 00000246 e7f88a80
       e242ada8 c040914c 00000000 00000002 c016dc64 e7a3b7b8 e242a000 e7875284
       00000000 c016dc64 f7343d88 f6337e90 e7f88a80 e7875264 e242ad88 e7a3b7b8
Call Trace:
[<c040914c>] mutex_lock_nested+0xcc/0x2c0
[<c016dc64>] do_lookup+0xa4/0x190
[<c016f6f9>] __link_path_walk+0x749/0xd10
[<c016fd04>] link_path_walk+0x44/0xc0
[<c016fd98>] path_walk+0x18/0x20
[<c016ff98>] do_path_lookup+0x78/0x1c0
[<c0170998>] __user_walk_fd+0x38/0x60
[<c0169bd1>] vfs_stat_fd+0x21/0x50
[<c0169ca1>] vfs_stat+0x11/0x20
[<c0169cc4>] sys_stat64+0x14/0x30
[<c01028d6>] sysenter_past_esp+0x5f/0xa5
=======================

So, it's really not NFS but ?FS related?

Christian.
-- 
BOFH excuse #199:

the curls in your keyboard cord are losing electricity.
