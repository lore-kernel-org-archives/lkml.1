Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXGQQ1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXGQQ1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXGQQ1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:27:15 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:39026 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbXGQQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:27:14 -0400
Date: Tue, 17 Jul 2007 12:26:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Avi Kivity <avi@qumranet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       KVM devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/3] KVM - Add missing kvm_run initializations
Message-ID: <20070717162659.GD7965@c2.user-mode-linux.org>
References: <20070716192446.GA16243@c2.user-mode-linux.org> <469C7A05.2070205@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469C7A05.2070205@qumranet.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 11:12:53AM +0300, Avi Kivity wrote:
> I believe that emulate_instruction will set run->mmio if it returns 
> EMULATE_DO_MMIO.

Righto, forgot to check that.  How about this patch instead?

Set exit_reason to KVM_EXIT_MMIO where run->mmio is initialized.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 drivers/kvm/kvm_main.c |    2 +-
 drivers/kvm/svm.c      |    1 -
 drivers/kvm/vmx.c      |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

Index: kvm/drivers/kvm/kvm_main.c
===================================================================
--- kvm.orig/drivers/kvm/kvm_main.c
+++ kvm/drivers/kvm/kvm_main.c
@@ -1294,6 +1294,7 @@ int emulate_instruction(struct kvm_vcpu 
 	r = x86_emulate_memop(&emulate_ctxt, &emulate_ops);
 
 	if ((r || vcpu->mmio_is_write) && run) {
+		run->exit_reason = KVM_EXIT_MMIO;
 		run->mmio.phys_addr = vcpu->mmio_phys_addr;
 		memcpy(run->mmio.data, vcpu->mmio_data, 8);
 		run->mmio.len = vcpu->mmio_size;
@@ -1929,7 +1930,6 @@ static int kvm_vcpu_ioctl_run(struct kvm
 			/*
 			 * Read-modify-write.  Back to userspace.
 			 */
-			kvm_run->exit_reason = KVM_EXIT_MMIO;
 			r = 0;
 			goto out;
 		}
Index: kvm/drivers/kvm/svm.c
===================================================================
--- kvm.orig/drivers/kvm/svm.c
+++ kvm/drivers/kvm/svm.c
@@ -929,7 +929,6 @@ static int pf_interception(struct kvm_vc
 		return 1;
 	case EMULATE_DO_MMIO:
 		++vcpu->stat.mmio_exits;
-		kvm_run->exit_reason = KVM_EXIT_MMIO;
 		return 0;
 	case EMULATE_FAIL:
 		vcpu_printf(vcpu, "%s: emulate fail\n", __FUNCTION__);
Index: kvm/drivers/kvm/vmx.c
===================================================================
--- kvm.orig/drivers/kvm/vmx.c
+++ kvm/drivers/kvm/vmx.c
@@ -1610,7 +1610,6 @@ static int handle_exception(struct kvm_v
 			return 1;
 		case EMULATE_DO_MMIO:
 			++vcpu->stat.mmio_exits;
-			kvm_run->exit_reason = KVM_EXIT_MMIO;
 			return 0;
 		 case EMULATE_FAIL:
 			vcpu_printf(vcpu, "%s: emulate fail\n", __FUNCTION__);

-- 
Work email - jdike at linux dot intel dot com
