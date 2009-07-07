Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZGGKie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZGGKie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZGGKi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:38:26 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11472 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZGGKiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:38:25 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1432R98dN1805Mzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KMEQVT-02-FBR-01
Date: Tue, 7 Jul 2009 12:37:23 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: remove code duplication
Message-ID: <20090707103723.GD5668@aftab>
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com>
 <4A526D38.7000803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A526D38.7000803@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2009 10:37:23.0142 (UTC) FILETIME=[E996DE60:01C9FEEE]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 02:31:36PM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > -
> > -	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
> > +	smp_call_function_single(this_cpu, msr_func, &rv, 1);
> > +	smp_call_function_many(mask, msr_func, &rv, 1);
> >  	preempt_enable();
> 
> Why are you using smp_call_function_single() to execute something *on
> your own CPU*?

Actually, the more important question is why am I executing anything on
my own CPU without first checking if it is in the cpumask _at_ _all_?!
/me ducks behind the sofa.

The right thing to do should be something like the following:

preempt_disable();
this_cpu = raw_smp_processor_id();

if (cpumask_test_cpu(this_cpu, mask)) {
	local_irq_disable();
	msr_func(&rv);
	local_irq_enable();
}

smp_call_function_many(mask, msr_func, &rv, 1);
preempt_enable();

Patch coming up...

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

