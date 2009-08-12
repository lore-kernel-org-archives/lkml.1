Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZHLCnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZHLCnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 22:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZHLCne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 22:43:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57356 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZHLCnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 22:43:32 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
References: <20090811104144.5154.77871.sendpatchset@localhost.localdomain>
	<20090811104154.5154.78710.sendpatchset@localhost.localdomain>
	<m1r5vi9l9v.fsf@fess.ebiederm.org> <4A821A14.1020408@redhat.com>
	<m17hx9n6s5.fsf@fess.ebiederm.org> <4A822404.9030603@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 11 Aug 2009 19:43:30 -0700
In-Reply-To: <4A822404.9030603@redhat.com> (Amerigo Wang's message of "Wed\, 12 Aug 2009 10\:08\:04 +0800")
Message-ID: <m1ws5992gd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, mingo@elte.hu, akpm@linux-foundation.org, andi@firstfloor.org, nhorman@redhat.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC Patch 2/2] kexec: allow to shrink reserved memory
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Eric W. Biederman wrote:
>> Amerigo Wang <amwang@redhat.com> writes:
>>
>>   
>>> Eric W. Biederman wrote:
>>>     
>>>> Amerigo Wang <amwang@redhat.com> writes:
>>>>
>>>>         
>>>>> This patch implements shrinking the reserved memory for crash kernel,
>>>>> if it is more than enough.
>>>>>
>>>>> For example, if you have already reserved 128M, now you just want 100M,
>>>>> you can do:
>>>>>
>>>>> # echo $((100*1024*1024)) > /sys/kernel/kexec_crash_size
>>>>>             
>>>> This patch looks like a reasonable start.
>>>>
>>>> However once a crash kernel image is loaded we have already told that
>>>> image about the memory that is available and what you are doing here
>>>> will go and stop on the memory that is reserved but not yet used,
>>>> totally breaking the DMA protections.  AKA we know the memory is safe
>>>> from ongoing DMAs because it has lain fallow since boot up.
>>>>
>>>> The only safe thing to do is to reduce the memory size before (possibly
>>>> just before) we load the crash kernel.  Which means we should only
>>>> be allowed to shrink the size when nothing is loaded, exactly the
>>>> opposite of what you have implemented.
>>>>
>>>>         
>>> Confused, why just loading the crash kernel makes it unsafe?
>>> DMA should be avoided when reserving that memory during boot, shouldn't it?
>>>     
>>
>> Yes.  But you are removing the reservation and starting DMA on memory
>> we have told the crash kernel it can use.
>>   
>
> We can modify the info given to the crash kernel.

Only by unloading and reloading.

>>> I know I missed the part that freeing memory before loading, but if it is safe
>>> before loading, how can it be unsafe after that?
>>>     
>>
>> We tell the crash kernel when loading it, it can use all of the reserved memory.
>>   
>
> Yeah, but we should reload the kernel after shrinking the memory, it is not
> surprised that doing this is necessary...

So unload the crash kernel first.  If you don't you open a race where
many of the guarantees we make for the crash kernel about the state of
the memory it might be using are not true.

In general I expect we will be able to do this all before we load the
crash kernel the first time.  But at least we should not need to reboot
things if there is a problem.

Eric



