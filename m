Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbZGPQwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbZGPQwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbZGPQwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:52:08 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:17621 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932588AbZGPQwF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:52:05 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1432R98dN936eM179dNzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KMVW5Z-04-0H1-01
Date: Thu, 16 Jul 2009 18:51:36 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: execute on the correct CPU subset (was:
 Re: [PATCH] [x86, msr]: remove code duplication)
Message-ID: <20090716165136.GA31204@aftab>
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com>
 <4A526D38.7000803@zytor.com>
 <20090707103723.GD5668@aftab>
 <4A537010.3050905@zytor.com>
 <20090708111911.GC19315@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090708111911.GC19315@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Jul 2009 16:51:38.0593 (UTC) FILETIME=[AFCC8510:01CA0635]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 08, 2009 at 01:19:11PM +0200, Borislav Petkov wrote:
> On Tue, Jul 07, 2009 at 08:56:00AM -0700, H. Peter Anvin wrote:
> > Borislav Petkov wrote:
> > > 
> > > Actually, the more important question is why am I executing anything on
> > > my own CPU without first checking if it is in the cpumask _at_ _all_?!
> > > /me ducks behind the sofa.
> > > 
> > > The right thing to do should be something like the following:
> > > 
> > > preempt_disable();
> > > this_cpu = raw_smp_processor_id();
> > > 
> > > if (cpumask_test_cpu(this_cpu, mask)) {
> > > 	local_irq_disable();
> > > 	msr_func(&rv);
> > > 	local_irq_enable();
> > > }
> > > 
> > > smp_call_function_many(mask, msr_func, &rv, 1);
> > > preempt_enable();
> > > 
> > 
> > I don't see why you're disabling local IRQs.
> 
> I guess I was trying to be overly careful but can't seem to think of a
> case when this would be appropriate. Hmm...
> 
> --
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Mon, 6 Jul 2009 16:08:34 +0200
> Subject: [PATCH] [x86, msr]: execute on the correct CPU subset
> 
> rdmsr_on_cpus/wrmsr_on_cpus were erroneously executing on the current
> CPU even in the case where it wasn't in the supplied bitmask. Add a
> check for that and handle accordingly.
> 
> While at it, since rdmsr_on_cpus and wrmsr_on_cpus are almost identical,
> fold them into a common __rwmsr_on_cpus helper passing a function
> pointer arg to the actual MSR operation.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/lib/msr.c |   53 +++++++++++++++++++--------------------------------
>  1 files changed, 20 insertions(+), 33 deletions(-)

any comments on that one, NAK/AK? Since it is a fix and not changing the
interface to external users, it might be a good idea to include it in
2.6.31, IMHO, no?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

