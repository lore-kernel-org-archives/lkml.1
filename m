Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZDWH37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZDWH37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZDWH11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:27 -0400
Received: from sous-sol.org ([216.99.217.87]:48159 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754703AbZDWH1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:19 -0400
Message-Id: <20090423072059.454637347@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Etienne Basset <etienne.basset@numericable.fr>,
       Paul Moore <paul.moore@hp.com>
Subject: [patch 001/100] security/smack: fix oops when setting a size 0 SMACK64 xattr
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=security-smack-fix-oops-when-setting-a-size-0-smack64-xattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Etienne Basset <etienne.basset@numericable.fr>

upstream commit: 4303154e86597885bc3cbc178a48ccbc8213875f

this patch fix an oops in smack when setting a size 0 SMACK64 xattr eg  
attr -S -s SMACK64  -V '' somefile
This oops because smk_import_entry treats a 0 length as SMK_MAXLEN

Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
---
 security/smack/smack_lsm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -607,6 +607,8 @@ static int smack_inode_setxattr(struct d
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
+		if (size == 0)
+			rc = -EINVAL;
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
 
@@ -1430,7 +1432,7 @@ static int smack_inode_setsecurity(struc
 	struct socket *sock;
 	int rc = 0;
 
-	if (value == NULL || size > SMK_LABELLEN)
+	if (value == NULL || size > SMK_LABELLEN || size == 0)
 		return -EACCES;
 
 	sp = smk_import(value, size);

