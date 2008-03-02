Return-Path: <linux-kernel-owner+w=401wt.eu-S1759759AbYCBV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbYCBV0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbYCBV0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:26:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:48387 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756663AbYCBV0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:26:07 -0500
Date: Sun, 2 Mar 2008 22:26:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Olsa <olsajiri@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>,
       peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
In-Reply-To: <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz>
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz>
 <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008, Jiri Kosina wrote:

> Could you please try what is the output with the attached patch below, so 
> that we know which spinlock buggers?

Uhm, and hereby I attach the patch.

diff --git a/ipc/shm.c b/ipc/shm.c
index c47e872..2abfb70 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -615,6 +615,7 @@ static void shm_get_stat(struct ipc_namespace *ns, unsigned long *rss,
 			*rss += (HPAGE_SIZE/PAGE_SIZE)*mapping->nrpages;
 		} else {
 			struct shmem_inode_info *info = SHMEM_I(inode);
+			printk(KERN_DEBUG "info: %p\n", info);
 			spin_lock(&info->lock);
 			*rss += inode->i_mapping->nrpages;
 			*swp += info->swapped;
diff --git a/ipc/util.c b/ipc/util.c
index fd1b50d..5a0d4d2 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -662,6 +662,7 @@ struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 
 	up_read(&ids->rw_mutex);
 
+	printk(KERN_DEBUG "out: %p\n", out);
 	spin_lock(&out->lock);
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock
