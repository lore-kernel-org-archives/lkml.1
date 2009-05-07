Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZEGXg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZEGXg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZEGXgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:36:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51967 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZEGXgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:36:43 -0400
Date: Thu, 7 May 2009 20:35:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090507233503.GA9103@amt.cnet>
References: <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A031471.7000406@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 01:03:45PM -0400, Gregory Haskins wrote:
> Chris Wright wrote:
> > * Gregory Haskins (ghaskins@novell.com) wrote:
> >   
> >> Chris Wright wrote:
> >>     
> >>> VF drivers can also have this issue (and typically use mmio).
> >>> I at least have a better idea what your proposal is, thanks for
> >>> explanation.  Are you able to demonstrate concrete benefit with it yet
> >>> (improved latency numbers for example)?
> >>>       
> >> I had a test-harness/numbers for this kind of thing, but its a bit
> >> crufty since its from ~1.5 years ago.  I will dig it up, update it, and
> >> generate/post new numbers.
> >>     
> >
> > That would be useful, because I keep coming back to pio and shared
> > page(s) when think of why not to do this.  Seems I'm not alone in that.
> >
> > thanks,
> > -chris
> >   
> 
> I completed the resurrection of the test and wrote up a little wiki on
> the subject, which you can find here:
> 
> http://developer.novell.com/wiki/index.php/WhyHypercalls
> 
> Hopefully this answers Chris' "show me the numbers" and Anthony's "Why
> reinvent the wheel?" questions.
> 
> I will include this information when I publish the updated v2 series
> with the s/hypercall/dynhc changes.
> 
> Let me know if you have any questions.

Greg,

I think comparison is not entirely fair. You're using
KVM_HC_VAPIC_POLL_IRQ ("null" hypercall) and the compiler optimizes that
(on Intel) to only one register read:

        nr = kvm_register_read(vcpu, VCPU_REGS_RAX);

Whereas in a real hypercall for (say) PIO you would need the address,
size, direction and data.

Also for PIO/MMIO you're adding this unoptimized lookup to the 
measurement:

        pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
        if (pio_dev) {
                kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
                complete_pio(vcpu); 
                return 1;
        }

Whereas for hypercall measurement you don't. I believe a fair comparison
would be have a shared guest/host memory area where you store guest/host
TSC values and then do, on guest:

	rdtscll(&shared_area->guest_tsc);
	pio/mmio/hypercall
	... back to host
	rdtscll(&shared_area->host_tsc);

And then calculate the difference (minus guests TSC_OFFSET of course)?

