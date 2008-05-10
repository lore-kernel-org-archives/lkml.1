Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYEJIpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYEJIpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 04:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYEJIpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 04:45:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:35059 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYEJIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 04:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=P8Ee+FSwAgzASEBMOycguYYAtmuUtbItT53ccp134mQNNscZc/LC/twTSbd7Q01nf9u3VerazMZzFqaa/dIyYQw+lwFeFIYUgz6Wbp58sB30R47puBIsXxmVleFz2F85QYyRVMJctHTYte8AiUyvkxNehwLvDM8jbf0FcE1GTSo=
Date: Sat, 10 May 2008 12:45:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Michael A. Halcrow" <mhalcrow@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptFS: fix imbalanced mutex locking
Message-ID: <20080510084509.GA6872@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix imbalanced calls for mutex lock/unlock on ecryptfs_daemon_hash_mux

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Revealed by Ingo Molnar: http://lkml.org/lkml/2008/5/7/260

Please test and rewview

Index: linux-2.6.git/fs/ecryptfs/miscdev.c
===================================================================
--- linux-2.6.git.orig/fs/ecryptfs/miscdev.c	2008-04-29 22:56:53.000000000 +0400
+++ linux-2.6.git/fs/ecryptfs/miscdev.c	2008-05-10 12:40:22.000000000 +0400
@@ -257,12 +257,14 @@ ecryptfs_miscdev_read(struct file *file,
 	mutex_lock(&daemon->mux);
 	if (daemon->flags & ECRYPTFS_DAEMON_ZOMBIE) {
 		rc = 0;
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		printk(KERN_WARNING "%s: Attempt to read from zombified "
 		       "daemon\n", __func__);
 		goto out_unlock_daemon;
 	}
 	if (daemon->flags & ECRYPTFS_DAEMON_IN_READ) {
 		rc = 0;
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto out_unlock_daemon;
 	}
 	/* This daemon will not go away so long as this flag is set */
