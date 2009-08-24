Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbZHXCax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbZHXCax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 22:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZHXCaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 22:30:52 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:57620 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZHXCav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 22:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LMUaB9XLUPDaCcUk0tCz5f0qC7mUiBkfTPqa3N0fUiH9/FmpkUkyCgydQuB9Fwa6/y
         HvzEQTwY3j+4oQRAnpEwyLbpYQtNqDmzqUDSNmg7WSNhYMQ7IQSE5v8NM8k9Cg8bAvNd
         H4svXK8g3n1NFBBnkPyBDm2tpGZMQ0WYUcmTY=
MIME-Version: 1.0
In-Reply-To: <1250872678.7538.80.camel@twins>
References: <3877989d0908132115n6d8c7caej4bc4c87ae7701cac@mail.gmail.com>
	 <1250872678.7538.80.camel@twins>
Date: Mon, 24 Aug 2009 10:30:53 +0800
Message-ID: <3877989d0908231930s2b313024m6dee07c57a1c7f25@mail.gmail.com>
Subject: Re: [RFC patch] need check TSC wrap unconditionally
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 22, 2009 at 12:37 AM, Peter Zijlstra<peterz@infradead.org> wrote:
> On Fri, 2009-08-14 at 12:15 +0800, Luming Yu wrote:
>> Hi there,
>
> Hi, thanks for CC'ing the right folks.
>
>> we disabled tsc wrap check on any platform that has NOSTOP_TSC cpu. But this
>> will cause some real problem.For example, 1.CPU does has constant and
>> non_stop tsc, which means different CPU ticks at same rate in same domain,but
>> have been given different initial TSC value.Then at any given time,
>> CPUsare unsynchronized.
>> 2. if those CPUs are sit in different domain..(multi-chassis cluster system?)
>>
>> Please review. If make sense, please apply.
>
> Right, so because your machine is funny, everybody with a good machine
> should suffer?

How comes? Good machine will pass the check without any problem.

>
> If the TSCs run at identical frequency (one time domain) but at
> different offsets, you can fix that by using cyc2ns_offset.

iirc, in old kernel, there was a function trying to re-sync TSC. But
it has been removed..
Should I re-introduce something that has been deleted. It is odd to do such
kind of thing to me if I don't know why it was deleted.

>
> When the machine has unsynchonized frequencies (multiple time domains),
> detect that during cpu enumeration and use that to disable the
> optimization.

yes.

>
>> Signed-off-by: Yu Luming <luming.yu@intel.com>
>
>>  arch/x86/kernel/tsc_sync.c |    7 +------
>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
>> index 027b5b4..312ba84 100644
>> --- a/arch/x86/kernel/tsc_sync.c
>> +++ b/arch/x86/kernel/tsc_sync.c
>> @@ -113,11 +113,6 @@ void __cpuinit check_tsc_sync_source(int cpu)
>>         if (unsynchronized_tsc())
>>                 return;
>>
>> -       if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
>> -               pr_info("Skipping synchronization checks as TSC is
>> reliable.\n");
>> -               return;
>> -       }
>> -
>>         pr_info("checking TSC synchronization [CPU#%d -> CPU#%d]:",
>>                 smp_processor_id(), cpu);
>>
>> @@ -171,7 +166,7 @@ void __cpuinit check_tsc_sync_target(void)
>>  {
>>         int cpus = 2;
>>
>> -       if (unsynchronized_tsc() || boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
>> +       if (unsynchronized_tsc())
>>                 return;
>>
>>         /*
>
