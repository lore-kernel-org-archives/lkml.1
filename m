Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYGGQyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYGGQyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbYGGQuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:23 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755415AbYGGQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:16 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] SELinux: more user friendly unknown handling printk
Date: Tue,  8 Jul 2008 01:42:18 +0900
Message-Id: <1215448942-17581-17-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

I've gotten complaints and reports about people not understanding the
meaning of the current unknown class/perm handling the kernel emits on
every policy load.  Hopefully this will make make it clear to everyone
the meaning of the message and won't waste a printk the user won't care
about anyway on systems where the kernel and the policy agree on
everything.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/selinuxfs.c   |    5 -----
 security/selinux/ss/services.c |    7 +++++++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 07a5db6..69c9dcc 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -356,11 +356,6 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 		length = count;
 
 out1:
-
-	printk(KERN_INFO "SELinux: policy loaded with handle_unknown=%s\n",
-	       (security_get_reject_unknown() ? "reject" :
-		(security_get_allow_unknown() ? "allow" : "deny")));
-
 	audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
 		"policy loaded auid=%u ses=%u",
 		audit_get_loginuid(current),
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 04c0b70..b52f923 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1171,6 +1171,7 @@ static int validate_classes(struct policydb *p)
 	const struct selinux_class_perm *kdefs = &selinux_class_perm;
 	const char *def_class, *def_perm, *pol_class;
 	struct symtab *perms;
+	bool print_unknown_handle = 0;
 
 	if (p->allow_unknown) {
 		u32 num_classes = kdefs->cts_len;
@@ -1191,6 +1192,7 @@ static int validate_classes(struct policydb *p)
 				return -EINVAL;
 			if (p->allow_unknown)
 				p->undefined_perms[i-1] = ~0U;
+			print_unknown_handle = 1;
 			continue;
 		}
 		pol_class = p->p_class_val_to_name[i-1];
@@ -1220,6 +1222,7 @@ static int validate_classes(struct policydb *p)
 				return -EINVAL;
 			if (p->allow_unknown)
 				p->undefined_perms[class_val-1] |= perm_val;
+			print_unknown_handle = 1;
 			continue;
 		}
 		perdatum = hashtab_search(perms->table, def_perm);
@@ -1267,6 +1270,7 @@ static int validate_classes(struct policydb *p)
 					return -EINVAL;
 				if (p->allow_unknown)
 					p->undefined_perms[class_val-1] |= (1 << j);
+				print_unknown_handle = 1;
 				continue;
 			}
 			perdatum = hashtab_search(perms->table, def_perm);
@@ -1284,6 +1288,9 @@ static int validate_classes(struct policydb *p)
 			}
 		}
 	}
+	if (print_unknown_handle)
+		printk(KERN_INFO "SELinux: the above unknown classes and permissions will be %s\n",
+			(security_get_allow_unknown() ? "allowed" : "denied"));
 	return 0;
 }
 
-- 
1.5.5.1

