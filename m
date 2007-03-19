Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbXCSJWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbXCSJWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXCSJWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:22:11 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34813 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752917AbXCSJWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:22:07 -0400
Date: Mon, 19 Mar 2007 10:22:11 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: sysfs_drop_dentry(): possible NULL dereference
Message-ID: <20070319092211.GG752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following incorrect part of
commit 94bebf4d1b8e7719f0f3944c037a21cfd99a4af7:

<--  snip  -->

...
 void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 {
        struct dentry * dentry = sd->s_dentry;
+       struct inode *inode;
 
        if (dentry) {
                spin_lock(&dcache_lock);
                spin_lock(&dentry->d_lock);
                if (!(d_unhashed(dentry) && dentry->d_inode)) {
+                       inode = dentry->d_inode;
+                       spin_lock(&inode->i_lock);
...

<--  snip  -->

If (!dentry->d_inode), then it's a NULL dereference.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

