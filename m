Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbZD2W1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbZD2W1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZD2WVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:25 -0400
Received: from kroah.org ([198.145.64.141]:40354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbZD2WVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:25 2009
Message-Id: <20090429220925.606219157@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 18/58] security/smack: fix oops when setting a size 0 SMACK64 xattr
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0001-security-smack-fix-oops-when-setting-a-size-0-SMACK.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Etienne Basset <etienne.basset@numericable.fr>

upstream commit: 4303154e86597885bc3cbc178a48ccbc8213875f

this patch fix an oops in smack when setting a size 0 SMACK64 xattr eg
attr -S -s SMACK64  -V '' somefile
This oops because smk_import_entry treats a 0 length as SMK_MAXLEN

Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 security/smack/smack_lsm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -604,6 +604,8 @@ static int smack_inode_setxattr(struct d
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
+		if (size == 0)
+			rc = -EINVAL;
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
 
@@ -1360,7 +1362,7 @@ static int smack_inode_setsecurity(struc
 	struct socket *sock;
 	int rc = 0;
 
-	if (value == NULL || size > SMK_LABELLEN)
+	if (value == NULL || size > SMK_LABELLEN || size == 0)
 		return -EACCES;
 
 	sp = smk_import(value, size);


