Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXJZXly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXJZXly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXJZXjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:39:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763718AbXJZXiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:date:from:to:cc:subject:content-disposition;
	b=NqlfxhUCODtL/U7I/mHjFX3PjdlWRgOTR/If165BQmo/vECfQ20Vtt9mZj6J1rt68
	6dX07LP8UNb2HLBnN71rw==
Message-Id: <20071026233848.693899140@crlf.corp.google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
Date: Fri, 26 Oct 2007 16:37:36 -0700
From: Mike Waychison <mikew@google.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Subject: [patch 4/6][RFC] Attempt to plug race with truncate
Content-Disposition: inline; filename=fix_race_with_truncate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Attempt to deal with races with truncate paths.

I'm not really sure on the locking here, but these seem to be taken by the truncate path.  BKL is left as some filesystem may(?) still require it.

Signed-off-by: Mike Waychison <mikew@google.com>
 fs/ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.23/fs/ioctl.c
===================================================================
--- linux-2.6.23.orig/fs/ioctl.c	2007-10-26 15:27:29.000000000 -0700
+++ linux-2.6.23/fs/ioctl.c	2007-10-26 16:16:28.000000000 -0700
@@ -43,13 +43,21 @@ static long do_ioctl(struct file *filp, 
 static int do_fibmap(struct address_space *mapping, sector_t block,
 		     sector_t *phys_block)
 {
+	struct inode *inode = mapping->host;
+
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 	if (!mapping->a_ops->bmap)
 		return -EINVAL;
 
 	lock_kernel();
+	/* Avoid races with truncate */
+	mutex_lock(&inode->i_mutex);
+	/* FIXME: Do we really need i_alloc_sem? */
+	down_read(&inode->i_alloc_sem);
 	*phys_block = mapping->a_ops->bmap(mapping, block);
+	up_read(&inode->i_alloc_sem);
+	mutex_unlock(&inode->i_mutex);
 	unlock_kernel();
 
 	return 0;

--
