Return-Path: <linux-kernel-owner+w=401wt.eu-S936687AbZLQEnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936687AbZLQEnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763069AbZLQEnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:43:12 -0500
Received: from kroah.org ([198.145.64.141]:55362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761558AbZLQEDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:46 2009
Message-Id: <20091217035646.823076826@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Carsten Otte <cotte@de.ibm.com>, Avi Kivity <avi@redhat.com>
Subject: [030/151] KVM: s390: Fix prefix register checking in arch/s390/kvm/sigp.c
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carsten Otte <carsteno@de.ibm.com>

commit f50146bd7bdb75435638e60d4960edd9bcdf88b8 upstream.

This patch corrects the checking of the new address for the prefix register.
On s390, the prefix register is used to address the cpu's lowcore (address
0...8k). This check is supposed to verify that the memory is readable and
present.
copy_from_guest is a helper function, that can be used to read from guest
memory. It applies prefixing, adds the start address of the guest memory in
user, and then calls copy_from_user. Previous code was obviously broken for
two reasons:
- prefixing should not be applied here. The current prefix register is
  going to be updated soon, and the address we're looking for will be
  0..8k after we've updated the register
- we're adding the guest origin (gmsor) twice: once in subject code
  and once in copy_from_guest

With kuli, we did not hit this problem because (a) we were lucky with
previous prefix register content, and (b) our guest memory was mmaped
very low into user address space.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Reported-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -188,9 +188,9 @@ static int __sigp_set_prefix(struct kvm_vcpu *vcpu, u16 cpu_addr, u32 address,
 
 	/* make sure that the new value is valid memory */
 	address = address & 0x7fffe000u;
-	if ((copy_from_guest(vcpu, &tmp,
-		(u64) (address + vcpu->arch.sie_block->gmsor) , 1)) ||
-	   (copy_from_guest(vcpu, &tmp, (u64) (address +
+	if ((copy_from_user(&tmp, (void __user *)
+		(address + vcpu->arch.sie_block->gmsor) , 1)) ||
+	   (copy_from_user(&tmp, (void __user *)(address +
 			vcpu->arch.sie_block->gmsor + PAGE_SIZE), 1))) {
 		*reg |= SIGP_STAT_INVALID_PARAMETER;
 		return 1; /* invalid parameter */


