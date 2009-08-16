Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZHPUKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZHPUKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZHPUKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:10:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:16268 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbZHPUKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WQqtERYjLwUSa/xAfjDPjsFZTMWMnUhAwTkLgD93l16or6iH9ZCY5ygAGdKBgsoSGQ
         PcptXECu3Y1rrUEeuQQdurHXuHGoS534kkuLmkfPsxgQ0sxHdgjWY7RwQi7JjmrP8C0R
         gMLy9CB7NsJN0xDtQ+WM5SIWmL/s76nPEQ+wo=
Message-ID: <4A8867B3.6020504@gmail.com>
Date: Sun, 16 Aug 2009 17:10:27 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com> <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org> <20090816064132.GA16278@elte.hu>
In-Reply-To: <20090816064132.GA16278@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
>> Commit-ID:  c74cb13b94118ec89e48849806356b67caa5ff86
>> Gitweb:     http://git.kernel.org/tip/c74cb13b94118ec89e48849806356b67caa5ff86
>> Author:     Borislav Petkov <borislav.petkov@amd.com>
>> AuthorDate: Fri, 14 Aug 2009 14:06:34 +0200
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Sat, 15 Aug 2009 18:43:59 +0200
>>
>> x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
>>
>> fbd8b1819e80ac5a176d085fdddc3a34d1499318 turns off the bit for
>> /proc/cpuinfo. However, a proper/full fix would be to additionally
>> turn off the bit in the CPUID output so that future callers get
>> correct CPU features info.
>>
>> Do that by basically reversing what the BIOS wrongfully does at boot.
>>
>> Tested-by: Kevin Winchester <kjwinchester@gmail.com>
>> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>> Cc: kjwinchester@gmail.com
>> Cc: mikpe@it.uu.se
>> Cc: brgerst@gmail.com
>> LKML-Reference: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>>
>> ---
>>  arch/x86/kernel/cpu/amd.c |   12 +++++++++++-
>>  1 files changed, 11 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index 63fddcd..0ee63dd 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -404,9 +404,19 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>>  		/*
>>  		 * Some BIOSes incorrectly force this feature, but only K8
>>  		 * revision D (model = 0x14) and later actually support it.
>> +		 * (AMD Erratum #110, docId: 25759).
>>  		 */
>> -		if (c->x86_model < 0x14)
>> +		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
>> +			u64 val;
>> +
>>  			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
>> +			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
>> +				val &= ~(1ULL << 32);
>> +				wrmsr_amd_safe(0xc001100d, (u32) val,
>> +							   (u32)(val >> 32));
>> +			}
>> +		}
>> +
>>  	}
>>  	if (c->x86 == 0x10 || c->x86 == 0x11)
>>  		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> 
> -tip testing found this build bug caused by this patch:
> 
> arch/x86/kernel/cpu/amd.c: In function ‘init_amd’:
> arch/x86/kernel/cpu/amd.c:417: error: implicit declaration of function ‘wrmsr_amd_safe’
> 

I didn't see a notification that patch 1/2:

 x86, msr: Add a AMD wrmsr with exception handling

got applied before this patch.  That could be the cause of this failure.

-- 
Kevin Winchester

