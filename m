Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbXGIC7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbXGIC7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbXGIC7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:59:38 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:37664 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637AbXGIC7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:59:36 -0400
Date: Sun, 8 Jul 2007 22:59:33 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] security: Protection for exploiting null dereference
 using mmap
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082259060.12256@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Add a new security check on mmap operations to see if the user is attempting
to mmap to low area of the address space.  The amount of space protected is
indicated by the new proc tunable /proc/sys/vm/mmap_min_addr and defaults to
0, preserving existing behavior.

This patch uses a new SELinux security class "memprotect."  Policy already
contains a number of allow rules like a_t self:process * (unconfined_t being
one of them) which mean that putting this check in the process class (its
best current fit) would make it useless as all user processes, which we also
want to protect against, would be allowed. By taking the memprotect name of
the new class it will also make it possible for us to move some of the other
memory protect permissions out of 'process' and into the new class next time
we bump the policy version number (which I also think is a good future idea)

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 Documentation/sysctl/vm.txt                  |   15 +++++++++++++++
 include/linux/security.h                     |   17 ++++++++++++-----
 kernel/sysctl.c                              |   10 ++++++++++
 mm/mmap.c                                    |    4 ++--
 mm/mremap.c                                  |   13 +++++++++++--
 mm/nommu.c                                   |    2 +-
 security/dummy.c                             |    6 +++++-
 security/security.c                          |    2 ++
 security/selinux/hooks.c                     |   12 ++++++++----
 security/selinux/include/av_perm_to_string.h |    1 +
 security/selinux/include/av_permissions.h    |    1 +
 security/selinux/include/class_to_string.h   |    1 +
 security/selinux/include/flask.h             |    1 +
 13 files changed, 70 insertions(+), 15 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 1d19256..8cfca17 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -31,6 +31,7 @@ Currently, these files are in /proc/sys/vm:
 - min_unmapped_ratio
 - min_slab_ratio
 - panic_on_oom
+- mmap_min_address
 
 ==============================================================
 
@@ -216,3 +217,17 @@ above-mentioned.
 The default value is 0.
 1 and 2 are for failover of clustering. Please select either
 according to your policy of failover.
+
+==============================================================
+
+mmap_min_addr
+
+This file indicates the amount of address space  which a user process will
+be restricted from mmaping.  Since kernel null dereference bugs could
+accidentally operate based on the information in the first couple of pages
+of memory userspace processes should not be allowed to write to them.  By
+default this value is set to 0 and no protections will be enforced by the
+security module.  Setting this value to something like 64k will allow the
+vast majority of applications to work correctly and provide defense in depth
+against future potential kernel bugs.
+
diff --git a/include/linux/security.h b/include/linux/security.h
index 9eb9e0f..c11dc8a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -71,6 +71,7 @@ struct xfrm_user_sec_ctx;
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
 
+extern unsigned long mmap_min_addr;
 /*
  * Values used in the task_security_ops calls
  */
@@ -1241,8 +1242,9 @@ struct security_operations {
 	int (*file_ioctl) (struct file * file, unsigned int cmd,
 			   unsigned long arg);
 	int (*file_mmap) (struct file * file,
-			  unsigned long reqprot,
-			  unsigned long prot, unsigned long flags);
+			  unsigned long reqprot, unsigned long prot,
+			  unsigned long flags, unsigned long addr,
+			  unsigned long addr_only);
 	int (*file_mprotect) (struct vm_area_struct * vma,
 			      unsigned long reqprot,
 			      unsigned long prot);
@@ -1814,9 +1816,12 @@ static inline int security_file_ioctl (struct file *file, unsigned int cmd,
 
 static inline int security_file_mmap (struct file *file, unsigned long reqprot,
 				      unsigned long prot,
-				      unsigned long flags)
+				      unsigned long flags,
+				      unsigned long addr,
+				      unsigned long addr_only)
 {
-	return security_ops->file_mmap (file, reqprot, prot, flags);
+	return security_ops->file_mmap (file, reqprot, prot, flags, addr,
+					addr_only);
 }
 
 static inline int security_file_mprotect (struct vm_area_struct *vma,
@@ -2489,7 +2494,9 @@ static inline int security_file_ioctl (struct file *file, unsigned int cmd,
 
 static inline int security_file_mmap (struct file *file, unsigned long reqprot,
 				      unsigned long prot,
-				      unsigned long flags)
+				      unsigned long flags,
+				      unsigned long addr,
+				      unsigned long addr_only)
 {
 	return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 30ee462..c58cccf 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -869,6 +869,16 @@ static ctl_table vm_table[] = {
 		.strategy	= &sysctl_jiffies,
 	},
 #endif
+#ifdef CONFIG_SECURITY
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "mmap_min_addr",
+		.data		= &mmap_min_addr,
+		.maxlen         = sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+#endif
 #if defined(CONFIG_X86_32) || \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
diff --git a/mm/mmap.c b/mm/mmap.c
index 906ed40..9f70c8e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1023,10 +1023,10 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 		}
 	}
 
-	error = security_file_mmap(file, reqprot, prot, flags);
+	error = security_file_mmap(file, reqprot, prot, flags, addr, 0);
 	if (error)
 		return error;
-		
+
 	/* Clear old maps */
 	error = -ENOMEM;
 munmap_back:
