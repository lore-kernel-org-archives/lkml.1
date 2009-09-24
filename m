Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZIXPLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZIXPLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZIXPK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:10:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZIXPK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:10:58 -0400
Date: Thu, 24 Sep 2009 12:10:49 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH: kvm 2/6] Kill the confusing tsc_ref_khz and ref_freq
	variables.
Message-ID: <20090924151049.GB14102@amt.cnet>
References: <1253762945-5750-1-git-send-email-zamsden@redhat.com> <1253762945-5750-2-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253762945-5750-2-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 05:29:01PM -1000, Zachary Amsden wrote:
> They are globals, not clearly protected by any ordering or locking, and
> vulnerable to various startup races.
> 
> Instead, for variable TSC machines, register the cpufreq notifier and get
> the TSC frequency directly from the cpufreq machinery.  Not only is it
> always right, it is also perfectly accurate, as no error prone measurement
> is required.  On such machines, also detect the frequency when bringing
> a new CPU online; it isn't clear what frequency it will start with, and
> it may not correspond to the reference.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/kvm/x86.c |   38 ++++++++++++++++++++++++++++----------
>  1 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 15d2ace..35082dd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -650,6 +650,19 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
>  
>  static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
>  
> +static inline void kvm_get_cpu_khz(int cpu)
> +{
> +	unsigned int khz = cpufreq_get(cpu);

cpufreq_get does down_read, while kvm_arch_hardware_enable is called
either with a spinlock held or from interrupt context?

