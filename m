Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXKEXRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXKEXRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbXKEXRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:17:40 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:64368 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779AbXKEXRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:17:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAwzL0dMROHU/2dsb2JhbACBWw
Date: Mon, 5 Nov 2007 18:17:35 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Mike Mason <mmlnx@us.ibm.com>
Cc: ltt-dev@shafik.org, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [to-be-posted-soon] Multiple handlers per marker
Message-ID: <20071105231735.GA620@Krystal>
References: <472A345C.2010208@us.ibm.com> <20071101221530.GC19700@Krystal> <20071102033654.GA1301@Krystal> <20071104232442.GA32320@Krystal> <472F9D63.7010906@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <472F9D63.7010906@us.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:15:46 up 2 days,  4:21,  8 users,  load average: 0.67, 0.50,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Mason (mmlnx@us.ibm.com) wrote:
> Mathieu Desnoyers wrote:
>> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
>>> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
>>>> * Mike Mason (mmlnx@us.ibm.com) wrote:
>>>>> Hi Mathieu,
>>>>>
>>>>> Are you aware of any working being done to allow multiple handlers to 
>>>>> be attached to a marker?  Something like what kprobes allows.  I've 
>>>>> started to look into this and don't want to duplicate efforts.
>>>>>
>>>> Nope, but I know we will have to address this.
>>>>
>>>> Something along the lines of walking an RCU list of function pointers,
>>>> calling them.
>>>>
>>>> The only downside I see is that we will have to pass a va_list * instead
>>>> of real va args. The could make the marker site a little bit bigger and
>>>> will change the probe callback arguments.
>>>>
>>>> What do you think about these ideas ?
>>>>
>>>> If we can find a way to make the common case (only one probe connected)
>>>> _ultra_ fast, and yet architecture independent, that would be awesome. A
>>>> simple call is kind of hard to beat though.. So we may have to think
>>>> about a design with :
>>>>
>>>> - One call at the marker site
>>>> - if 1 probe is installed :
>>>>   - If the format string is empty, connect a probe without va args.
>>>>   - If the format string is not empty, connect a "stage 1" probe that 
>>>> takes
>>>>     the va args, starts/ends the va_list and calls _one_ function (let's
>>>>     call it "stage 2" probe), that takes va_list as parameter.
>>>> - if more than 1 probe is installed :
>>>>   - The stage 1 probe creates the va_list and passes it to each function
>>>>     connected, iterated with an RCU list.
>>>>
>>>> What do you think ?
>>>>
>>>> Mathieu
>>>>
>>> I'm working on an implementation.
>>>
>> It's ready for testing. Please grab
>> http://ltt.polymtl.ca/lttng/patch-2.6.24-rc1-git13-lttng-0.10-pre18.tar.bz2
>> patch name :
>> markers-support-multiple-probes.patch
>
> This patch alone doesn't apply cleanly at all on 2.6.24-rc1-git14.  Are 
> there other patches in this series I should apply first?
>

Yes, the following ones should suffice :

# instrumentation menu removal
add-kconfig-to-arch.patch
add-arch-supports-oprofile.patch
add-arch-supports-kprobes.patch
move-kconfig-instrumentation-to-arch.patch
#
kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
declare-array.patch
text-edit-lock-architecture-independent-code.patch
text-edit-lock-alternative-i386-and-x86_64.patch
text-edit-lock-kprobes-architecture-independent.patch
text-edit-lock-kprobes-i386.patch
text-edit-lock-kprobes-x86_64.patch
text-edit-lock-i386-standardize-debug-rodata.patch
text-edit-lock-x86_64-standardize-debug-rodata.patch
#
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-embedded.patch
immediate-values-move-kprobes-i386-restore-interrupt-to-kdebug-h.patch
add-asm-compat-to-x86.patch
immediate-values-i386-optimization.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch
#
linux-kernel-markers-immediate-values.patch
#
markers-support-multiple-probes.patch

Tell me if you still have rejects.

Mathieu


> Mike
>
>> It still need to go through patchcheck.pl and some polishing, but it
>> seems to work fine for me with multiple probes (the sample marker,
>> sample probe and multiple instances of my lttng probes can
>> connect/disconnect without problem).
>> Currently, the "connect/disconnect" and "arm/disarm" operations are
>> separate. However, they could be merged. Any comment/preference on this?
>> Being separate, a probe provider can wait until the very last moment
>> before it activates its markers, with a minimalistic impact on the
>> system, but it is not such a strong argument.
>> Mathieu
>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
