Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYLBDJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYLBDJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYLBDJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:09:05 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:42169 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYLBDJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Fa2NS3UEcomVrW+SoPU4ZgpFyIwfOzYopIGM77XZ/s0UH6ifMO0GdEN9JQrURZrZeu
         srOOOcT69Dd82ropvC4vPOwn+KqdXiTh8nW4+1WUPpZH6mCEcAOR0xFJyqBPdqADscZh
         XlK7oEeSoOIFxtQM+S21c9aXzPbVaUBBYscpg=
Message-ID: <7c86c4470812011909k59261f96g4e600badfeb0acb9@mail.gmail.com>
Date: Tue, 2 Dec 2008 04:09:02 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 21/24] perfmon: Intel architectural PMU support (x86)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811261446070.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c0e.06e2660a.1583.ffffcc0a@mx.google.com>
	 <alpine.LFD.2.00.0811261446070.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 3:55 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 26 Nov 2008, eranian@googlemail.com wrote:
>
>> +static u64 enable_mask[PFM_MAX_PMCS];
>
> Why do we need enable_mask twice for AMD and Intel ?
>
>> +static u16 max_enable;
>> +static int pfm_intel_arch_version;
>> +
>> +DEFINE_PER_CPU(u64, saved_global_ctrl);
>
> static
>
Why you want this static instead of per-cpu?

>> +/*
>> + * layout of EAX for CPUID.0xa leaf function
>> + */
>> +struct pmu_eax {
>> +     unsigned int version:8;         /* architectural perfmon version */
>> +     unsigned int num_cnt:8;         /* number of generic counters */
>> +     unsigned int cnt_width:8;       /* width of generic counters */
>> +     unsigned int ebx_length:8;      /* number of architected events */
>> +};
>
> in arch/x86/include/asm/intel_arch_perfmon.h we have already:
>
> union cpuid10_eax {
>        struct {
>                unsigned int version_id:8;
>                unsigned int num_counters:8;
>                unsigned int bit_width:8;
>                unsigned int mask_length:8;
>        } split;
>        unsigned int full;
> };
>
> Can we either use this or remove it ?
>

Well, I need more than eax. We could rewrite this union to include
eax, edx,  So I propose we call it union cpuid10 and define it as:

union cpuid_eax {
       struct {
               unsigned int version_id:8;
               unsigned int num_counters:8;
               unsigned int bit_width:8;
               unsigned int mask_length:8;
       } split_eax;
       struct {
              unsigned int num_counters:5;
              unsigned int bit_width:8;
              unsigned int reserved:19;
       } split_edx;
       unsigned int full;
}
