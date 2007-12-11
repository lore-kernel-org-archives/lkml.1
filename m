Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbXLKOOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbXLKOOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbXLKOOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:14:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:34237 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbXLKOOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=mQs1F79RQM6P2iPEJ+oAljPPvmCU5GYMHYeI/D/pyUMF0jYHRQ77p7i6jr8XQrr5kig0qzsqe2QKe3+MFH/iRV8OzFsRGrspmUW7tc8hbh7rFO5+2wxN40U3ciMAdDZT8UMsFzI4urTBoedSkcemhyaPANA+QCsYJm9YSxHtiXw=
Message-ID: <475E9B4F.2090008@qumranet.com>
Date: Tue, 11 Dec 2007 16:14:39 +0200
Reply-To: dor.laor@qumranet.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Performance overhead of get_cycles_sync
References: <475E8C8B.7070308@qumranet.com> <20071211133738.GA8150@elte.hu>
In-Reply-To: <20071211133738.GA8150@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> * Dor Laor <dor.laor@gmail.com> wrote:
>
> > Hi Ingo, Thomas,
> >
> > In the latest kernel (2.6.24-rc3) I noticed a drastic performance
> > decrease for KVM networking. The reason is many vmexit (exit reason is
> > cpuid instruction) caused by calls to gettimeofday that uses tsc
> > sourceclock. read_tsc calls get_cycles_sync which might call cpuid in
> > order to serialize the cpu.
> >
> > Can you explain why the cpu needs to be serialized for every gettime
> > call? Do we need to be that accurate? (It will also slightly improve
> > physical hosts). I believe you have a reason and the answer is yes. In
> > that case can you replace the serializing instruction with an
> > instruction that does not trigger vmexit? Maybe use 'ltr' for example?
>
> hm, where exactly does it call CPUID?
>
>         Ingo
>
Here, commented out [include/asm-x86/tsc.h]:
/* Like get_cycles, but make sure the CPU is synchronized. */
static __always_inline cycles_t get_cycles_sync(void)
{
    unsigned long long ret;
    unsigned eax, edx;

    /*
       * Use RDTSCP if possible; it is guaranteed to be synchronous
      * and doesn't cause a VMEXIT on Hypervisors
     */
    alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
               ASM_OUTPUT2("=a" (eax), "=d" (edx)),
               "a" (0U), "d" (0U) : "ecx", "memory");
    ret = (((unsigned long long)edx) << 32) | ((unsigned long long)eax);
    if (ret)
        return ret;

    /*
     * Don't do an additional sync on CPUs where we know
     * RDTSC is already synchronous:
     */
//    alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
//              "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
    rdtscll(ret);

    return ret;
}

