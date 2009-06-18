Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZFRB55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZFRB55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZFRB5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:57:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:42947 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbZFRB5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:57:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,240,1243839600"; 
   d="scan'208";a="700378675"
Subject: Re: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Herbert Xu <herbert@gondor.apana.org.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <4A3922A4.1080300@zytor.com>
References: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>
	 <20090617164622.GB25357@elte.hu>  <4A3922A4.1080300@zytor.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 09:57:48 +0800
Message-Id: <1245290268.11965.190.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 01:06 +0800, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> >>  
> >> +static inline int kernel_fpu_using(void)
> >> +{
> >> +	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
> >> +		return 1;
> >> +	return 0;
> >> +}
> >> +
> > 
> > Looks sane to me. Herbert, do you ack it?
> > 
> 
> Although I have to say, the structure of:
> 
> if (boolean test)
> 	return 1;
> return 0;
> 
> ... truly was hit with the ugly stick.  It really should be:
> 
> static inline bool kernel_fpu_using(void)
> {
> 	return in_interrupt() && !(read_cr0() && C86_CR0_TS);
> }

Yes. This is better. I will change this.

> Huang: if I recall correctly, these functions were originally designed
> to deal with the fact that VIA processors generate spurious #TS faults
> due to broken design of the Padlock instructions.  The AES and PCLMUL
> instructions actually use SSE registers and so will require different
> structure.

They are a little different. VIA want to make sure that they can deal
with spurious #TS faults, while AES and PCLMUL need to check whether
MMX/SSE registers are available.

After some thinking, I think something as follow may be more
appropriate:

/* This may be useful for someone else */
static inline bool fpu_using(void)
{
	return !(read_cr0() & X86_CR0_TS);
}

static inline bool irq_fpu_using(void)
{
	return in_interrupt() && fpu_using();
}

Best Regards,
Huang Ying


