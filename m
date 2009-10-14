Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbZJNOK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbZJNOK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933241AbZJNOK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227AbZJNOK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:10:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
References: <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
To: graff.yang@gmail.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       gyang@blackfin.uclinux.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Date: Wed, 14 Oct 2009 15:08:25 +0100
Message-ID: <18475.1255529305@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<graff.yang@gmail.com> wrote:

> The original code calling security_file_mmap() use user's hint address
> as it's 5th argument(addr). This is improper, as the hint address may be
> NULL.
> In this case, the security_file_mmap() may incorrectly return -EPERM.
> 
> This patch moved the calling of security_file_mmap() out of
> validate_mmap_request() to do_mmap_pgoff(), and call this
> security API with the address that attempting to mmap.

I think this is the wrong approach.  Firstly, the hint is cleared in NOMMU
mode, and secondly, I think that the check against the minimum LSM address is
pointless in NOMMU mode too.

So I think the attached patch is a better approach.

David
---
From: David Howells <dhowells@redhat.com>

NOMMU: Ignore the address parameter in the file_mmap() security check

Ignore the address parameter in the various file_mmap() security checks when
CONFIG_MMU=n as the address hint is ignored under those circumstances, and in
any case the minimum mapping address check is pointless in NOMMU mode.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/security.h |    1 +
 mm/nommu.c               |    2 +-
 security/commoncap.c     |    2 ++
 security/selinux/hooks.c |    2 ++
 4 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/include/linux/security.h b/include/linux/security.h
index 239e40d..0583f16 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -593,6 +593,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@reqprot contains the protection requested by the application.
  *	@prot contains the protection that will be applied by the kernel.
  *	@flags contains the operational flags.
+ *	@addr contains the mapping address, and should be ignored in NOMMU mode.
  *	Return 0 if permission is granted.
  * @file_mprotect:
  *	Check permissions before changing memory access permissions.
diff --git a/mm/nommu.c b/mm/nommu.c
index 3c3b4b2..cfea46c 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -974,7 +974,7 @@ static int validate_mmap_request(struct file *file,
 	}
 
 	/* allow the security API to have its say */
-	ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
+	ret = security_file_mmap(file, reqprot, prot, flags, 0, 0);
 	if (ret < 0)
 		return ret;
 
diff --git a/security/commoncap.c b/security/commoncap.c
index fe30751..ac1f745 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1005,6 +1005,7 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
 {
 	int ret = 0;
 
+#ifdef CONFIG_MMU
 	if (addr < dac_mmap_min_addr) {
 		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
 				  SECURITY_CAP_AUDIT);
@@ -1012,5 +1013,6 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
 		if (ret == 0)
 			current->flags |= PF_SUPERPRIV;
 	}
+#endif
 	return ret;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index bb230d5..93d61f8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3046,6 +3046,7 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 			     unsigned long addr, unsigned long addr_only)
 {
 	int rc = 0;
+#ifdef CONFIG_MMU
 	u32 sid = current_sid();
 
 	/*
@@ -3060,6 +3061,7 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 		if (rc)
 			return rc;
 	}
+#endif
 
 	/* do DAC check on address space usage */
 	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
