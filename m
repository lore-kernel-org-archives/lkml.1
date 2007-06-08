Return-Path: <linux-kernel-owner+w=401wt.eu-S971481AbXFHWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971481AbXFHWeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971340AbXFHWdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:33:18 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:60893
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S971253AbXFHWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:33:16 -0400
Message-ID: <4669D698.3010304@hawkeye.stone.uk.eu.org>
Date: Fri, 08 Jun 2007 23:22:16 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, raven@themaw.net
Subject: [PATCH 3/7] Replace DPRINTK with pr_debug in autofs
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
-#ifdef DEBUG
-#define DPRINTK(D) (printk D)
-#else
-#define DPRINTK(D) ((void)0)
-#endif
-
 /*
  * If the daemon returns a negative response (AUTOFS_IOC_FAIL) then the
  * kernel will keep the negative response cached for up to the time given
Index: linux/fs/autofs/dirhash.c
===================================================================
--- linux.orig/fs/autofs/dirhash.c
+++ linux/fs/autofs/dirhash.c
@@ -77,7 +77,7 @@ struct autofs_dir_ent *autofs_expire(str
 		/* Make sure entry is mounted and unused; note that dentry will
 		   point to the mounted-on-top root. */
 		if (!S_ISDIR(dentry->d_inode->i_mode)||!d_mountpoint(dentry)) {
-			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n",
ent->name));
+			pr_debug("autofs: not expirable (not a mounted directory): %s\n",
ent->name);
 			continue;
 		}
 		mntget(mnt);
@@ -85,7 +85,7 @@ struct autofs_dir_ent *autofs_expire(str
 		if (!follow_down(&mnt, &dentry)) {
 			dput(dentry);
 			mntput(mnt);
-			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n",
ent->name));
+			pr_debug("autofs: not expirable (not a mounted directory): %s\n",
ent->name);
 			continue;
 		}
 		while (d_mountpoint(dentry) && follow_down(&mnt, &dentry))
@@ -94,10 +94,10 @@ struct autofs_dir_ent *autofs_expire(str

 		if ( may_umount(mnt) ) {
 			mntput(mnt);
-			DPRINTK(("autofs: signaling expire on %s\n", ent->name));
+			pr_debug("autofs: signaling expire on %s\n", ent->name);
 			return ent; /* Expirable! */
 		}
-		DPRINTK(("autofs: didn't expire due to may_umount: %s\n", ent->name));
+		pr_debug("autofs: didn't expire due to may_umount: %s\n", ent->name);
 		mntput(mnt);
 	}
 	return NULL;		/* No expirable entries */
