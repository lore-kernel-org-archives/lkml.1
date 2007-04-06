Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXDFR1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXDFR1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933606AbXDFR1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:27:35 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:52554 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602AbXDFR1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:27:34 -0400
Date: Fri, 6 Apr 2007 12:27:14 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu, dipankar@in.ibm.com,
       dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 3/8] Use process freezer for cpu-hotplug
Message-ID: <20070406172714.GA6131@localdomain>
References: <20070402053457.GA9076@in.ibm.com> <20070402053824.GC12962@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053824.GC12962@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> This patch implements process_freezer based cpu-hotplug
> core. 
> The sailent features are:
> o No more (un)lock_cpu_hotplug.
> o No more CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE. Hence no per-subsystem
>   hotcpu mutexes.
> o Calls freeze_process/thaw_processes at the beginning/end of
>   the hotplug operation.

...

> @@ -133,7 +111,11 @@ static int _cpu_down(unsigned int cpu)
>  	if (!cpu_online(cpu))
>  		return -EINVAL;
>  
> -	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
> +	if (freeze_processes(FE_HOTPLUG_CPU)) {
> +		thaw_processes(FE_HOTPLUG_CPU);
> +		return -EBUSY;
> +	}
> +

If I'm understanding correctly, this will cause

# echo 0 > /sys/devices/system/cpu/cpuX/online

to sometimes fail, and userspace is expected to try again?  This will
break existing applications.

Perhaps drivers/base/cpu.c:store_online should retry as long as
cpu_up/down return -EBUSY.  That would avoid a userspace-visible
interface change.