diff --git a/mm/mremap.c b/mm/mremap.c
index 5d4bd4f..bc7c52e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -291,6 +291,10 @@ unsigned long do_mremap(unsigned long addr,
 		if ((addr <= new_addr) && (addr+old_len) > new_addr)
 			goto out;
 
+		ret = security_file_mmap(0, 0, 0, 0, new_addr, 1);
+		if (ret)
+			goto out;
+
 		ret = do_munmap(mm, new_addr, new_len);
 		if (ret)
 			goto out;
@@ -390,8 +394,13 @@ unsigned long do_mremap(unsigned long addr,
 
 			new_addr = get_unmapped_area(vma->vm_file, 0, new_len,
 						vma->vm_pgoff, map_flags);
-			ret = new_addr;
-			if (new_addr & ~PAGE_MASK)
+			if (new_addr & ~PAGE_MASK) {
+				ret = new_addr;
+				goto out;
+			}
+
+			ret = security_file_mmap(0, 0, 0, 0, new_addr, 1);
+			if (ret)
 				goto out;
 		}
 		ret = move_vma(vma, addr, old_len, new_len, new_addr);
diff --git a/mm/nommu.c b/mm/nommu.c
index 2b16b00..989e2e9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -639,7 +639,7 @@ static int validate_mmap_request(struct file *file,
 	}
 
 	/* allow the security API to have its say */
-	ret = security_file_mmap(file, reqprot, prot, flags);
+	ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
 	if (ret < 0)
 		return ret;
 
diff --git a/security/dummy.c b/security/dummy.c
index 8ffd764..d6a112c 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -420,8 +420,12 @@ static int dummy_file_ioctl (struct file *file, unsigned int command,
 
 static int dummy_file_mmap (struct file *file, unsigned long reqprot,
 			    unsigned long prot,
-			    unsigned long flags)
+			    unsigned long flags,
+			    unsigned long addr,
+			    unsigned long addr_only)
 {
+	if (addr < mmap_min_addr)
+		return -EACCES;
 	return 0;
 }
 
diff --git a/security/security.c b/security/security.c
index fc8601b..024484f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -24,6 +24,7 @@ extern struct security_operations dummy_security_ops;
 extern void security_fixup_ops(struct security_operations *ops);
 
 struct security_operations *security_ops;	/* Initialized to NULL */
+unsigned long mmap_min_addr;		/* 0 means no protection */
 
 static inline int verify(struct security_operations *ops)
 {
@@ -176,4 +177,5 @@ EXPORT_SYMBOL_GPL(register_security);
 EXPORT_SYMBOL_GPL(unregister_security);
 EXPORT_SYMBOL_GPL(mod_reg_security);
 EXPORT_SYMBOL_GPL(mod_unreg_security);
+EXPORT_SYMBOL_GPL(mmap_min_addr);
 EXPORT_SYMBOL(security_ops);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b29059e..78c3f98 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2569,12 +2569,16 @@ static int file_map_prot_check(struct file *file, unsigned long prot, int shared
 }
 
 static int selinux_file_mmap(struct file *file, unsigned long reqprot,
-			     unsigned long prot, unsigned long flags)
+			     unsigned long prot, unsigned long flags,
+			     unsigned long addr, unsigned long addr_only)
 {
-	int rc;
+	int rc = 0;
+	u32 sid = ((struct task_security_struct*)(current->security))->sid;
 
-	rc = secondary_ops->file_mmap(file, reqprot, prot, flags);
-	if (rc)
+	if (addr < mmap_min_addr)
+		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
+				  MEMPROTECT__MMAP_ZERO, NULL);
+	if (rc || addr_only)
 		return rc;
 
 	if (selinux_checkreqprot)
diff --git a/security/selinux/include/av_perm_to_string.h b/security/selinux/include/av_perm_to_string.h
index b83e740..049bf69 100644
--- a/security/selinux/include/av_perm_to_string.h
+++ b/security/selinux/include/av_perm_to_string.h
@@ -158,3 +158,4 @@
    S_(SECCLASS_KEY, KEY__CREATE, "create")
    S_(SECCLASS_DCCP_SOCKET, DCCP_SOCKET__NODE_BIND, "node_bind")
    S_(SECCLASS_DCCP_SOCKET, DCCP_SOCKET__NAME_CONNECT, "name_connect")
+   S_(SECCLASS_MEMPROTECT, MEMPROTECT__MMAP_ZERO, "mmap_zero")
diff --git a/security/selinux/include/av_permissions.h b/security/selinux/include/av_permissions.h
index 5fee173..eda89a2 100644
--- a/security/selinux/include/av_permissions.h
+++ b/security/selinux/include/av_permissions.h
@@ -823,3 +823,4 @@
 #define DCCP_SOCKET__NAME_BIND                    0x00200000UL
 #define DCCP_SOCKET__NODE_BIND                    0x00400000UL
 #define DCCP_SOCKET__NAME_CONNECT                 0x00800000UL
+#define MEMPROTECT__MMAP_ZERO                     0x00000001UL
diff --git a/security/selinux/include/class_to_string.h b/security/selinux/include/class_to_string.h
index 3787990..e77de0e 100644
--- a/security/selinux/include/class_to_string.h
+++ b/security/selinux/include/class_to_string.h
@@ -63,3 +63,4 @@
     S_("key")
     S_(NULL)
     S_("dccp_socket")
+    S_("memprotect")
diff --git a/security/selinux/include/flask.h b/security/selinux/include/flask.h
index 35f309f..a9c2b20 100644
--- a/security/selinux/include/flask.h
+++ b/security/selinux/include/flask.h
@@ -49,6 +49,7 @@
 #define SECCLASS_PACKET                                  57
 #define SECCLASS_KEY                                     58
 #define SECCLASS_DCCP_SOCKET                             60
+#define SECCLASS_MEMPROTECT                              61
 
 /*
  * Security identifier indices for initial entities
-- 
1.5.0.6

