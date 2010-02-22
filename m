Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab0BVIem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 03:34:42 -0500
Received: from mail-qy0-f175.google.com ([209.85.221.175]:59203 "EHLO
	mail-qy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0BVIel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 03:34:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cy/VI7yfQcX/Hhc8PeMYU8zulBLKfJjEUuRdVK3GKqgkzpY9DvY3O4BeePmqHSD6Kb
         DlJ5tbN4+662u897NzBfbUX+mwY6c6R/VJ253S0VF0vb12dcap4RHAi45FK7QHiVvASK
         ApCvhrMoqxopaNwCRHzjOyqGWbGZfRHTbirk4=
MIME-Version: 1.0
In-Reply-To: <1266751349.10419.2.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
	 <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
	 <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
	 <1266750881.10419.1.camel@jlt3.sipsolutions.net>
	 <1266751349.10419.2.camel@jlt3.sipsolutions.net>
Date: Mon, 22 Feb 2010 16:34:40 +0800
Message-ID: <2375c9f91002220034m1beec51co7385a1cdbbcce7d2@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 7:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2010-02-21 at 12:14 +0100, Johannes Berg wrote:
>
>>         printk("got cpu\n");
>>         for_each_online_cpu(i) {
>>                 sm_work = per_cpu_ptr(stop_machine_work, i);
>>                 INIT_WORK(sm_work, stop_cpu);
>>                 queue_work_on(i, stop_machine_wq, sm_work);
>>         }
>>         /* This will release the thread on our CPU. */
>>         put_cpu();
>>         printk("put cpu\n");
>
> As odd as that may be, it hangs in put_cpu() here.
>

Hmm, does adding synchronize_sched() in _cpu_down() help?

Something like this:

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 677f253..681f5c5 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -228,6 +228,7 @@ static int __ref _cpu_down(unsigned int cpu, int
tasks_frozen)
        cpumask_copy(old_allowed, &current->cpus_allowed);
        set_cpus_allowed_ptr(current, cpu_active_mask);

+       synchronize_sched();
        err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
        if (err) {
                set_cpu_active(cpu, true);
