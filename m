Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbXIQVPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbXIQVPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbXIQVIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:08:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52223 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbXIQVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:08:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=wEm1DPleVYZDCsVvPwyG0Q3Nr4g4P4U1/sVUbmoM2ya6LpTCEu5RTZYbCjCUG0Nfz
	Dd9+kRkbQmC3jt1T4VlnQ==
Message-Id: <20070917210428.382957000@menage.corp.google.com>
References: <20070917210307.116234000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Sep 2007 14:03:21 -0700
From: Paul Menage <menage@google.com>
To: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelianov <xemul@openvz.org>,
       David Rientjes <rientjes@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, pj@sgi.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/33] task-containersv11-basic-task-container-framework-containers-fix-refcount-bug
Content-Disposition: inline; filename=fixoops1.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a reference counting bug in cgroupfs

As part of the extraction of cpusetfs to cgroupfs, a call to
cpuset_get_dentry() was lost (justified by the fact that the dentry in
question was now being passed down by the caller).  Since
cpuset_get_dentry() called lookup_one_len(), this resulted in a reference
count being missed from the directory dentry.

This patch removes cgroup_get_dentry() and replaces it with direct calls
to lookup_one_len(); the initialization of cgroupfs dentry ops is done
now in cgroup_create_file() at dentry creation time.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

Index: linux-2.6.23-rc4-mm1-new/kernel/cgroup.c
===================================================================
--- linux-2.6.23-rc4-mm1-new.orig/kernel/cgroup.c
+++ linux-2.6.23-rc4-mm1-new/kernel/cgroup.c
@@ -604,19 +604,6 @@ static void cgroup_diput(struct dentry *
 	iput(inode);
 }
 
-static struct dentry *cgroup_get_dentry(struct dentry *parent,
-					   const char *name)
-{
-	struct dentry *d = lookup_one_len(name, parent, strlen(name));
-	static struct dentry_operations cgroup_dops = {
-		.d_iput = cgroup_diput,
-	};
-
-	if (!IS_ERR(d))
-		d->d_op = &cgroup_dops;
-	return d;
-}
-
 static void remove_dir(struct dentry *d)
 {
 	struct dentry *parent = dget(d->d_parent);
@@ -1507,6 +1494,10 @@ static struct inode_operations cgroup_di
 static int cgroup_create_file(struct dentry *dentry, int mode,
 				struct super_block *sb)
 {
+	static struct dentry_operations cgroup_dops = {
+		.d_iput = cgroup_diput,
+	};
+
 	struct inode *inode;
 
 	if (!dentry)
@@ -1532,7 +1523,7 @@ static int cgroup_create_file(struct den
 		inode->i_size = 0;
 		inode->i_fop = &cgroup_file_operations;
 	}
-
+	dentry->d_op = &cgroup_dops;
 	d_instantiate(dentry, inode);
 	dget(dentry);	/* Extra count - pin the dentry in core */
 	return 0;
@@ -1553,13 +1544,12 @@ static int cgroup_create_dir(struct cgro
 	int error = 0;
 
 	parent = cont->parent->dentry;
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
 	error = cgroup_create_file(dentry, S_IFDIR | mode, cont->root->sb);
 	if (!error) {
 		dentry->d_fsdata = cont;
 		inc_nlink(parent->d_inode);
 		cont->dentry = dentry;
+		dget(dentry);
 	}
 	dput(dentry);
 
@@ -1581,7 +1571,7 @@ int cgroup_add_file(struct cgroup *cont,
 	}
 	strcat(name, cft->name);
 	BUG_ON(!mutex_is_locked(&dir->d_inode->i_mutex));
-	dentry = cgroup_get_dentry(dir, name);
+	dentry = lookup_one_len(name, dir, strlen(name));
 	if (!IS_ERR(dentry)) {
 		error = cgroup_create_file(dentry, 0644 | S_IFREG,
 						cont->root->sb);

--
