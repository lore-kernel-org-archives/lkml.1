Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbXGRHib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbXGRHib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXGRHiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:38:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:23896 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbXGRHiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kykU7ehdkCqAjY/Jv6LkP9Xe09O3hyv+Ys1hQXerWV7FJwd45xoHcrhzcsPNjGulsqz3J9HEGtgm6wnEY9Vy+gjo3wlRUfaPrOh/ZplS6IFl0OiXBm2m01Uyd/eud8d4ttqpMyEOciiPaXwnbiSOaKWWqdLXbH0+bXn8dx0SCfg=
Date: Wed, 18 Jul 2007 16:38:11 +0900
From: Tejun Heo <htejun@gmail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: [PATCH] sysfs: cosmetic clean up on node creation failure paths
Message-ID: <20070718073811.GA22374@htj.dyndns.org>
References: <469A5C94.7030201@googlemail.com> <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com> <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com> <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com> <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com> <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com> <20070718071445.GI23568@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718071445.GI23568@htj.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Node addition failure is detected by testing return value of
sysfs_addfm_finish() which returns the number of added and removed
nodes.  As the function is called as the last step of addition right
on top of error handling block, the if blocks looked like the
following.

	if (sysfs_addrm_finish(&acxt))
		success handling, usually return;
	/* fall through to error handling */

This is the opposite of usual convention in sysfs and makes the code
difficult to understand.  This patch inverts the test and makes those
blocks look more like others.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |   12 +++++++-----
 fs/sysfs/file.c    |    9 +++++----
 fs/sysfs/symlink.c |   10 ++++++----
 3 files changed, 18 insertions(+), 13 deletions(-)

Index: work/fs/sysfs/dir.c
===================================================================
--- work.orig/fs/sysfs/dir.c
+++ work/fs/sysfs/dir.c
@@ -698,17 +698,19 @@ static int create_dir(struct kobject *ko
 
 	/* link in */
 	sysfs_addrm_start(&acxt, parent_sd);
+
 	if (!sysfs_find_dirent(parent_sd, name)) {
 		sysfs_add_one(&acxt, sd);
 		sysfs_link_sibling(sd);
 	}
-	if (sysfs_addrm_finish(&acxt)) {
-		*p_sd = sd;
-		return 0;
+
+	if (!sysfs_addrm_finish(&acxt)) {
+		sysfs_put(sd);
+		return -EEXIST;
 	}
 
-	sysfs_put(sd);
-	return -EEXIST;
+	*p_sd = sd;
+	return 0;
 }
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
Index: work/fs/sysfs/file.c
===================================================================
--- work.orig/fs/sysfs/file.c
+++ work/fs/sysfs/file.c
@@ -410,11 +410,12 @@ int sysfs_add_file(struct sysfs_dirent *
 		sysfs_link_sibling(sd);
 	}
 
-	if (sysfs_addrm_finish(&acxt))
-		return 0;
+	if (!sysfs_addrm_finish(&acxt)) {
+		sysfs_put(sd);
+		return -EEXIST;
+	}
 
-	sysfs_put(sd);
-	return -EEXIST;
+	return 0;
 }
 
 
Index: work/fs/sysfs/symlink.c
===================================================================
--- work.orig/fs/sysfs/symlink.c
+++ work/fs/sysfs/symlink.c
@@ -97,11 +97,13 @@ int sysfs_create_link(struct kobject * k
 		sysfs_link_sibling(sd);
 	}
 
-	if (sysfs_addrm_finish(&acxt))
-		return 0;
+	if (!sysfs_addrm_finish(&acxt)) {
+		error = -EEXIST;
+		goto out_put;
+	}
+
+	return 0;
 
-	error = -EEXIST;
-	/* fall through */
  out_put:
 	sysfs_put(target_sd);
 	sysfs_put(sd);
