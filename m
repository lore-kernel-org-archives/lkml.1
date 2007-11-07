Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbXKGQz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbXKGQz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXKGQzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:55:20 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:36833 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754084AbXKGQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:55:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HALN8MUdMROHU/2dsb2JhbACBWw
Date: Wed, 7 Nov 2007 11:55:13 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Mike Mason <mmlnx@us.ibm.com>
Cc: ltt-dev@shafik.org, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [to-be-posted-soon] Multiple handlers per marker
Message-ID: <20071107165513.GA4412@Krystal>
References: <472A345C.2010208@us.ibm.com> <20071101221530.GC19700@Krystal> <20071102033654.GA1301@Krystal> <20071104232442.GA32320@Krystal> <472F9D63.7010906@us.ibm.com> <20071105231735.GA620@Krystal> <4730EC6D.7040709@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4730EC6D.7040709@us.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:50:32 up 3 days, 21:55,  4 users,  load average: 0.16, 0.29,
	0.28
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Mason (mmlnx@us.ibm.com) wrote:
> Mathieu Desnoyers wrote:
>> * Mike Mason (mmlnx@us.ibm.com) wrote:
>>> Mathieu Desnoyers wrote:
>>>> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
>>>>> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
>>>>>> * Mike Mason (mmlnx@us.ibm.com) wrote:
>>>>>>> Hi Mathieu,
>>>>>>>
>>>>>>> Are you aware of any working being done to allow multiple handlers to 
>>>>>>> be attached to a marker?  Something like what kprobes allows.  I've 
>>>>>>> started to look into this and don't want to duplicate efforts.
>>>>>>>
>>>>>> Nope, but I know we will have to address this.
>>>>>>
>>>>>> Something along the lines of walking an RCU list of function pointers,
>>>>>> calling them.
>>>>>>
>>>>>> The only downside I see is that we will have to pass a va_list * 
>>>>>> instead
>>>>>> of real va args. The could make the marker site a little bit bigger 
>>>>>> and
>>>>>> will change the probe callback arguments.
>>>>>>
>>>>>> What do you think about these ideas ?
>>>>>>
>>>>>> If we can find a way to make the common case (only one probe 
>>>>>> connected)
>>>>>> _ultra_ fast, and yet architecture independent, that would be awesome. 
>>>>>> A
>>>>>> simple call is kind of hard to beat though.. So we may have to think
>>>>>> about a design with :
>>>>>>
>>>>>> - One call at the marker site
>>>>>> - if 1 probe is installed :
>>>>>>   - If the format string is empty, connect a probe without va args.
>>>>>>   - If the format string is not empty, connect a "stage 1" probe that 
>>>>>> takes
>>>>>>     the va args, starts/ends the va_list and calls _one_ function 
>>>>>> (let's
>>>>>>     call it "stage 2" probe), that takes va_list as parameter.
>>>>>> - if more than 1 probe is installed :
>>>>>>   - The stage 1 probe creates the va_list and passes it to each 
>>>>>> function
>>>>>>     connected, iterated with an RCU list.
>>>>>>
>>>>>> What do you think ?
>>>>>>
>>>>>> Mathieu
>>>>>>
>>>>> I'm working on an implementation.
>>>>>
>>>> It's ready for testing. Please grab
>>>> http://ltt.polymtl.ca/lttng/patch-2.6.24-rc1-git13-lttng-0.10-pre18.tar.bz2
>>>> patch name :
>>>> markers-support-multiple-probes.patch
>>> This patch alone doesn't apply cleanly at all on 2.6.24-rc1-git14.  Are 
>>> there other patches in this series I should apply first?
>>>
>> Yes, the following ones should suffice :
>> # instrumentation menu removal
>> add-kconfig-to-arch.patch
>> add-arch-supports-oprofile.patch
>> add-arch-supports-kprobes.patch
>> move-kconfig-instrumentation-to-arch.patch
>> #
>> kprobes-use-mutex-for-insn-pages.patch
>> kprobes-dont-use-kprobes-mutex-in-arch-code.patch
>> kprobes-declare-kprobes-mutex-static.patch
>> declare-array.patch
>> text-edit-lock-architecture-independent-code.patch
>> text-edit-lock-alternative-i386-and-x86_64.patch
>> text-edit-lock-kprobes-architecture-independent.patch
>> text-edit-lock-kprobes-i386.patch
>> text-edit-lock-kprobes-x86_64.patch
>> text-edit-lock-i386-standardize-debug-rodata.patch
>> text-edit-lock-x86_64-standardize-debug-rodata.patch
>> #
>> immediate-values-architecture-independent-code.patch
>> immediate-values-kconfig-embedded.patch
>> immediate-values-move-kprobes-i386-restore-interrupt-to-kdebug-h.patch
>> add-asm-compat-to-x86.patch
>> immediate-values-i386-optimization.patch
>> immediate-values-powerpc-optimization.patch
>> immediate-values-documentation.patch
>> #
>> linux-kernel-markers-immediate-values.patch
>> #
>> markers-support-multiple-probes.patch
>> Tell me if you still have rejects.
>
> I applied the above patches to 2.6.24-rc1-git14.  They applied fine with 
> just a few offsets until the last patch, which yielded this result:
>
> patching file include/linux/marker.h
> Hunk #5 succeeded at 162 with fuzz 2.
> patching file kernel/marker.c
> Hunk #14 FAILED at 534.
> Hunk #15 FAILED at 587.
> Hunk #16 FAILED at 621.
> Hunk #17 FAILED at 732.
> Hunk #18 FAILED at 769.
> Hunk #19 succeeded at 791 (offset 12 lines).
> 5 out of 19 hunks FAILED -- saving rejects to file kernel/marker.c.rej
> patching file kernel/module.c
> Hunk #1 succeeded at 1998 (offset -3 lines).
> Hunk #2 succeeded at 2608 (offset -37 lines).
> Hunk #3 succeeded at 2651 with fuzz 1 (offset -3 lines).
> patching file include/linux/module.h
> Hunk #1 FAILED at 468.
> Hunk #2 succeeded at 572 (offset -2 lines).
> 1 out of 2 hunks FAILED -- saving rejects to file 
> include/linux/module.h.rej
> patching file samples/markers/probe-example.c
>
> Mike
>