@@ -112,7 +112,7 @@ struct autofs_dir_ent *autofs_hash_looku
 {
 	struct autofs_dir_ent *dhn;

-	DPRINTK(("autofs_hash_lookup: hash = 0x%08x, name = ", name->hash));
+	pr_debug("autofs_hash_lookup: hash = 0x%08x, name = ", name->hash);
 	autofs_say(name->name,name->len);

 	for ( dhn = dh->h[(unsigned) name->hash % AUTOFS_HASH_SIZE] ; dhn ;
dhn = dhn->next ) {
@@ -129,7 +129,7 @@ void autofs_hash_insert(struct autofs_di
 {
 	struct autofs_dir_ent **dhnp;

-	DPRINTK(("autofs_hash_insert: hash = 0x%08x, name = ", ent->hash));
+	pr_debug("autofs_hash_insert: hash = 0x%08x, name = ", ent->hash);
 	autofs_say(ent->name,ent->len);

 	autofs_init_usage(dh,ent);
@@ -179,7 +179,7 @@ struct autofs_dir_ent *autofs_hash_enum(
 		bucket = ecount = 0;
 	}

-	DPRINTK(("autofs_hash_enum: bucket %d, entry %d\n", bucket, ecount));
+	pr_debug("autofs_hash_enum: bucket %d, entry %d\n", bucket, ecount);

 	ent = last ? last->next : NULL;

Index: linux/fs/autofs/inode.c
===================================================================
--- linux.orig/fs/autofs/inode.c
+++ linux/fs/autofs/inode.c
@@ -48,7 +48,7 @@ void autofs_kill_sb(struct super_block *
 	kfree(sb->s_fs_info);

 out_kill_sb:
-	DPRINTK(("autofs: shutting down\n"));
+	pr_debug("autofs: shutting down\n");
 	kill_anon_super(sb);
 }

@@ -146,7 +146,7 @@ int autofs_fill_super(struct super_block
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
-	DPRINTK(("autofs: starting up, sbi = %p\n",sbi));
+	pr_debug("autofs: starting up, sbi = %p\n",sbi);

 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
@@ -186,7 +186,7 @@ int autofs_fill_super(struct super_block
 		goto fail_dput;
 	}

-	DPRINTK(("autofs: pipe fd = %d, pgrp = %u\n", pipefd, pgid));
+	pr_debug("autofs: pipe fd = %d, pgrp = %u\n", pipefd, pgid);
 	sbi->oz_pgrp = find_get_pid(pgid);

 	if (!sbi->oz_pgrp) {
Index: linux/fs/autofs/root.c
===================================================================
--- linux.orig/fs/autofs/root.c
+++ linux/fs/autofs/root.c
@@ -201,7 +201,7 @@ static struct dentry *autofs_root_lookup
 	struct autofs_sb_info *sbi;
 	int oz_mode;

-	DPRINTK(("autofs_root_lookup: name = "));
+	pr_debug("autofs_root_lookup: name = ");
 	lock_kernel();
 	autofs_say(dentry->d_name.name,dentry->d_name.len);

@@ -213,10 +213,10 @@ static struct dentry *autofs_root_lookup
 	sbi = autofs_sbi(dir->i_sb);

 	oz_mode = autofs_oz_mode(sbi);
-	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
+	pr_debug("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
 				"oz_mode = %d\n", pid_nr(task_pid(current)),
 				process_group(current), sbi->catatonic,
-				oz_mode));
+				oz_mode);

 	/*
 	 * Mark the dentry incomplete, but add it. This is needed so
@@ -275,7 +275,7 @@ static int autofs_root_symlink(struct in
 	int slsize;
 	struct autofs_symlink *sl;

-	DPRINTK(("autofs_root_symlink: %s <- ", symname));
+	pr_debug("autofs_root_symlink: %s <- ", symname);
 	autofs_say(dentry->d_name.name,dentry->d_name.len);

 	lock_kernel();
@@ -536,7 +536,7 @@ static int autofs_root_ioctl(struct inod
 	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
 	void __user *argp = (void __user *)arg;

-	DPRINTK(("autofs_ioctl: cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp =
%u\n",cmd,arg,sbi,process_group(current)));
+	pr_debug("autofs_ioctl: cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp =
%u\n",cmd,arg,sbi,process_group(current));

 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
Index: linux/fs/autofs/waitq.c
===================================================================
--- linux.orig/fs/autofs/waitq.c
+++ linux/fs/autofs/waitq.c
@@ -27,7 +27,7 @@ void autofs_catatonic_mode(struct autofs
 {
 	struct autofs_wait_queue *wq, *nwq;

-	DPRINTK(("autofs: entering catatonic mode\n"));
+	pr_debug("autofs: entering catatonic mode\n");

 	sbi->catatonic = 1;
 	wq = sbi->queues;
@@ -84,7 +84,7 @@ static void autofs_notify_daemon(struct
 {
 	struct autofs_packet_missing pkt;

-	DPRINTK(("autofs_wait: wait id = 0x%08lx, name = ",
wq->wait_queue_token));
+	pr_debug("autofs_wait: wait id = 0x%08lx, name = ", wq->wait_queue_token);
 	autofs_say(wq->name,wq->len);

 	memset(&pkt,0,sizeof pkt); /* For security reasons */
@@ -166,7 +166,7 @@ int autofs_wait(struct autofs_sb_info *s

 		sigprocmask(SIG_SETMASK, &sigmask, NULL);
 	} else {
-		DPRINTK(("autofs_wait: skipped sleeping\n"));
+		pr_debug("autofs_wait: skipped sleeping\n");
 	}

 	status = wq->status;

--

