Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbZLDH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbZLDH1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZLDH1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:27:48 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:54254 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZLDH1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:27:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kPqMs91P4EGYWk35QlDqbd38BFEe/pYU8D+4YgPQLcYbWs5ssko1L2hlfykrEGFZLz
         Ha1efLFdAvpdJSRsvKIvNxPdMnOAfvSo696ht8ld5peC1qodAapcTdPxNUS5Zvqbk5Ne
         GsfqMYcRWYsHu1W1NZB0N7be1HebXx37ZDQuI=
Message-ID: <4B18B9FC.5030309@gmail.com>
Date: Thu, 03 Dec 2009 23:27:56 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Danny Feng <dfeng@redhat.com>
CC: lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or 	in_atomic
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com> <dd18b0c30912032250k7502c751mb8aefe7f915a281b@mail.gmail.com> <4B18B4CA.5060602@redhat.com>
In-Reply-To: <4B18B4CA.5060602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/09 23:05, Danny Feng wrote:
> On 12/04/2009 02:50 PM, Justin Mattock wrote:
>> On Thu, Dec 3, 2009 at 8:26 PM, Xiaotian Feng<dfeng@redhat.com> wrote:
>>> commit 8bd108d adds preemption point after each opcode parse, then
>>> a sleeping function called from invalid context bug was founded
>>> during suspend/resume stage. this was fixed in commit abe1dfa by
>>> don't cond_resched when irq_disabled. But recent commit 138d156 changes
>>> the behaviour to don't cond_resched when in_atomic. This makes the
>>> sleeping function called from invalid context bug happen again, which
>>> is reported in http://lkml.org/lkml/2009/12/1/371.
>>>
>>> The fix is to cond_sched() only when preemptible, which means not in
>>> irq_disabled or in_atomic.
>>>
>>> Reported-and-bisected-by: Larry Finger<Larry.Finger@lwfinger.net>
>>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>>> ---
>>> include/acpi/platform/aclinux.h | 2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/acpi/platform/aclinux.h
>>> b/include/acpi/platform/aclinux.h
>>> index 9d7febd..5b415ee 100644
>>> --- a/include/acpi/platform/aclinux.h
>>> +++ b/include/acpi/platform/aclinux.h
>>> @@ -152,7 +152,7 @@ static inline void
>>> *acpi_os_acquire_object(acpi_cache_t * cache)
>>> #include<linux/hardirq.h>
>>> #define ACPI_PREEMPTION_POINT() \
>>> do { \
>>> - if (!in_atomic_preempt_off()) \
>>> + if (preemptible()) \
>>> cond_resched(); \
>>> } while (0)
>>>
>>> --
>>> 1.6.5.2
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at http://www.tux.org/lkml/
>>>
>>
>> looks good
>> kernel compiled without any issues,
>> echo mem> /sys/power/state
>> reported no warning message.
>>
>> Also if you don't mind add:
>> Reported-and-bisected-by: Justin P. Mattock<justinmattock@gmail.com>
>>
> Sure, sorry for I had missed thread for
>
> http://bugzilla.kernel.org/show_bug.cgi?id=14483
>
>> Id like to get some kind of credit for this b*tch.
>>
>
>

no worries.. I'll run
my system with this change
to see if anything happens.

As for the bug, leave it open
until this makes it's way into
the main kernel, then rafael can
close it

Justin P. Mattock
