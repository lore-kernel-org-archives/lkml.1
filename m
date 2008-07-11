Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYGKXUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYGKXUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYGKXT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:19:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61026 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYGKXT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:19:56 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5337"; a="4481945"
Message-ID: <4877EA9A.1070700@qualcomm.com>
Date: Fri, 11 Jul 2008 16:19:54 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <19f34abd0807111207q2ad2011csdb46c6f451fe0f6d@mail.gmail.com>	 <6599ad830807111236t2bc9aa02ned59dcc58f14b1bf@mail.gmail.com>	 <19f34abd0807111243s549b0facvbd0a650358463231@mail.gmail.com> <b647ffbd0807111603m45b65f73q90399891fb8795f1@mail.gmail.com>
In-Reply-To: <b647ffbd0807111603m45b65f73q90399891fb8795f1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> Does the patch below help?
> 
> (non-white-space-damaged version is attached)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 9fceb97..ae61dc9 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1912,11 +1912,21 @@ static void common_cpu_mem_hotplug_unplug(void)
>  static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
>                                 unsigned long phase, void *unused_cpu)
>  {
> -       if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
> +       swicth (phase) {
> +       case CPU_UP_CANCELED:
> +       case CPU_UP_CANCELED_FROZEN:
> +       case CPU_DOWN_FAILED:
> +       case CPU_DOWN_FAILED_FROZEN:
> +       case CPU_ONLINE:
> +       case CPU_ONLINE_FROZEN:
> +       case CPU_DEAD:
> +       case CPU_DEAD_FROZEN:
> +               common_cpu_mem_hotplug_unplug();
> +               break;
> +       default:
>                 return NOTIFY_DONE;

I was always wondering why we're running that logic for every hotplug 
event.
For example, do we care for UP_CANCELED* and DOWN_FAILED* ? Presumably 
nothing should've changed, no ?
btw I'm just going by the name of the event. So UP_CANCELED to me sounds 
like CPU never got to the ONLINE stage and cpuset should not really care.

Max


