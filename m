Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbXLZTcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbXLZTcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 14:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXLZTcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 14:32:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33854 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751376AbXLZTcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 14:32:41 -0500
Date: Wed, 26 Dec 2007 20:32:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 06/55] KVM: Per-architecture hypercall definitions
Message-ID: <20071226193226.GA8844@elf.ucw.cz>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com> <1198667160-22953-7-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198667160-22953-7-git-send-email-avi@qumranet.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Currently kvm provides hypercalls only for x86* architectures. To
> provide hypercall infrastructure for other kvm architectures I split
> kvm_para.h into a generic header file and architecture specific
> definitions.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> ---
>  include/asm-x86/kvm_para.h |  105 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/kvm_para.h   |  105 +++++---------------------------------------
>  2 files changed, 117 insertions(+), 93 deletions(-)
>  create mode 100644 include/asm-x86/kvm_para.h
> 
> diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
> new file mode 100644
> index 0000000..c6f3fd8
> --- /dev/null
> +++ b/include/asm-x86/kvm_para.h
> @@ -0,0 +1,105 @@
> +#ifndef __X86_KVM_PARA_H
> +#define __X86_KVM_PARA_H
> +
> +/* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
> + * should be used to determine that a VM is running under KVM.
> + */
> +#define KVM_CPUID_SIGNATURE	0x40000000

so it returns 'KVMKVMKVM' in %rax, too? 

> +/* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
> + * instruction.  The hypervisor may replace it with something else but only the
> + * instructions are guaranteed to be supported.
> + *
> + * Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
> + * The hypercall number should be placed in rax and the return

rax? First, this file is shared with i386, AFAICT.

> + * placed in rax.  No other registers will be clobbered unless explicited
> + * noted by the particular hypercall.
> + */
> +
> +static inline long kvm_hypercall0(unsigned int nr)
> +{
> +	long ret;
> +	asm volatile(KVM_HYPERCALL
> +		     : "=a"(ret)
> +		     : "a"(nr));

Second, if it is to be placed in rax, nr should be unsigned long?


> +static inline int kvm_para_available(void)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +	char signature[13];
> +
> +	cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
> +	memcpy(signature + 0, &ebx, 4);
> +	memcpy(signature + 4, &ecx, 4);
> +	memcpy(signature + 8, &edx, 4);

> +	signature[12] = 0;
> +
                               ebx|ecx|ed
> +	if (strcmp(signature, "KVMKVMKVM") == 0)
> +		return 1;

Should the comment say

> +/* This CPUID returns the signature 'KVMKVMKVM\0\0\0' in ebx, ecx, and edx.  It
> + * should be used to determine that a VM is running under KVM.
> + */

Plus, I'd use memcmp, and actually test for those zeros, too.

...which probably can be done later, as this is pure move...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
