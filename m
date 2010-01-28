Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043Ab0A1Gqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0A1Gqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095Ab0A1Gqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:46:30 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33130 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0A1Gq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:46:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BsRsCeN8uL8RzPKRCyuurUH3p2BvU2C+65LkSN7+6mE4C4z2aXiT3552lF3E7oyBUS
         cNeJFKcABjK26AzWkhm/bwokpHlhrDCpvYIIjq4EQew3KoUyW1S3GqScienLtCkOpptL
         Lwf7bNKyiGHo+nA5e/JM+eXc5vMLL6U196uLg=
MIME-Version: 1.0
In-Reply-To: <520f0cf11001270506ge76cca1ha259539a101522c2@mail.gmail.com>
References: <a0e7fce51001270318q6f16aea1j765849bb09df8640@mail.gmail.com>
	 <520f0cf11001270506ge76cca1ha259539a101522c2@mail.gmail.com>
Date: Thu, 28 Jan 2010 14:46:27 +0800
Message-ID: <a0e7fce51001272246o17b36c60r337221f79b40a103@mail.gmail.com>
Subject: Re: [PATCH] cyclictest: Set tracing_thresh optionally
From: yi li <liyi.dev@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: williams@redhat.com, tglx@linutronix.de,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 9:06 PM, John Kacur <jkacur@redhat.com> wrote:
> On Wed, Jan 27, 2010 at 12:18 PM, yi li <liyi.dev@gmail.com> wrote:
>> Hi,
>>
>> In cyclictest, by default "tracing_thresh" will be set to "tracelimit"
>> (given to cyclictest with option "-b tracelimit").
>> If the maximum latency of the tracer currently used is less than
>> "tracelimit", no trace will be recorded.
>
> So, can't you just set the tracing_thresh to your desired value with the
> -b tracelimit option?
>
> Explain to me how cyclictest will behave if tracelimit and tracing_thresh
> are set to different values.
>
> If you showed us two sets of outputs (with and without your option)
> to show what setting tracing_thresh separately would achieve that
> would be helpful.
>
Here is an example:

1.  run cyclictest with "wakeup-rt" tracer (In my case, max latency of
cyclictest is caused by "wakeup"):

root:/> ./cyclictest -p 80 -n -t 1 -l 10000 -i 20000 -b 5000 -W
could not set latency_hist/wakeup_latency/reset to 1
policy: fifo: loadavg: 4.98 3.32 1.47 6/30 363

T: 0 (  359) P:80 I:20000 C:    373 Min:     74 Act: 5194 Avg:  158 Max:    5194
# Thread Ids: 00359
# Break thread: 359
root:/> cat /sys/kernel/debug/tracing/trace
# tracer: wakeup_rt
#
# wakeup_rt latency trace v1.1.5 on 2.6.32.6-ADI-2010R1-pre-svn8240
# --------------------------------------------------------------------
# latency: 5138 us, #5/5, CPU#0 | (M:desktop VP:0, KP:0, SP:0 HP:0)
#    -----------------
#    | task: -359 (uid:0 nice:0 policy:1 rt_prio:80)
#    -----------------
#
#                  _------=> CPU#
#                 / _-----=> irqs-off
#                | / _----=> need-resched
#                || / _---=> hardirq/softirq
#                ||| / _--=> preempt-depth
#                |||| /_--=> lock-depth
#                |||||/     delay
#  cmd     pid   |||||| time  |   caller
#     \   /      ||||||   \   |   /
      ls-364     0dNh..    7us+:    364:120:R   + [000]   359: 19:S cyclictest
      ls-364     0dNh..   20us!: _wake_up_process <-_hrtimer_wakeup
      ls-364     0d.... 5127us+: _schedule <-_system_call
      ls-364     0d.... 5130us :    364:120:R ==> [000]   359: 19:R cyclictest

2. Now we want to run cyclictest with "irqsoff" tracer:
Without my patch, "irqsoff" tracer cannot recored valid trace,
because "tracing_thresh" will be set to "5000", and max latency of
"irqsoff" in this case is less than "5000".

root:/> ./cyclictest -p 80 -n -t 1 -l 10000 -i 20000 -b 5000 -I
could not set latency_hist/wakeup_latency/reset to 1
policy: fifo: loadavg: 5.08 3.78 1.80 6/30 408

T: 0 (  402) P:80 I:20000 C:   1217 Min:     84 Act:  179 Avg:  167 Max:    3933
# Thread Ids: 00402
# Break thread: 402
root:/> cat /sys/kernel/debug/tracing/trace
# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.32.6-ADI-2010R1-pre-svn8240
# --------------------------------------------------------------------
# latency: 5138 us, #5/5, CPU#0 | (M:desktop VP:0, KP:0, SP:0 HP:0)
#    -----------------
#    | task: -359 (uid:0 nice:0 policy:1 rt_prio:80)
#    -----------------
#
#                  _------=> CPU#
#                 / _-----=> irqs-off
#                | / _----=> need-resched
#                || / _---=> hardirq/softirq
#                ||| / _--=> preempt-depth
#                |||| /_--=> lock-depth
#                |||||/     delay
#  cmd     pid   |||||| time  |   caller
#     \   /      ||||||   \   |   /
      ls-364     0dNh..    7us+:    364:120:R   + [000]   359: 19:S cyclictest
      ls-364     0dNh..   20us!: _wake_up_process <-_hrtimer_wakeup
      ls-364     0d.... 5127us+: _schedule <-_system_call
      ls-364     0d.... 5130us :    364:120:R ==> [000]   359: 19:R cyclictest

