Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbXISSqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbXISSqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbXISSqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:46:06 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3002 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbXISSqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:46:05 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: CFS: some bad numbers with Java/database threading [FIXED]
Date: Wed, 19 Sep 2007 11:45:48 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEIPGOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <46F058EE.1080408@redhat.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 19 Sep 2007 11:45:56 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 19 Sep 2007 11:45:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The CFS scheduler does not seem to implement sched_yield correctly. If one
> program loops with a sched_yield and another program prints out timing
> information in a loop. You will see that if both are taskset to
> the same core
> that the timing stats will be twice as long as when they are on
> different cores.
> This problem was not in 2.6.21-1.3194 but showed up in
> 2.6.22.4-65 and continues
> in the newest released kernel 2.6.22.5-76.

I disagree with the bug report.

> You will see that both tasks use 50% of the CPU.
> Then kill task2 and run:
> "taskset -c 1 ./task2"

This seems right. They're both always ready to run. They're at the same
priority. Neither ever blocks. There is no reason one should get more CPU
than the other.

> Now task2 will run twice as fast verifying that it is not some
> anomaly with the
> way top calculates CPU usage with sched_yield.
>
> Actual results:
> Tasks with sched_yield do not yield like they are suppose to.

Umm, how does he get that? It's yielding at blinding speed.

> Expected results:
> The sched_yield task's CPU usage should go to near 0% when
> another task is on
> the same CPU.

Nonsense. The task is always ready-to-run. There is no reason its CPU should
be low. This bug report is based on a misunderstanding of what yielding
means.

The Linux page says:

       "A  process can relinquish the processor voluntarily without blocking
by
       calling sched_yield().  The process will then be moved to  the  end
of
       the queue for its static priority and a new process gets to run."

Notice the "without blocking" part?

POSIX says:

"The sched_yield() function forces the running thread to relinquish the
processor until it again becomes the head of its thread list. It takes no
arguments."

CFS is perfectly complying with both of these. This bug report is a great
example of how sched_yield can be misunderstood and misused.

You can even argue that the sched_yield process should get even more CPU,
since it's voluntarily relinquishing (which should be rewarded) rather than
infinitely spinning (which should be punished). (Not that I agree with this
argument, I'm just using it to counter-balance the other argument.)

DS


