Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYGWWq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYGWWq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYGWWqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:46:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:45707 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYGWWqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=d/0SVy6XuLZxHRWYCSlO40SJ3iXumBpieDa5IH559SYKZuSQY51iREM7UZPUqwmBVS
         xU/tu41sWPBHttJAaSArzAqzTjxu8wEAwDFOiMiZP/Z5iNHDnBAfr0r5Tk44ZdN+YA1X
         DUuuW+viBs+uCuRQFMhdTqrKE0ADwEqrtIFzM=
Message-ID: <4887B4D5.1050306@gmail.com>
Date: Wed, 23 Jul 2008 18:46:45 -0400
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: gcosta@redhat.com
Subject: [Bisected] Regression: Hang on boot in schedule_timeout_interruptible
 during ACPI init on SMP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Andrew Drake <zappacky.lists@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a puzzler for you all,

On my laptop (an ACPI-enabled SMP system), the system hangs during the
"acpi_init" function. I traced it to the schedule_timeout_interruptible
function, which is called if Sleep() is encountered in the DSDT code in 
one of
the _STA or _INI functions. In this case, I have one in each, and it hangs
twice.

The value being passed to schedule_timeout_interruptible is sane (i.e. 
<= 25),
but the function never returns. Triggering an interrupt (i.e. jiggling 
the power
button) causes the boot to continue.

Passing nosmp causes the problem to disappear (but at what an expense!),

I noticed this in the latest kernel, and in some 2.6.25-ish kernels, 
decided to
hunt it down. On Linus's tree, the latest good commit was:

commit 1161705bd66df0c80fa45e87190e456c02e6f145
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Mar 19 20:26:15 2008 +0100

    x86: fill cpu to apicid and present map in mpparse, fix
   
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


and the earliest bad commit was:

commit 802b8133b4f78c30a2668d142d78861e27c0c6a7
Author: Glauber de Oliveira Costa <gcosta@redhat.com>
Date:   Wed Mar 19 14:25:41 2008 -0300

    x86: schedule work only if keventd is already running
   
    Only call schedule_work if keventd is already running.
    This is already the way x86_64 does
   
    Signed-off-by: Glauber Costa <gcosta@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

There's about 14 commits in-between these two; I was unable to bisect any
further because all 14 of the in-between commits either oops, panic, or
hang setting up the timer (it appears that the commit immediately following
the known-good one introduces the timer failure, which lasts up until the
known-bad one).

The change "x86: schedule work only if keventd is already running" modifies
smp_boot, which puts it, in my mind, as the most likely culprit.

Anybody have any ideas? I'm willing to write a patch if somebody can help me
track down the root cause.

Thanks,

Andrew

P.S. I'm willing to provide any information that you'd like to see, like
my .config or my DSDT (disassembled or otherwise). I didn't include it
in this email because I wasn't sure what would be helpful.
