Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbYFWPkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbYFWPkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbYFWPke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:40:34 -0400
Received: from mx2.netapp.com ([216.240.18.37]:50298 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbYFWPkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:40:33 -0400
X-IronPort-AV: E=Sophos;i="4.27,690,1204531200"; 
   d="dif'208?scan'208,208";a="106134274"
Subject: Re: NFS oops in 2.6.26rc4
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Dave Jones <davej@redhat.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, chucklever@gmail.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080604182015.GA20074@redhat.com>
References: <20080527190419.GA14577@redhat.com>
	 <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com>
	 <20080530182126.GB32480@redhat.com> <1212172308.8579.20.camel@localhost>
	 <20080530190314.GC32480@redhat.com>
	 <CEA741EF-8E34-40FD-82A8-747AE1B6E78F@oracle.com>
	 <20080604141958.GA14148@redhat.com>
	 <E1135064-06EA-405C-A967-DFB1DC9F0418@oracle.com>
	 <20080604182015.GA20074@redhat.com>
Content-Type: multipart/mixed; boundary="=-cHeNn6N57HlGJV1SONTr"
Organization: NetApp
Date: Mon, 23 Jun 2008 11:40:29 -0400
Message-Id: <1214235629.7205.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 23 Jun 2008 15:40:30.0680 (UTC) FILETIME=[77A5AD80:01C8D547]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cHeNn6N57HlGJV1SONTr
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Dave,

Any chance you could give the attached patch a whirl to see if it fixes
the NFS oops you reported?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

--=-cHeNn6N57HlGJV1SONTr
Content-Disposition: inline; filename=linux-2.6.26-001-reduce_mount_stack_usage.dif
Content-Type: message/rfc822; name=linux-2.6.26-001-reduce_mount_stack_usage.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Thu, 19 Jun 2008 14:20:11 -0400
Subject: NFS: Reduce the NFS mount code stack usage.
Message-Id: <1214235616.7205.18.camel@localhost>
Mime-Version: 1.0

This appears to fix the Oops reported in
  http://bugzilla.kernel.org/show_bug.cgi?id=10826

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/super.c |   68 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 2a4a024..dac663d 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1216,8 +1216,6 @@ static int nfs_validate_mount_data(void *options,
 {
 	struct nfs_mount_data *data = (struct nfs_mount_data *)options;
 
-	memset(args, 0, sizeof(*args));
-
 	if (data == NULL)
 		goto out_no_data;
 
@@ -1585,24 +1583,29 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 {
 	struct nfs_server *server = NULL;
 	struct super_block *s;
-	struct nfs_fh mntfh;
-	struct nfs_parsed_mount_data data;
+	struct nfs_parsed_mount_data *data;
+	struct nfs_fh *mntfh;
 	struct dentry *mntroot;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
 	struct nfs_sb_mountdata sb_mntdata = {
 		.mntflags = flags,
 	};
-	int error;
+	int error = -ENOMEM;
 
-	security_init_mnt_opts(&data.lsm_opts);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	mntfh = kzalloc(sizeof(*mntfh), GFP_KERNEL);
+	if (data == NULL || mntfh == NULL)
+		goto out_free_fh;
+
+	security_init_mnt_opts(&data->lsm_opts);
 
 	/* Validate the mount data */
-	error = nfs_validate_mount_data(raw_data, &data, &mntfh, dev_name);
+	error = nfs_validate_mount_data(raw_data, data, mntfh, dev_name);
 	if (error < 0)
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs_create_server(&data, &mntfh);
+	server = nfs_create_server(data, mntfh);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1630,16 +1633,16 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 
 	if (!s->s_root) {
 		/* initial superblock/root creation */
-		nfs_fill_super(s, &data);
+		nfs_fill_super(s, data);
 	}
 
-	mntroot = nfs_get_root(s, &mntfh);
+	mntroot = nfs_get_root(s, mntfh);
 	if (IS_ERR(mntroot)) {
 		error = PTR_ERR(mntroot);
 		goto error_splat_super;
 	}
 
-	error = security_sb_set_mnt_opts(s, &data.lsm_opts);
+	error = security_sb_set_mnt_opts(s, &data->lsm_opts);
 	if (error)
 		goto error_splat_root;
 
@@ -1649,9 +1652,12 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	error = 0;
 
 out:
-	kfree(data.nfs_server.hostname);
-	kfree(data.mount_server.hostname);
-	security_free_mnt_opts(&data.lsm_opts);
+	kfree(data->nfs_server.hostname);
+	kfree(data->mount_server.hostname);
+	security_free_mnt_opts(&data->lsm_opts);
+out_free_fh:
+	kfree(mntfh);
+	kfree(data);
 	return error;
 
 out_err_nosb:
@@ -1800,8 +1806,6 @@ static int nfs4_validate_mount_data(void *options,
 	struct nfs4_mount_data *data = (struct nfs4_mount_data *)options;
 	char *c;
 
-	memset(args, 0, sizeof(*args));
-
 	if (data == NULL)
 		goto out_no_data;
 
@@ -1959,26 +1963,31 @@ out_no_client_address:
 static int nfs4_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
 {
-	struct nfs_parsed_mount_data data;
+	struct nfs_parsed_mount_data *data;
 	struct super_block *s;
 	struct nfs_server *server;
-	struct nfs_fh mntfh;
+	struct nfs_fh *mntfh;
 	struct dentry *mntroot;
 	int (*compare_super)(struct super_block *, void *) = nfs_compare_super;
 	struct nfs_sb_mountdata sb_mntdata = {
 		.mntflags = flags,
 	};
-	int error;
+	int error = -ENOMEM;
 
-	security_init_mnt_opts(&data.lsm_opts);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	mntfh = kzalloc(sizeof(*mntfh), GFP_KERNEL);
+	if (data == NULL || mntfh == NULL)
+		goto out_free_fh;
+
+	security_init_mnt_opts(&data->lsm_opts);
 
 	/* Validate the mount data */
-	error = nfs4_validate_mount_data(raw_data, &data, dev_name);
+	error = nfs4_validate_mount_data(raw_data, data, dev_name);
 	if (error < 0)
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs4_create_server(&data, &mntfh);
+	server = nfs4_create_server(data, mntfh);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -2009,13 +2018,13 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 		nfs4_fill_super(s);
 	}
 
-	mntroot = nfs4_get_root(s, &mntfh);
+	mntroot = nfs4_get_root(s, mntfh);
 	if (IS_ERR(mntroot)) {
 		error = PTR_ERR(mntroot);
 		goto error_splat_super;
 	}
 
-	error = security_sb_set_mnt_opts(s, &data.lsm_opts);
+	error = security_sb_set_mnt_opts(s, &data->lsm_opts);
 	if (error)
 		goto error_splat_root;
 
@@ -2025,10 +2034,13 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 	error = 0;
 
 out:
-	kfree(data.client_address);
-	kfree(data.nfs_server.export_path);
-	kfree(data.nfs_server.hostname);
-	security_free_mnt_opts(&data.lsm_opts);
+	kfree(data->client_address);
+	kfree(data->nfs_server.export_path);
+	kfree(data->nfs_server.hostname);
+	security_free_mnt_opts(&data->lsm_opts);
+out_free_fh:
+	kfree(mntfh);
+	kfree(data);
 	return error;
 
 out_free:

--=-cHeNn6N57HlGJV1SONTr--