3. With my patch, run cyclic test with "irqsoff" tracer can get expected trace
 (because "tracing_thresh" is reset to "0" in this case).

root:/> ./cyclictest -p 80 -n -t 1 -l 10000 -i 20000 -b 5000 -I
could not set latency_hist/wakeup_latency/reset to 1
policy: fifo: loadavg: 5.00 4.79 3.15 6/30 701

T: 0 (  700) P:80 I:20000 C:    147 Min:     92 Act: 8706 Avg:  226 Max:    8706
# Thread Ids: 00700
# Break thread: 700
root:/> cat /sys/kernel/debug/tracing/trace
# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.32.6-ADI-2010R1-pre-svn8240
# --------------------------------------------------------------------
# latency: 116 us, #3/3, CPU#0 | (M:desktop VP:0, KP:0, SP:0 HP:0)
#    -----------------
#    | task: -694 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#  => started at: _user_path_at
#  => ended at:   _irq_exit
#
#
#                  _------=> CPU#
#                 / _-----=> irqs-off
#                | / _----=> need-resched
#                || / _---=> hardirq/softirq
#                ||| / _--=> preempt-depth
#                |||| /_--=> lock-depth
#                |||||/     delay
#  cmd     pid   |||||| time  |   caller
#     \   /      ||||||   \   |   /
      ls-694     0d....    1us!: __common_int_entry <-_user_path_at
      ls-694     0dNs..  112us+: ___do_softirq <-_irq_exit
      ls-694     0dNs..  119us : _trace_hardirqs_on <-_irq_exit


4. Or we can set a smaller "tracing_thresh" (e.g 100).

root:/> ./cyclictest -p 80 -n -t 1 -l 10000 -i 20000 -b 5000 -I --tracing_thresh
 100
could not set latency_hist/wakeup_latency/reset to 1
policy: fifo: loadavg: 5.04 5.01 4.92 6/30 4235

T: 0 ( 4234) P:80 I:20000 C:    262 Min:     83 Act:  100 Avg:  165 Max:    1366
# Thread Ids: 04234
# Break thread: 4234

root:/> cat /sys/kernel/debug/tracing/tracing_thresh
100

root:/> cat /sys/kernel/debug/tracing/trace
# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.32.6-ADI-2010R1-pre-svn8240
# --------------------------------------------------------------------
# latency: 102 us, #3/3, CPU#0 | (M:desktop VP:0, KP:0, SP:0 HP:0)
#    -----------------
#    | task: -4231 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#  => started at: _dput
#  => ended at:   _irq_exit
#
#
#                  _------=> CPU#
#                 / _-----=> irqs-off
#                | / _----=> need-resched
#                || / _---=> hardirq/softirq
#                ||| / _--=> preempt-depth
#                |||| /_--=> lock-depth
#                |||||/     delay
#  cmd     pid   |||||| time  |   caller
#     \   /      ||||||   \   |   /
      ls-4231    0d....    1us+: __common_int_entry <-_dput
      ls-4231    0d.s..   99us+: ___do_softirq <-_irq_exit
      ls-4231    0d.s..  105us : _trace_hardirqs_on <-_irq_exit

>> +
>> +               if (tracing_thresh > 0 && tracing_thresh <= tracelimit) {
>> +                       sprintf(buffer, "%d", tracing_thresh);
>> +                       setkernvar("tracing_thresh", buffer);
>> +               }
>
> Do you need an else part that sets tracing_thresh to tracelimit?
>

I think by default set "tracing_thresh" to "0" makes more sense, i.e,
disable tracing thresh.
So max latency of current tracer can be recorded.

If people want the old behavior, cyclictest can be called with option
like " cyclictest -b 1000 --tracing_thresh 1000".

I will change this code and resend the patch:

+		if (tracing_thresh >= 0 && tracing_thresh <= tracelimit) {
+			sprintf(buffer, "%d", tracing_thresh);
+			setkernvar("tracing_thresh", buffer);
+		}


>
>>
>>                /* ftrace_enabled is a sysctl variable */
>>                fileprefix = procfileprefix;
>> @@ -766,6 +769,7 @@ static void display_help(int error)
>>               "                           without -t default = 1\n"
>>               "-T TRACE --tracer=TRACER   set tracing function\n"
>>               "    configured tracers: %s\n"
>> +              "--tracing_thresh=THRESH    set tracing_thresh of current
>> tracer to THRESH\n"
>
> If you run your patch through checkpatch you'll get
>
> ERROR: patch seems to be corrupt (line wrapped?)
> #64: FILE: src/cyclictest/cyclictest.c:772:
> tracer to THRESH\n"
>
> And because of the above, I am unable to apply your patch
> with git am
>
> We don't follow all the kernel style recommendations in cyclictest
> but we try to follow most of them. So please run your patch
> through checkpatch and fix-up the warnings.
>

Sorry about that. I will resend the patch soon.

-Yi
