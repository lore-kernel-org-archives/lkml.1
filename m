Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYDGMeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYDGMeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbYDGMd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:33:56 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:56078 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYDGMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:33:56 -0400
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Fix call to set_cyc2ns_scale() from time_cpufreq_notifier()
From: Andi Kleen <andi@firstfloor.org>
References: <200804071214.45791.fzu@wemgehoertderstaat.de>
Date: Mon, 07 Apr 2008 14:33:51 +0200
In-Reply-To: <200804071214.45791.fzu@wemgehoertderstaat.de> (Karsten Wiese's message of "Mon, 7 Apr 2008 12:14:45 +0200")
Message-ID: <87r6dhrgi8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Apr 2008 12:27:08.0581 (UTC) FILETIME=[B2731D50:01C898AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Wiese <fzu@wemgehoertderstaat.de> writes:

> In time_cpufreq_notifier() the cpu id to act upon is held in freq->cpu. Use it
> instead of smp_processor_id() in the call to set_cyc2ns_scale().
> This makes the preempt_*able() unnecessary and lets set_cyc2ns_scale() update
> the intended cpu's cyc2ns.

It is still wrong because set_cyc2ns_scale() needs to execute on the target CPU
because it does rdtsc on that CPU. If you're on another CPU you'll
get the wrong values if the TSCs are not synchronized.

Still wrong as just disabling preemption around the call is not correct,
it would need to cover the complete notifier event and also the cpufreq
code would need to guarantee it is always already running on the correct
CPU (not sure that is the case currently)

The whole thing needs to be either preempt disabled or the RDTSC update code
needs to be moved into a smp_call_function_simple()  [my old 
"redesigned sched_clock code" did that]

Using smp_call_function_simple() would be probably the right fix,
perhaps conditional on a check for unsync TSC.

-Andi
