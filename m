Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbZKLHtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbZKLHtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZKLHtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:49:22 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51216 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbZKLHtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:49:21 -0500
Date: Thu, 12 Nov 2009 08:49:24 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Message-ID: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As observed by Joe Perches, sizeof of a constant string includes the
trailing 0.  If what is wanted is to check the initial characters of
another string, this trailing 0 should not be taken into account.  If an
exact match is wanted, strcmp should be used instead.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression foo;
constant char *abc;
@@

strncmp(foo, abc, 
- sizeof(abc)
+ sizeof(abc)-1
 )
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/security/selinux/hooks.c b/security/selinux/hooks.c
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -448,7 +448,7 @@ static int sb_finish_set_opts(struct sup
 		sbsec->flags &= ~SE_SBLABELSUPP;
 
 	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
-	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
+	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs") - 1) == 0)
 		sbsec->flags |= SE_SBLABELSUPP;
 
 	/* Initialize the root inode. */