Ok, I released a new patchset, which should fix your problem :

http://ltt.polymtl.ca/lttng/patch-2.6.24-rc2-lttng-0.10-pre20.tar.bz2

You simply have to apply all patches up to

markers-support-multiple-probes.patch

I have moved the patch earlier in the patchset so you don't have to
apply lttng. I also fixed the coding style and bugs I encountered during
my testing. You may also want to try out
markers-multi-probes-test.patch, which is a test module that I used to
make sure the probes were correct upon multiple connect/disconnect. It
is useful when you activate the "marker_debug" integer in
kernel/marker.c.

For those interested in lttng, this version should be used with :
http://ltt.polymtl.ca/lttng/ltt-control-0.46-06112007.tar.gz
http://ltt.polymtl.ca/packages/lttv-0.10.0-pre2-07112007.tar.gz

Mathieu

>> Mathieu
>>> Mike
>>>
>>>> It still need to go through patchcheck.pl and some polishing, but it
>>>> seems to work fine for me with multiple probes (the sample marker,
>>>> sample probe and multiple instances of my lttng probes can
>>>> connect/disconnect without problem).
>>>> Currently, the "connect/disconnect" and "arm/disarm" operations are
>>>> separate. However, they could be merged. Any comment/preference on this?
>>>> Being separate, a probe provider can wait until the very last moment
>>>> before it activates its markers, with a minimalistic impact on the
>>>> system, but it is not such a strong argument.
>>>> Mathieu
>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
