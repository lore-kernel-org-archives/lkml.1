Return-Path: <linux-kernel-owner+w=401wt.eu-S1765924AbXFEUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765924AbXFEUey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764930AbXFEUer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:34:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764431AbXFEUeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:34:46 -0400
Subject: [PATCH] Protection for exploiting null dereference using mmap
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: Alan Cox <alan@redhat.com>, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       jmorris@namei.org, chrisw@redhat.com, sds@tycho.nsa.gov,
       sgrubb@redhat.com
In-Reply-To: <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com>
	 <20070603205653.GE25869@devserv.devel.redhat.com>
	 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 16:34:26 -0400
Message-Id: <1181075666.3978.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Assuming there is a kernel bug which includes a null dereference that
bug may allow for a process to place information on the first page on
the system and get the kernel to act in unintended ways.  This patch
adds a new security check on mmap operations to see if the user is
attempting to mmap to low area of the address space.  The amount of
space protected is indicated by the new proc
tunable /proc/sys/kernel/mmap_protect_memory and defaults to 64k.
Setting this value to 0 will disable the checks allowing a system to
function exactly the way it does today.  This patch simply makes the
kernel more resilient in the face of future unknown null dereference
bugs.

The security checks is enforced in 2 places.  First in SELinux and also
in the dummy security function.  Doing the check in SELinux allows an
SELinux system to use its fine grained security properties to
selectively allow processes to still mmap the low pages page while
denying most processes that potentially sensitive operation.
Enforcement is also done in the dummy operation dummy_file_mmap() and
will be used for enforcement on non-selinux systems.  Although, on such
a system the proc tunable must be set to 0 if any applications actually
need to mmap to the low pages.  No fine grained security means it has to
be this all or nothing approach on non-selinux systems.

One result of using the dummy hook for non-selinux kernels means that I
can't leave the generic module stacking code in the SELinux check.  If
the secondary ops are called they will always deny the operation just
like in non-selinux systems even if SELinux policy would have allowed
the action.  This patch may be the first step to removing the arbitrary
LSM module stacking code from SELinux.  I think history has shown the
arbitrary module stacking is not a good idea and eventually I want to
pull out all the secondary calls which aren't used by the capability
module, so I view this as just the first step along those lines.

This patch uses a new SELinux security class "memprotect."  Policy
already contains a number of allow rules like  a_t self:process *
(unconfined_t being one of them) which mean that putting this check in
the process class (its best current fit) would make it useless as all
user processes, which we also want to protect against, would be allowed.
By taking the memprotect name of the new class it will also make it
possible for us to move some of the other memory protect permissions out
of 'process' and into the new class next time we bump the policy version
number (which I also think is a good future idea)

-Eric

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 Documentation/sysctl/kernel.txt              |   12 ++++++++++++
 include/linux/security.h                     |   17 ++++++++++++-----
 kernel/sysctl.c                              |    9 +++++++++
 mm/mmap.c                                    |    4 ++--
 mm/mremap.c                                  |   15 +++++++++++++--
 mm/nommu.c                                   |    2 +-
 security/dummy.c                             |    6 +++++-
 security/security.c                          |    2 ++
 security/selinux/hooks.c                     |   12 ++++++++----
 security/selinux/include/av_perm_to_string.h |    1 +
 security/selinux/include/av_permissions.h    |    1 +
 security/selinux/include/class_to_string.h   |    1 +
 security/selinux/include/flask.h             |    1 +
 13 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 111fd28..ed22eee 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -29,6 +29,7 @@ show up in /proc/sys/kernel:
 - java-interpreter            [ binfmt_java, obsolete ]
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
+- mmap_protect_memory
 - modprobe                    ==> Documentation/kmod.txt
 - msgmax
 - msgmnb
@@ -178,6 +179,17 @@ kernel stack.
 
 ==============================================================
 
+mmap_protect_memory
+
+This file indicates the amount of address space  which a user process will be
+restricted from mmaping.  Since kernel null dereference bugs could
+accidentally operate based on the information in the first couple of pages of
+memory userspace processes should not be allowed to write to them.  By default
+the security hooks will protect the first 64k of memory. To completely disable
+this protection the value should be set to 0.
+
+==============================================================
+
 osrelease, ostype & version:
 
 # cat osrelease
diff --git a/include/linux/security.h b/include/linux/security.h
index 9eb9e0f..56b9a1b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -71,6 +71,7 @@ struct xfrm_user_sec_ctx;
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
 
+extern int mmap_protect_memory;
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
index 30ee462..ae2d665 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -615,6 +615,15 @@ static ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "mmap_protect_memory",
+		.data		= &mmap_protect_memory,
+		.maxlen         = sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+	},
 
 	{ .ctl_name = 0 }
 };
diff --git a/mm/mmap.c b/mm/mmap.c
index 68b9ad2..bce4995 100644
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
index 5d4bd4f..7a4f2cc 100644
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
@@ -390,9 +394,16 @@ unsigned long do_mremap(unsigned long addr,
 
 			new_addr = get_unmapped_area(vma->vm_file, 0, new_len,
 						vma->vm_pgoff, map_flags);
-			ret = new_addr;
-			if (new_addr & ~PAGE_MASK)
+			if (new_addr & ~PAGE_MASK) {
+				ret = new_addr;
 				goto out;
+			}
+
+			ret = security_file_mmap(0, 0, 0, 0, new_addr, 1);
+			if (ret)
+				goto out;
+
+			ret = new_addr;
 		}
 		ret = move_vma(vma, addr, old_len, new_len, new_addr);
 	}
diff --git a/mm/nommu.c b/mm/nommu.c
index 2b16b00..6f8ddee 100644
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
index 8ffd764..c45ed09 100644
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
+	if (addr < mmap_protect_memory)
+		return -EACCES;
 	return 0;
 }
 
diff --git a/security/security.c b/security/security.c
index fc8601b..492686b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -24,6 +24,7 @@ extern struct security_operations dummy_security_ops;
 extern void security_fixup_ops(struct security_operations *ops);
 
 struct security_operations *security_ops;	/* Initialized to NULL */
+int mmap_protect_memory = 65536;	/* Cannot mmap first 64k */
 
 static inline int verify(struct security_operations *ops)
 {
@@ -176,4 +177,5 @@ EXPORT_SYMBOL_GPL(register_security);
 EXPORT_SYMBOL_GPL(unregister_security);
 EXPORT_SYMBOL_GPL(mod_reg_security);
 EXPORT_SYMBOL_GPL(mod_unreg_security);
+EXPORT_SYMBOL_GPL(mmap_protect_memory);
 EXPORT_SYMBOL(security_ops);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ad8dd4e..d9c06b0 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2568,12 +2568,16 @@ static int file_map_prot_check(struct file *file, unsigned long prot, int shared
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
+	if (addr < mmap_protect_memory)
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


