Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbXF1Qtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbXF1Qtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759834AbXF1Qtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:49:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51282 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbXF1Qtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:49:31 -0400
Date: Thu, 28 Jun 2007 11:49:27 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: get_file_caps cleanups
Message-ID: <20070628164927.GA14694@sergelap.austin.ibm.com>
References: <20070628002041.GA10429@sergelap.austin.ibm.com> <468350D1.9010902@kernel.org> <20070628134702.GB29641@sergelap.austin.ibm.com> <4683E17A.3060706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4683E17A.3060706@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge E. Hallyn wrote:
> >>>>  		kfree(dcaps);
> > Move this two lines down (rc defaults to 0 in goto above):
> > from here-->
> >>>> +clear_caps:
> >>>> +	if (rc) {
> > to here-->
> > 
> >> Hmm?  But if we succeeded we still want to free dcaps if we
> >> kmalloc()'d it.
> 
> I wasn't clear enough... Let me try again with different words.
> 
> If you look at your patch, you will see that the only use of the label
> 'clear_caps:' is as a jump target from a location in which rc=0. As
> such, you will *not* clear the bprm->cap_* sets... This is the reverse
> of what you intended to do.
> 
> You need to put the jump target 'inside' the 'if (rc) { <-here ... }'.

Oops!  Good catch, thanks.  New patch follows:

>From 9e8d4dd0486c85e269a062a4637a8b6296fcb80b Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 27 Jun 2007 19:55:27 -0400
Subject: [PATCH 1/1] file capabilities: get_file_caps cleanups

Two cleanups relating to set_file caps.

Rename set_file_caps to get_file_caps, since we are getting
the file capabilities, and setting the bprm caps to them.

Move the clearing of bprm caps into get_file_caps, and do it
only when we don't copy them from the capability xattr.

Changelog:
	Fix location of 'clear_caps' label.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 24de4fa..cc50a61 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -135,21 +135,20 @@ static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
 }
 
 /* Locate any VFS capabilities: */
-static int set_file_caps(struct linux_binprm *bprm)
+static int get_file_caps(struct linux_binprm *bprm)
 {
 	struct dentry *dentry;
-	int rc;
+	int rc = 0;
 	struct vfs_cap_data_disk_v1 v1caps;
 	struct vfs_cap_data_disk *dcaps;
 	struct inode *inode;
 
 	dcaps = (struct vfs_cap_data_disk *)&v1caps;
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
-		return 0;
+		goto clear_caps;
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
-	rc = 0;
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
@@ -187,12 +186,21 @@ out:
 	dput(dentry);
 	if ((void *)dcaps != (void *)&v1caps)
 		kfree(dcaps);
+	if (rc) {
+clear_caps:
+		cap_clear (bprm->cap_inheritable);
+		cap_clear (bprm->cap_permitted);
+		cap_clear (bprm->cap_effective);
+	}
 	return rc;
 }
 
 #else
-static inline int set_file_caps(struct linux_binprm *bprm)
+static inline int get_file_caps(struct linux_binprm *bprm)
 {
+	cap_clear (bprm->cap_inheritable);
+	cap_clear (bprm->cap_permitted);
+	cap_clear (bprm->cap_effective);
 	return 0;
 }
 #endif
@@ -201,13 +209,7 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 {
 	int ret;
 
-	/* Copied from fs/exec.c:prepare_binprm. */
-
-	cap_clear (bprm->cap_inheritable);
-	cap_clear (bprm->cap_permitted);
-	cap_clear (bprm->cap_effective);
-
-	ret = set_file_caps(bprm);
+	ret = get_file_caps(bprm);
 
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
-- 
1.5.1.1.GIT

