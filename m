Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab0BRQ3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:29:51 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:27238 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab0BRQ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:29:49 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pab9bhzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1PTB-01-A6M-02
X-M-MSG: 
Date: Thu, 18 Feb 2010 17:29:35 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] KVM: SVM: Make lazy FPU switching work with
 nested svm
Message-ID: <20100218162935.GR22141@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
 <1266493115-28386-10-git-send-email-joerg.roedel@amd.com>
 <4B7D4F62.3010903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B7D4F62.3010903@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Feb 2010 16:29:35.0643 (UTC) FILETIME=[8EE61EB0:01CAB0B7]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 04:32:02PM +0200, Avi Kivity wrote:
> On 02/18/2010 01:38 PM, Joerg Roedel wrote:
> >TDB.
> >
> 
> ...
> 
> >@@ -973,6 +973,7 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
> >
> >  static void update_cr0_intercept(struct vcpu_svm *svm)
> >  {
> >+	struct vmcb *vmcb = svm->vmcb;
> >  	ulong gcr0 = svm->vcpu.arch.cr0;
> >  	u64 *hcr0 =&svm->vmcb->save.cr0;
> >
> >@@ -984,11 +985,25 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
> >
> >
> >  	if (gcr0 == *hcr0&&  svm->vcpu.fpu_active) {
> >-		svm->vmcb->control.intercept_cr_read&= ~INTERCEPT_CR0_MASK;
> >-		svm->vmcb->control.intercept_cr_write&= ~INTERCEPT_CR0_MASK;
> >+		vmcb->control.intercept_cr_read&= ~INTERCEPT_CR0_MASK;
> >+		vmcb->control.intercept_cr_write&= ~INTERCEPT_CR0_MASK;
> >+		if (is_nested(svm)) {
> >+			struct vmcb *hsave = svm->nested.hsave;
> >+
> >+			hsave->control.intercept_cr_read&= ~INTERCEPT_CR0_MASK;
> >+			hsave->control.intercept_cr_write&= ~INTERCEPT_CR0_MASK;
> >+			vmcb->control.intercept_cr_read  |= svm->nested.intercept_cr_read;
> >+			vmcb->control.intercept_cr_write |= svm->nested.intercept_cr_write;
> 
> Why are the last two lines needed?

Because we don't know if the l1 hypervisor wants to intercept cr0. In
this case we need this intercept to stay enabled.

> >+		}
> >  	} else {
> >  		svm->vmcb->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
> >  		svm->vmcb->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
> >+		if (is_nested(svm)) {
> >+			struct vmcb *hsave = svm->nested.hsave;
> >+
> >+			hsave->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
> >+			hsave->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
> >+		}
> >  	}
> >  }
> 
> Maybe it's better to call update_cr0_intercept() after a vmexit
> instead, to avoid this repetition, and since the if () may take a
> different branch for the nested guest and guest cr0.

Thinking again about it I am not sure if this is needed at all. At
vmexit emulation we call svm_set_cr0 which itself calls
update_cr0_intercept. I'll try this.

	Joerg


