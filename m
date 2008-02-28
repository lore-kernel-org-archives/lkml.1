Return-Path: <linux-kernel-owner+w=401wt.eu-S1763534AbYB1BMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763534AbYB1BMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762991AbYB1BMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:12:31 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:46727 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762933AbYB1BMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:12:30 -0500
Subject: Re: RFC Labeled NFS Initial Code Review
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: hch@infradead.org
Cc: viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: multipart/mixed; boundary="=-OpE4U3oKosh7q6w1THyu"
Date: Wed, 27 Feb 2008 19:48:10 -0500
Message-Id: <1204159690.24345.17.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OpE4U3oKosh7q6w1THyu
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I have prepared the nfs-utils patch for those who want to test the code.
I have attached it to this email and it applies on top of the nfs-utils
git tree at commit hash 9dd9b68c4c44f0d9102eb85ee2fa36a8b7f638e3. The
reply to this email will contain all of the kernel changes rolled into
one patch.

Dave

--=-OpE4U3oKosh7q6w1THyu
Content-Disposition: attachment; filename=nfs-utils-02272008.patch
Content-Type: text/x-patch; name=nfs-utils-02272008.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/support/include/nfs/export.h b/support/include/nfs/export.h
index f7a99ba..020a599 100644
--- a/support/include/nfs/export.h
+++ b/support/include/nfs/export.h
@@ -17,7 +17,8 @@
 #define NFSEXP_ALLSQUASH	0x0008
 #define NFSEXP_ASYNC		0x0010
 #define NFSEXP_GATHERED_WRITES	0x0020
-/* 40, 80, 100 unused */
+#define NFSEXP_SECURITY_LABEL	0x0040
+/* 80, 100 unused */
 #define NFSEXP_NOHIDE		0x0200
 #define NFSEXP_NOSUBTREECHECK	0x0400
 #define NFSEXP_NOAUTHNLM	0x0800
diff --git a/support/nfs/exports.c b/support/nfs/exports.c
index 525e5b1..4694d02 100644
--- a/support/nfs/exports.c
+++ b/support/nfs/exports.c
@@ -237,6 +237,8 @@ putexportent(struct exportent *ep)
 	fprintf(fp, "%ssync,", (ep->e_flags & NFSEXP_ASYNC)? "a" : "");
 	fprintf(fp, "%swdelay,", (ep->e_flags & NFSEXP_GATHERED_WRITES)?
 				"" : "no_");
+	fprintf(fp, "%ssecurity_label,", (ep->e_flags & NFSEXP_SECURITY_LABEL)?
+				"" : "no_");
 	fprintf(fp, "%shide,", (ep->e_flags & NFSEXP_NOHIDE)?
 				"no" : "");
 	fprintf(fp, "%scrossmnt,", (ep->e_flags & NFSEXP_CROSSMOUNT)?
@@ -536,6 +538,10 @@ parseopts(char *cp, struct exportent *ep, int warn, int *had_subtree_opt_ptr)
 			setflags(NFSEXP_ROOTSQUASH, active, ep);
 		else if (!strcmp(opt, "no_root_squash"))
 			clearflags(NFSEXP_ROOTSQUASH, active, ep);
+		else if (!strcmp(opt, "security_label"))
+			ep->e_flags |= NFSEXP_SECURITY_LABEL;
+		else if (strcmp(opt, "no_security_label") == 0)
+			ep->e_flags &= ~NFSEXP_SECURITY_LABEL;
 		else if (strcmp(opt, "all_squash") == 0)
 			setflags(NFSEXP_ALLSQUASH, active, ep);
 		else if (strcmp(opt, "no_all_squash") == 0)
diff --git a/utils/exportfs/exportfs.c b/utils/exportfs/exportfs.c
index 18dfe5a..fdba2f2 100644
--- a/utils/exportfs/exportfs.c
+++ b/utils/exportfs/exportfs.c
@@ -470,6 +470,8 @@ dump(int verbose)
 				c = dumpopt(c, "async");
 			if (ep->e_flags & NFSEXP_GATHERED_WRITES)
 				c = dumpopt(c, "wdelay");
+			if (ep->e_flags & NFSEXP_SECURITY_LABEL)
+				c = dumpopt(c, "security_label");
 			if (ep->e_flags & NFSEXP_NOHIDE)
 				c = dumpopt(c, "nohide");
 			if (ep->e_flags & NFSEXP_CROSSMOUNT)

--=-OpE4U3oKosh7q6w1THyu--

