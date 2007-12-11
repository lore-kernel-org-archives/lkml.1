Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXLKO5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXLKO5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXLKO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:57:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:3517 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXLKO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:57:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=oOrbIKOS4/WvZQY1AOslwc7+bLS/Ud6EYEcyTLsrJpShs050Pp/Qvg82Hun1P+sV43SiticUWYRM41zNFYsNzVMLS2pPck5CMk69s5Ce3pMr+PJyL9dwctXemDbmFtKyWaH5iPETu7K1uzEJo4GUoeasvHlMCVvodtoz8toeUlM=
Message-ID: <475EA54C.4090306@qumranet.com>
Date: Tue, 11 Dec 2007 16:57:16 +0200
Reply-To: dor.laor@qumranet.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: Performance overhead of get_cycles_sync
References: <475E8C8B.7070308@qumranet.com> <p73lk81nw71.fsf@bingen.suse.de>
In-Reply-To: <p73lk81nw71.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> [headers rewritten because of gmane crosspost breakage]
>
>   
>> In the latest kernel (2.6.24-rc3) I noticed a drastic performance 
>> decrease for KVM networking.
>>     
>
> That should not have changed for quite some time.
>
> Also it depends on the CPU of course.
>   
I didn't find the exact place of the change but using fedora 2.6.23-8 
there is no problem.
3aefbe0746580a710d4392a884ac1e4aac7c728f turn X86_FEATURE_SYNC_RDTSC  
off for most
intel cpus, but it was committed in May.

>   
>> The reason is many vmexit (exit reason is cpuid instruction) caused by
>> calls to gettimeofday that uses tsc sourceclock.
>> read_tsc calls get_cycles_sync which might call cpuid in order to 
>> serialize the cpu.
>>
>> Can you explain why the cpu needs to be serialized for every gettime call?
>>     
>
> Otherwise RDTSC can be speculated around and happen outside the protection
> of the seqlock and that can sometimes lead to non monotonic time reporting.
>   
What about moving the result into memory and calling mb() instead?
> Anyways after a lot of discussions it turns out there are ways to archive
> this without CPUID and there is a solution implemented for this in ff
> tree which I will submit for .25. It's a little complicated though
> and not a quick fix.
>
>   
>> Do we need to be that accurate? (It will also slightly improve physical 
>> hosts).
>> I believe you have a reason and the answer is yes. In that case can you 
>> replace the serializing instruction
>> with an instruction that does not trigger vmexit? Maybe use 'ltr' for 
>> example?
>>     
>
> ltr doesn't synchronize RDTSC.
>
>   
According to Intel spec it is a serializing instruction along with cpuid 
and others.
> -Andi
>
>   

