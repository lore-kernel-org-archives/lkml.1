Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0BRQYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:24:37 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19459 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab0BRQYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:24:35 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pab9bhzz1202hzzz32i87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1PKJ-01-9V5-02
X-M-MSG: 
Date: Thu, 18 Feb 2010 17:24:19 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 03/10] KVM: SVM: Fix schedule-while-atomic on nested
 exception handling
Message-ID: <20100218162418.GQ22141@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
 <1266493115-28386-4-git-send-email-joerg.roedel@amd.com>
 <4B7D4614.7040806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B7D4614.7040806@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Feb 2010 16:24:19.0189 (UTC) FILETIME=[D2471250:01CAB0B6]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 03:52:20PM +0200, Avi Kivity wrote:
> On 02/18/2010 01:38 PM, Joerg Roedel wrote:
> >Move the actual vmexit routine out of code that runs with
> >irqs and preemption disabled.
> >
> >Cc: stable@kernel.org
> >Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >---
> >  arch/x86/kvm/svm.c |   20 +++++++++++++++++---
> >  1 files changed, 17 insertions(+), 3 deletions(-)
> >
> >diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >index 7c96b8b..25d26ec 100644
> >--- a/arch/x86/kvm/svm.c
> >+++ b/arch/x86/kvm/svm.c
> >@@ -128,6 +128,7 @@ static void svm_flush_tlb(struct kvm_vcpu *vcpu);
> >  static void svm_complete_interrupts(struct vcpu_svm *svm);
> >
> >  static int nested_svm_exit_handled(struct vcpu_svm *svm);
> >+static int nested_svm_exit_handled_atomic(struct vcpu_svm *svm);
> >  static int nested_svm_vmexit(struct vcpu_svm *svm);
> >  static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> >  				      bool has_error_code, u32 error_code);
> >@@ -1386,7 +1387,7 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> >  	svm->vmcb->control.exit_info_1 = error_code;
> >  	svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
> >
> >-	return nested_svm_exit_handled(svm);
> >+	return nested_svm_exit_handled_atomic(svm);
> >  }
> 
> What do you say to
> 
> 
>    if (nested_svm_intercepts(svm))
>         svm->nested.exit_required = true;
> 
> here, and recoding nested_svm_exit_handled() to call
> nested_svm_intercepts()?  I think it improves readability a little
> by avoiding a function that changes behaviour according to how it is
> called.

Thats a good idea, will change that. It improves readability.

> Long term, we may want to split out the big switch into the
> individual handlers, to avoid decoding the exit reason twice.

I don't think thats a good idea. The nested exit handling is at the
beginning of svm_handle_exit to hide the nested vcpu state from the kvm
logic which may not be aware of nesting at all. My rationale is that the
host hypervisor don't see any exits that needs to be reinjected to the
l1 hypervisor.

	Joerg


