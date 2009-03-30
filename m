Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbZC3BxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbZC3BxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZC3BxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:53:08 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:32806 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZC3BxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:53:06 -0400
Message-ID: <49D025FF.7090405@oss.ntt.co.jp>
Date: Mon, 30 Mar 2009 10:53:03 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] vfs: call blkdev_issue_flush from generic file_fsync
 helper
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp>
In-Reply-To: <49D01F94.6000101@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To ensure that bits are truly on-disk after an fsync or fdatasync
we should force a disk flush explicitly. This is necessary to
have data integrity guarantees in filesystems such as FAT which
do not provide their own fsync implementation and use the vfs
helper instead.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-orig/fs/sync.c linux-2.6.29/fs/sync.c
--- linux-2.6.29-orig/fs/sync.c	2009-03-24 08:12:14.000000000 +0900
+++ linux-2.6.29/fs/sync.c	2009-03-28 20:58:54.000000000 +0900
@@ -72,6 +72,11 @@ int file_fsync(struct file *filp, struct
  	err = sync_blockdev(sb->s_bdev);
  	if (!ret)
  		ret = err;
+
+	err = block_flush_device(sb);
+	if (!ret)
+		ret = err;
+
  	return ret;
  }

