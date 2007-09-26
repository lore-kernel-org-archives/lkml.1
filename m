Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbXIZMBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbXIZMBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 08:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXIZMBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 08:01:03 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1709 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXIZMBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 08:01:01 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Network slowdown due to CFS
Date: Wed, 26 Sep 2007 05:00:31 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEPKHAAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070926112919.GN3337@deprecation.cyrius.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 26 Sep 2007 05:00:51 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 26 Sep 2007 05:00:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > I think the real fix would be for iperf to use blocking network IO
> > though, or maybe to use a POSIX mutex or POSIX semaphores.
>
> So it's definitely not a bug in the kernel, only in iperf?

Martin:

Actually, in this case I think iperf is doing the right thing (though not
the best thing) and the kernel is doing the wrong thing. It's calling
'sched_yield' to ensure that every other thread gets a chance to run before
the current thread runs again. CFS is not doing that, allowing the yielding
thread to hog the CPU to the exclusion of the other threads. (It can allow
the yielding thread to hog the CPU, of course, just not to the exclusion of
other threads.)

It's still better to use some kind of rational synchronization primitive
(like mutex/sempahore) so that the other threads can tell you when there's
something for you to do. It's still better to use blocking network IO, so
the kernel will let you know exactly when to try I/O and your dynamic
priority can rise.

Ingo:

Can you clarify what CFS' current default sched_yield implementation is and
what setting sched_compat_yield to 1 does? Which way do we get the right
semantics (all threads of equal static priority are scheduled, with some
possible SMP fuzziness, before this thread is scheduled again)?

DS


