Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYERO0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYERO0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 10:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYERO0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 10:26:21 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:48930 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYERO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 10:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=wrUQQdJ5okzL0z+VSwiIdFpNzpXkS1VCMkhmEKNrZ/NdNe6CFHT8du6EDTIkWEv/Pah7FBKvuulEnyHzVQDk3pfXF2oYn2ds1UakKvyzSD6mNtZF66WglD2JmeIRCGkziVKMzklCzhcbiQV6qWlNgIi6DpE0lE13eDzOzZCTz1I=
Date: Sun, 18 May 2008 18:26:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Michael A. Halcrow" <mhalcrow@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptFS: fix missed mutex_unlock
Message-ID: <20080518142611.GA18000@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

Ingo, could you please apply it and test? Actually I really doubt if it help
with the locking problem you pointed. There are two procedures
in miscrev.c - ecryptfs_miscdev_poll() and ecryptfs_miscdev_read()
which takes/releases mutexes in a bit strange way... investigating,
but this patch is needed anyway.

Index: linux-2.6.git/fs/ecryptfs/crypto.c
===================================================================
--- linux-2.6.git.orig/fs/ecryptfs/crypto.c	2008-05-18 16:44:20.000000000 +0400
+++ linux-2.6.git/fs/ecryptfs/crypto.c	2008-05-18 17:56:12.000000000 +0400
@@ -1903,6 +1903,7 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 		if (rc) {
 			printk(KERN_ERR "Error adding new key_tfm to list; "
 					"rc = [%d]\n", rc);
+			mutex_unlock(&key_tfm_list_mutex);
 			goto out;
 		}
 	}
