Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZAVVez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZAVVez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZAVVeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:34:46 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:1752 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZAVVeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ROzjp3/jjLBESkdVJRVI5DyT3pXZV0Us0ZK2ed2oYXZ4LJaX10hPa1UrLVgGQSYXjJ
         zgscORL0kyYyYReu+YgmZE89xq9xEfLk+ZmXoSH7n2nOv075lT/4LX0h/efMx/nKjGt5
         IXhnMIIJloAzHPQ/PDXRoZE4g1whJbv/LGZVo=
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 22:34:45 +0100
Message-ID: <2cd4df870901221334n7e242e79ka961f899c03c70cb@mail.gmail.com>
Subject: CPU scheduler question/problem
From: Pawel Dziekonski <dzieko@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

all my compute intensive processes stick to one core,
whatever I put in /proc/sys/kernel/sched_min_granularity_ns - big number,
small number.

yes, I read /usr/src/linux/Documentation/scheduler/sched-design-CFS.txt
and yes, I did google about CFS tuning. no, I'm not a kernel developer. ;-)

also creation of cpu.shares does not help.

kernels tested:
2.6.27.7-9-default from openSUSE 11.1 distro
and vanilla 2.6.18.1.

this is a very simple test showing openssl performance:

dd if=/dev/zero bs=1M count=10000 | \
openssl enc -k qqqq -aes-128-cbc | \
pv > /dev/null

(you can skip pv if you like or not have it installed)

when I start top or pidstat I see that all of them run on the same core
and are competing for CPU time (pv 2%, dd 15%, openssl 83%).
to workaround this problem I use taskset to place processes on different cores:

taskset -c 0 dd if=/dev/zero bs=1M count=10000 | \
taskset -c 1 ./openssl enc -k qqqq -aes-128-cbc | \
taskset -c 2 pv > /dev/null

now the benchmark runs on 3 different cores and gives waaay better results
(115 MB/s compared to 185 MB/s).

another example: I start a computing application (quantum chemistry) that spawns
four processes that share workload. it happens very often that 2 processes share
same core for a moment and then jump to another core. taskset -p helps but it is
very inconvenient.

I am not using cpufreq.

question: is there a way to better balance processes over different
cores and do it
automagically? automating is necessary because I plan do build a compute cluster
with a batch system.

thanks in advance!

ps. my system is openSUSE 11.1 on Intel Core i7 CPU 940, HT enabled.
pps. I am not subscribed to LKML - please CC me - thanks!
