Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbZLJR6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbZLJR6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761092AbZLJR6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:58:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:53007 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761059AbZLJR6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:58:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IFD6TVP1RNKUPn8xUwhCc8tRN24TSErPgJP/umR9t0TVQNhf8axQ6GmABFB3YzcLhj
         eV5ipp3t1MLC53cIhaAcClb9z9REo7ZiAbpEqVA5hnaO/IZqPsotWoEuZ+u/pOcOnrcB
         femlGkhFHecmmMPw+ZIMsv+agYZ3H/7GR6CwY=
Message-ID: <4B2136D5.1030402@gmail.com>
Date: Thu, 10 Dec 2009 20:58:45 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Xiaotian Feng <dfeng@redhat.com>, lenb@kernel.org, ming.m.lin@intel.com,
       robert.moore@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or in_atomic
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com> <20091210100907.GA2446@ucw.cz>
In-Reply-To: <20091210100907.GA2446@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Please elaborate... Your comments "ugly as hell" are too often to be
specific...
There is only one use of ACPI_PREEMPTION_POINT(), and it is in the
ACPICA code,
which we all agreed to keep OS independent, thus the need for #define.
Do you see any other way to add preemption point without introducing
Linux-specific
code into ACPICA?

Thanks,
Alex.


Pavel Machek пишет:
> On Fri 2009-12-04 12:26:00, Xiaotian Feng wrote:
>   
>> commit 8bd108d adds preemption point after each opcode parse, then
>> a sleeping function called from invalid context bug was founded
>> during suspend/resume stage. this was fixed in commit abe1dfa by
>> don't cond_resched when irq_disabled. But recent commit 138d156 changes
>> the behaviour to don't cond_resched when in_atomic. This makes the
>> sleeping function called from invalid context bug happen again, which
>> is reported in http://lkml.org/lkml/2009/12/1/371.
>>
>> The fix is to cond_sched() only when preemptible, which means not in
>> irq_disabled or in_atomic.
>>
>> @@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
>>  #include <linux/hardirq.h>
>>  #define ACPI_PREEMPTION_POINT() \
>>  	do { \
>> -		if (!in_atomic_preempt_off()) \
>> +		if (preemptible()) \
>>  			cond_resched(); \
>>  	} while (0)
>>     
>
> Note that this is ugly as hell. It means we have two acpi
> interpretters in kernel, one for preemptible, one for non-preemptible,
> with very different behaviour.
>
> It would be slightly nicer to pass the "preemptible" info explicitely,
> as function parameters.
>
> It would be even better not to need that difference.
>
> 									Pavel
>   

