Return-Path: <linux-kernel-owner+w=401wt.eu-S964830AbZIEAVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830AbZIEAVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964811AbZIEAVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:30 -0400
Received: from kroah.org ([198.145.64.141]:42184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934619AbZIEAU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:52 2009
Message-Id: <20090905001452.610699176@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kiszka <jan.kiszka@siemens.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 34/71] KVM: Fix KVM_GET_MSR_INDEX_LIST
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-kvm_get_msr_index_list.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Kiszka <jan.kiszka@web.de>

commit e125e7b6944898831b56739a5448e705578bf7e2 upstream.

So far, KVM copied the emulated_msrs (only MSR_IA32_MISC_ENABLE) to a
wrong address in user space due to broken pointer arithmetic. This
caused subtle corruption up there (missing MSR_IA32_MISC_ENABLE had
probably no practical relevance). Moreover, the size check for the
user-provided kvm_msr_list forgot about emulated MSRs.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1117,14 +1117,13 @@ long kvm_arch_dev_ioctl(struct file *fil
 		if (copy_to_user(user_msr_list, &msr_list, sizeof msr_list))
 			goto out;
 		r = -E2BIG;
-		if (n < num_msrs_to_save)
+		if (n < msr_list.nmsrs)
 			goto out;
 		r = -EFAULT;
 		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
 				 num_msrs_to_save * sizeof(u32)))
 			goto out;
-		if (copy_to_user(user_msr_list->indices
-				 + num_msrs_to_save * sizeof(u32),
+		if (copy_to_user(user_msr_list->indices + num_msrs_to_save,
 				 &emulated_msrs,
 				 ARRAY_SIZE(emulated_msrs) * sizeof(u32)))
 			goto out;


