Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbZKQWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbZKQWPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbZKQWPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:15:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277AbZKQWPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:15:34 -0500
Date: Tue, 17 Nov 2009 14:13:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: David Howells <dhowells@redhat.com>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Message-Id: <20091117141314.0238a49b.akpm@linux-foundation.org>
In-Reply-To: <1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com>
References: <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>
	<7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>
	<1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	<18475.1255529305@redhat.com>
	<6207.1255706090@redhat.com>
	<23382.1255707790@redhat.com>
	<1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 11:55:29 -0400
Eric Paris <eparis@redhat.com> wrote:

> On Fri, 2009-10-16 at 16:43 +0100, David Howells wrote:
> > Eric Paris <eparis@redhat.com> wrote:
> > 
> > > That would still call cap_file_mmap() and wouldn't solve your problem.
> > 
> > Hmmm...  I guess I don't see the problem occur because I always run the
> > programs as root.
> 
> most likely yes, your processes are going to have CAP_SYS_RAWIO and will
> happily sail through the cap_file_mmap().
> 
> > I would guess that cap_file_mmap() and selinux_file_mmap() are, perhaps, too
> > strict.  The hint shouldn't be rejected unless MAP_FIXED is also set, surely,
> > but should rather be revised upwards.
> 
> On the mmu side we don't check until the kernel has turned the hint into
> a real address.  Which is apparently different then where the hook was
> originally placed in the nommu side.
> 
> > Certainly, addr==NULL and !MAP_FIXED is a reasonable case to permit, even in
> > tightly secured MMU and SELinux mode...  After all, the manual page says:
> > 
> > 	If addr is NULL, then the kernel chooses the address at which to create
> > 	the mapping; this is the most portable method of creating  a  new  map-
> > 	ping.
> 
> I agree, I think the choices are
> 
> A) agree that we just shouldn't check the address on nommu
>    A1) change kconfig to not allow the setting of these
> 	(easy to do for the LSM check, but not easy as it stands today
> 	 for the cap_file_mmap() check)
>    A2) change the addr_only to be a flags which indicate not to check
> 	(my original suggestion)
>    A3) push the config_nommu down into the security code
> 	(your patch)
> B) actually check the address, which requires moving the hook to a
> location where it has been resolved.
> 	(graff yang's patch)
> 
> I'll leave it up to you to determine which you like the best since you
> know the implications of nommu.
> 

So what's the status of this issue now?  Should I merge the below into
2.6.32?

Thanks.



From: David Howells <dhowells@redhat.com>

Ignore the address parameter in the various file_mmap() security checks
when CONFIG_MMU=n as the address hint is ignored under those
circumstances, and in any case the minimum mapping address check is
pointless in NOMMU mode.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Graff Yang <graf.yang@analog.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |    1 +
 mm/nommu.c               |    2 +-
 security/commoncap.c     |    2 ++
 security/selinux/hooks.c |    2 ++
 4 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/security.h~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check include/linux/security.h
--- a/include/linux/security.h~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/include/linux/security.h
@@ -609,6 +609,7 @@ static inline void security_free_mnt_opt
  *	@reqprot contains the protection requested by the application.
  *	@prot contains the protection that will be applied by the kernel.
  *	@flags contains the operational flags.
+ *	@addr contains the mapping address, and should be ignored in NOMMU mode.
  *	Return 0 if permission is granted.
  * @file_mprotect:
  *	Check permissions before changing memory access permissions.
diff -puN mm/nommu.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check mm/nommu.c
--- a/mm/nommu.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/mm/nommu.c
@@ -974,7 +974,7 @@ static int validate_mmap_request(struct 
 	}
 
 	/* allow the security API to have its say */
-	ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
+	ret = security_file_mmap(file, reqprot, prot, flags, 0, 0);
 	if (ret < 0)
 		return ret;
 
diff -puN security/commoncap.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check security/commoncap.c
--- a/security/commoncap.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/security/commoncap.c
@@ -1005,6 +1005,7 @@ int cap_file_mmap(struct file *file, uns
 {
 	int ret = 0;
 
+#ifdef CONFIG_MMU
 	if (addr < dac_mmap_min_addr) {
 		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
 				  SECURITY_CAP_AUDIT);
@@ -1012,5 +1013,6 @@ int cap_file_mmap(struct file *file, uns
 		if (ret == 0)
 			current->flags |= PF_SUPERPRIV;
 	}
+#endif
 	return ret;
 }
diff -puN security/selinux/hooks.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check security/selinux/hooks.c
--- a/security/selinux/hooks.c~nommu-ignore-the-address-parameter-in-the-file_mmap-security-check
+++ a/security/selinux/hooks.c
@@ -3046,6 +3046,7 @@ static int selinux_file_mmap(struct file
 			     unsigned long addr, unsigned long addr_only)
 {
 	int rc = 0;
+#ifdef CONFIG_MMU
 	u32 sid = current_sid();
 
 	/*
@@ -3060,6 +3061,7 @@ static int selinux_file_mmap(struct file
 		if (rc)
 			return rc;
 	}
+#endif
 
 	/* do DAC check on address space usage */
 	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
_

