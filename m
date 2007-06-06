Return-Path: <linux-kernel-owner+w=401wt.eu-S964984AbXFFGbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984AbXFFGbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbXFFGbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:31:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbXFFGbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:31:00 -0400
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       chrisw@redhat.com, sds@tycho.nsa.gov, sgrubb@redhat.com
In-Reply-To: <20070605211616.GE23291@devserv.devel.redhat.com>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com>
	 <20070603205653.GE25869@devserv.devel.redhat.com>
	 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil>
	 <1181075666.3978.31.camel@localhost.localdomain>
	 <Line.LNX.4.64.0706051658170.23379@d.namei>
	 <20070605211616.GE23291@devserv.devel.redhat.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 02:30:33 -0400
Message-Id: <1181111433.3978.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 17:16 -0400, Alan Cox wrote:
> On Tue, Jun 05, 2007 at 05:00:51PM -0400, James Morris wrote:
> > This should be an unsigned long.
> > 
> > I wonder if the default should be for this value to be zero (i.e. preserve 
> > existing behavior).  It could break binaries, albeit potentially insecure 
> 
> Agreed - DOSemu type apps and lrmi need to map at zero for vm86

And so it shall be!

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 Documentation/sysctl/kernel.txt                  |   14 ++++++++++++++
 include/linux/security.h                         |   17 ++++++++++++-----
 kernel/sysctl.c                                  |    8 ++++++++
 mm/mmap.c                                        |    4 ++--
 mm/mremap.c                                      |   13 +++++++++++--
 mm/nommu.c                                       |    2 +-
 security/dummy.c                                 |    6 +++++-
 security/security.c                              |    2 ++
 security/selinux/hooks.c                         |   12 ++++++++----
 security/selinux/include/av_perm_to_string.h     |    1 +
 security/selinux/include/av_permissions.h        |    1 +
 security/selinux/include/class_to_string.h       |    1 +
 security/selinux/include/flask.h                 |    1 +
 13 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 111fd28..be3991c 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -29,6 +29,7 @@ show up in /proc/sys/kernel:
 - java-interpreter            [ binfmt_java, obsolete ]
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
+- mmap_min_addr
 - modprobe                    ==> Documentation/kmod.txt
 - msgmax
 - msgmnb
@@ -178,6 +179,19 @@ kernel stack.
 
 ==============================================================
 
+mmap_min_addr
+
+This file indicates the amount of address space  which a user process will be
+restricted from mmaping.  Since kernel null dereference bugs could
+accidentally operate based on the information in the first couple of pages of
+memory userspace processes should not be allowed to write to them.  By default
+this value is set to 0 and no protections will be enforced by the security
+module.  Setting this value to something like 64k will allow the vast majority
+of applications to work correctly and provide defense in depth against future
+potential kernel bugs.
+
+==============================================================
+
 osrelease, ostype & version:
 
 # cat osrelease
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
index 30ee462..a6feef2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -615,6 +615,14 @@ static ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "mmap_min_addr",
+		.data		= &mmap_min_addr,
+		.maxlen         = sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
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
index ad8dd4e..2b44832 100644
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


