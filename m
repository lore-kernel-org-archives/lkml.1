Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbZEHIAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbZEHIAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZEHIA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:00:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbZEHIA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:00:28 -0400
Message-ID: <4A03E644.5000103@redhat.com>
Date: Fri, 08 May 2009 10:59:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet>
In-Reply-To: <20090507233503.GA9103@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> I think comparison is not entirely fair. You're using
> KVM_HC_VAPIC_POLL_IRQ ("null" hypercall) and the compiler optimizes that
> (on Intel) to only one register read:
>
>         nr = kvm_register_read(vcpu, VCPU_REGS_RAX);
>
> Whereas in a real hypercall for (say) PIO you would need the address,
> size, direction and data.
>   

Well, that's probably one of the reasons pio is slower, as the cpu has 
to set these up, and the kernel has to read them.

> Also for PIO/MMIO you're adding this unoptimized lookup to the 
> measurement:
>
>         pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
>         if (pio_dev) {
>                 kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
>                 complete_pio(vcpu); 
>                 return 1;
>         }
>   

Since there are only one or two elements in the list, I don't see how it 
could be optimized.

> Whereas for hypercall measurement you don't. I believe a fair comparison
> would be have a shared guest/host memory area where you store guest/host
> TSC values and then do, on guest:
>
> 	rdtscll(&shared_area->guest_tsc);
> 	pio/mmio/hypercall
> 	... back to host
> 	rdtscll(&shared_area->host_tsc);
>
> And then calculate the difference (minus guests TSC_OFFSET of course)?
>   

I don't understand why you want host tsc?  We're interested in 
round-trip latency, so you want guest tsc all the time.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

