Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZFHI4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZFHI4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZFHI43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:56:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:51987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbZFHI42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:56:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,323,1241420400"; 
   d="scan'208";a="464373459"
Subject: Re: [PATCH -v3] KVM: Add VT-x machine check support
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4A2CD04D.7070603@redhat.com>
References: <1244449939.8361.591.camel@yhuang-dev.sh.intel.com>
	 <4A2CD04D.7070603@redhat.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 16:56:29 +0800
Message-Id: <1244451389.8361.592.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 16:48 +0800, Avi Kivity wrote:
> Huang Ying wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > VT-x needs an explicit MC vector intercept to handle machine checks in the 
> > hyper visor.
> >
> > It also has a special option to catch machine checks that happen
> > during VT entry.
> >
> > Do these interceptions and forward them to the Linux machine check
> > handler. Make it always look like user space is interrupted because
> > the machine check handler treats kernel/user space differently.
> >
> > Thanks to Jiang Yunhong for help and testing.
> >
> >   
> 
> Noticed an additional problem.  See below.
> 
> >  static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -2616,6 +2640,10 @@ static int handle_exception(struct kvm_v
> >  	vect_info = vmx->idt_vectoring_info;
> >  	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
> >  
> > +	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
> > +	if (ex_no == MC_VECTOR)
> > +		return handle_machine_check(vcpu, kvm_run);
> > +
> >   
> 
> It isn't sufficient to check the vector number; you also need to check 
> the interrupt type.  See for example is_page_fault() and is_no_device().
> 
> I suggest you add an is_machine_check() along similar lines.  Later we 
> can collapse all those functions to use a single helper.

OK. I will do this.

> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -382,6 +382,8 @@ struct kvm_vcpu_arch {
> >  	u64 mcg_status;
> >  	u64 mcg_ctl;
> >  	u64 *mce_banks;
> > +
> > +	u32 exit_reason;
> >  };
> >   
> 
> Please move this into struct vcpu_vmx.

OK.

Best Regards,
Huang Ying

