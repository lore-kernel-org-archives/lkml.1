Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZETOtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZETOtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbZETOtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:49:17 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:5547 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753217AbZETOtQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:49:16 -0400
X-BigFish: VPS-23(zz1432R98dR1805Mzz1202hzzz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJY6HR-02-IQH-01
Date: Wed, 20 May 2009 16:49:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on
	several CPUs
Message-ID: <20090520144905.GA27991@aftab>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com> <20090519172449.GB18874@aftab> <4A1392A9.9010609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A1392A9.9010609@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 20 May 2009 14:49:07.0889 (UTC) FILETIME=[20E45A10:01C9D95A]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 19, 2009 at 10:18:33PM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > +
> > +/* rdmsr on a bunch of CPUs
> > + *
> > + * @mask:	which CPUs
> > + * @msr_no:	which MSR
> > + * @msrs:	array of MSR values
> > + *
> > + * Returns:
> > + * 0 - success
> > + * <0 - read failed on at least one CPU (latter in the mask)
> > + */
> > +int rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
> > +{
> > +	struct msr *reg;
> > +	int cpu, tmp, err = 0;
> > +	int off = cpumask_first(mask);
> > +
> > +	for_each_cpu(cpu, mask) {
> > +		reg = &msrs[cpu - off];
> > +
> > +		tmp = rdmsr_on_cpu(cpu, msr_no, &reg->l, &reg->h);
> > +		if (tmp)
> > +			err = tmp;
> > +	}
> > +	return err;
> > +}
> > +EXPORT_SYMBOL(rdmsr_on_cpus);
> > +
> > +/*
> > + * wrmsr of a bunch of CPUs
> > + *
> > + * @mask:	which CPUs
> > + * @msr_no:	which MSR
> > + * @msrs:	array of MSR values
> > +  *
> > + * Returns:
> > + * 0 - success
> > + * <0 - write failed on at least one CPU (latter in the mask)
> > + */
> > +int wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
> > +{
> > +	struct msr reg;
> > +	int cpu, tmp, err = 0;
> > +	int off = cpumask_first(mask);
> > +
> > +	for_each_cpu(cpu, mask) {
> > +		reg = msrs[cpu - off];
> > +
> > +		tmp = wrmsr_on_cpu(cpu, msr_no, reg.l, reg.h);
> > +		if (tmp)
> > +			err = tmp;
> > +	}
> > +	return err;
> > +}
> > +EXPORT_SYMBOL(wrmsr_on_cpus);
> > +
> 
> Okay, now I'm *really* confused.
> 
> I thought the whole point of these functions was to allow these MSR
> references to take place in parallel, as opposed to doing outcalls to
> each CPU in order... but that's exactly what these functions do.
> 
> So what was the point of them again?

We currently need them for enabling the NB error reporting bank over
MCG_CTL on each core on the node. The question is whether we really need
the concurrency when accessing an MSR on several cores. With MCG_CTL,
BKDG says "It is expected that this register is programmed to the same
value in all nodes," but nothing concerning concurrency.

But you're right, if this interface is supposed to be generic enough,
it is probably wise to access an MSR concurrently. I could imagine
an obscure case where this is required. However, is sending IPIs
(smp_call_function_many) guaranteeing the needed concurrency? Or, should
it be more like how the mtrr code jumps through hoops (set_mtrr())
in order to ensure that _ALL_ registers have been written _before_
continuing?

Opinions? Flames?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

