Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbYBZLKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbYBZLKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYBZLKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:10:36 -0500
Received: from styx.suse.cz ([82.119.242.94]:59372 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752145AbYBZLKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:10:35 -0500
Date: Tue, 26 Feb 2008 12:10:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Kara <jack@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Jan Kara <jack@ucw.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd
 related? dm-related?
In-Reply-To: <20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
 <m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
 <20080225123041.401da103.akpm@linux-foundation.org>
 <20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Jan Kara wrote:

>   Yes, exactly two of them. One is  non-trivial to get rid of - it's
> used for encoding of filename before we write it, 

Why can't we do just



UDF: Optimize stack usage

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 112a5fb..706a2b5 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -336,7 +336,7 @@ static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 {
 	struct super_block *sb = dir->i_sb;
 	struct fileIdentDesc *fi = NULL;
-	char name[UDF_NAME_LEN], fname[UDF_NAME_LEN];
+	char *name, *fname;
 	int namelen;
 	loff_t f_pos;
 	int flen;
@@ -352,6 +352,14 @@ static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 	struct extent_position epos = {};
 	struct udf_inode_info *dinfo;
 
+	name = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
+	fname = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
+
+	if (!name || !fname) {
+		*err = -ENOMEM;
+		return NULL;
+	}
+
 	if (dentry) {
 		if (!dentry->d_name.len) {
 			*err = -EINVAL;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index f3ac4ab..42e3ba8 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1345,7 +1345,7 @@ static void udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static int udf_process_sequence(struct super_block *sb, long block,
+static int noinline udf_process_sequence(struct super_block *sb, long block,
 				long lastblock, kernel_lb_addr *fileset)
 {
 	struct buffer_head *bh = NULL;
