Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZJHJNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZJHJNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZJHJNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:13:04 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:16344
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756038AbZJHJNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:13:02 -0400
X-SpamScore: -11
X-BigFish: VPS-11(z34a4jz1432R98dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KR6UW4-03-3GP-02
X-M-MSG: 
Date: Thu, 8 Oct 2009 11:12:02 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] KVM: SVM: Move nested INTR #vmexit into
 preemtible code
Message-ID: <20091008091202.GB14073@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
 <1254925888-13743-4-git-send-email-joerg.roedel@amd.com>
 <20091007205852.GA7692@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20091007205852.GA7692@amt.cnet>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Oct 2009 09:12:02.0628 (UTC) FILETIME=[65F13040:01CA47F7]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 05:58:52PM -0300, Marcelo Tosatti wrote:
> On Wed, Oct 07, 2009 at 04:31:21PM +0200, Joerg Roedel wrote:
> > This patch makes use of the KVM_REQ_VMEXIT to move the
> > emulation of #vmexit(INTR) out of non-preemptible code.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kvm/svm.c |   18 ++++++++++++++++--
> >  1 files changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index b6ce1a9..7015680 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -1379,8 +1379,14 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
> >  
> >  	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
> >  
> > -	if (nested_svm_exit_handled(svm)) {
> > -		nsvm_printk("VMexit -> INTR\n");
> > +	if (svm->nested.intercept & 1ULL) {
> > +		/*
> > +		 * The #vmexit can't be emulated here directly because this
> > +		 * code path runs with irqs and preemtion disabled and a
> > +		 * #vmexit emulation might sleep. Only set the request bit for
> > +		 * the #vmexit here.
> > +		 */
> > +		set_bit(KVM_REQ_VMEXIT, &svm->vcpu.requests);
> >  		return 1;
> >  	}
> 
> What if you keep this internal to SVM? Proceed to svm_vcpu_run and
> return, do the emulation on the exit handler.
> 
> Then there's no need for the request bit (VMX does that, see
> vmx_vcpu_run).

Yeah, right. This would be cleaner code. I will change it.

	Joerg


