Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYGXAbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYGXAbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYGXAbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:31:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:3234 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYGXAbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P0gDKxMACvgBNq+zpvQbbXqKUa/AnzjhFzRtoWUb1UU5XEYGlWRS4ZmXCXz+yBL3hE
         ngLifIJG1vkYo5Sc0o2GeYfoGbbfV+KfbLBCVFUCfr8oG5Ctxnfrd32PfwcqlnQrd9g0
         PxbFfk/2XnwGFDzJ0IGTbihPykzYmonSiIx9Q=
Message-ID: <5d6222a80807231731u41f9fb81w2796b3db1a5920e6@mail.gmail.com>
Date: Wed, 23 Jul 2008 21:31:14 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Andrew Drake" <zappacky.lists@gmail.com>
Subject: Re: [Bisected] Regression: Hang on boot in schedule_timeout_interruptible during ACPI init on SMP
Cc: linux-kernel@vger.kernel.org, gcosta@redhat.com
In-Reply-To: <4887B4D5.1050306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4887B4D5.1050306@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 7:46 PM, Andrew Drake <zappacky.lists@gmail.com> wrote:
> Here's a puzzler for you all,
>
> On my laptop (an ACPI-enabled SMP system), the system hangs during the
> "acpi_init" function. I traced it to the schedule_timeout_interruptible
> function, which is called if Sleep() is encountered in the DSDT code in one
> of
> the _STA or _INI functions. In this case, I have one in each, and it hangs
> twice.
>
> The value being passed to schedule_timeout_interruptible is sane (i.e. <=
> 25),
> but the function never returns. Triggering an interrupt (i.e. jiggling the
> power
> button) causes the boot to continue.
>
> Passing nosmp causes the problem to disappear (but at what an expense!),
>
> I noticed this in the latest kernel, and in some 2.6.25-ish kernels, decided
> to
> hunt it down. On Linus's tree, the latest good commit was:
>
> commit 1161705bd66df0c80fa45e87190e456c02e6f145
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Mar 19 20:26:15 2008 +0100
>
>   x86: fill cpu to apicid and present map in mpparse, fix
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>
> and the earliest bad commit was:
>
> commit 802b8133b4f78c30a2668d142d78861e27c0c6a7
> Author: Glauber de Oliveira Costa <gcosta@redhat.com>
> Date:   Wed Mar 19 14:25:41 2008 -0300
>
>   x86: schedule work only if keventd is already running
>     Only call schedule_work if keventd is already running.
>   This is already the way x86_64 does
>     Signed-off-by: Glauber Costa <gcosta@redhat.com>
>   Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> There's about 14 commits in-between these two; I was unable to bisect any
> further because all 14 of the in-between commits either oops, panic, or
> hang setting up the timer (it appears that the commit immediately following
> the known-good one introduces the timer failure, which lasts up until the
> known-bad one).
>
> The change "x86: schedule work only if keventd is already running" modifies
> smp_boot, which puts it, in my mind, as the most likely culprit.

on the other hand, the commit right after the good one modifies the
mptable, and may have messed the apic ids for you box. Could you please
attach a dmesg with apic debug messages turned on? Whatever commit you
can boot is fine, provided you tell me which one you used.

>
> Anybody have any ideas? I'm willing to write a patch if somebody can help me
> track down the root cause.

Any other information about your box may be helpful. cat /proc/cpuinfo
and the dmesg I told you about are good starts. If that's too much
information for a mail, opening a BZ ticket is fine for me too.

>
> Thanks,
>
> Andrew
>
> P.S. I'm willing to provide any information that you'd like to see, like
> my .config or my DSDT (disassembled or otherwise). I didn't include it
> in this email because I wasn't sure what would be helpful.
Yeah, sure. .config helps too.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
