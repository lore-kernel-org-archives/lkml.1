Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYFZN4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYFZN4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYFZN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:56:12 -0400
Received: from wr-out-0708.google.com ([64.233.184.249]:7152 "EHLO
	wr-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYFZN4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:56:11 -0400
MIME-Version: 1.0
Date: Thu, 26 Jun 2008 06:56:08 -0700 (PDT)
In-Reply-To: <aIZIi-6Dp-39@gated-at.bofh.it>
X-IP: 144.32.126.15
References: <aIZIi-6Dp-39@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (compatible; Konqueror/3.5; Linux) KHTML/3.5.9 
	(like Gecko) (Kubuntu),gzip(gfe),gzip(gfe)
X-HTTP-Via: 1.1 wc2.york.ac.uk:3128 (squid)
Message-ID: <882a4b16-d70a-41b0-87a3-d0c9f597fa7a@56g2000hsm.googlegroups.com>
Subject: Re: Can I use yield in this way
From: Alan Jenkins <aj504@cs.york.ac.uk>
To: =?GB2312?B?z8TBwQ==?= <xiaiaxaxi@sjtu.edu.cn>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

одаа wrote:
> Hello,
>
>         I'd like to ask a question about the use of a kernel function,
> yield(); I am working on Intel Core Duo, running Linux 2.6.21 I want
> to let current process be off the cpu when the temperature of cpu is
> too high. I add a function called thermal_balance in the timer
> interrupt. My program is as following,
>
> scheduler_tick()
> {
>        static int count = 0;
>        count++;
>        if(count % 100 == 0)
>            thermal_balance();
> }
>
> static int thermal_balance(void)
> {
>        int cpu = smp_processor_id();
>        struct task_struct* task;
>        Get CPU temperature.
>
>        if (temperature is too high){
>                task = cpu_rq(cpu)->curr;
>                yield();
>                Move task to other cpu.
>        }
> }
>
>        Can yield() be used as above. After I compile the kernel and
> run again. Kernel is not working just as it meets deadlock. And if I
> comment yield(), it runs ok. Could anyone help me?Thanks!
>

That sounds like an odd solution.

Two other possible solutions come to mind.

1) Use a real-time thread at the highest priority pinned to each
processor to poll the temperature.  When the temperature is too high
on that cpu, the real-time thread should run idle.  I don't know if
that's realistically possible though; I'm sure you can't execute a HLT
instruction in a userspace thread and you would want to be able to
call the cpu-specific idle function which is already used during
normal idle.

2) hotplug CPUs when they become too hot.  Unfortunately a hotplugged
CPU will not idle in the most efficient way - it's a known problem
which can e.g prevent the use of CPU deep sleep states on other cores
in the same package.

What would be best is if you could use the existing power management
infrastructure.  ACPI already has thermal management, so it might be
nicer if you could add "stop the cpu completely" as a method to the
existing ACPI thermal code (the current methods involve cooling
devices aka fans and ACPI CPU throttling states).

Your logic also sounds strange.  What is supposed to happen if the
temperature stays too high on all cpus?

Alan
