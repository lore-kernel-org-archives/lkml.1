Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZBJFE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZBJFE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZBJFEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:04:07 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:35390
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZBJFEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:04:05 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Feb 2009 00:04:05 EST
Date: Tue, 10 Feb 2009 13:58:04 +0900
From: Mattia Dongili <malattia@linux.it>
To: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI regression in 2.6.29 - cpufreq_performance doesn't work
Message-ID: <20090210045803.GA31755@kamineko.org>
References: <cc0fa41f0902091953y2ab718fcmdbd1c42acf270e08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc0fa41f0902091953y2ab718fcmdbd1c42acf270e08@mail.gmail.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.26-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 01:53:13AM -0200, Guilherme Malschitzky Schroeder wrote:
> Hi,
> 
> If i set performance for scaling_governor using 2.6.29-rc4-git2,
> ondemand stills control my CPU.
> I get just 800MHz instead of 2268MHz.
> 
> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
> 800000
> dub:/sys/devices/system/cpu/cpu0/cpufreq# echo performance > scaling_governor
> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_governor
> performance
> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
> 2267000
> 
> But, /proc/cpuinfo still shows 800MHz:
> 
> model name      : Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
> stepping        : 6
> cpu MHz         : 800.000
> 
> And i cannot remove the ondemand module, that is not used anymore:
> 
> dub:/sys/devices/system/cpu/cpu0/cpufreq# rmmod cpufreq_ondemand
> ERROR: Module cpufreq_ondemand is in use

yes, I guess it is used by cpu1, you should repeat the above commands
for /sys/devices/system/cpu/cpu1/cpufreq too.

...
> I've git bisect from 2.6.28.4 (which was working) to 2.6.29-rc4-git2
> and i get into this:
> 
> alemao@dub:~/linux-2.6$ git bisect good
> d96f94c604453f87fe24154b87e1e9a3a72511f8 is first bad commit
> commit d96f94c604453f87fe24154b87e1e9a3a72511f8
> Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> Date:   Mon Feb 2 11:57:18 2009 -0800
> 
>     ACPI: Enable bit 11 in _PDC to advertise hw coord
> 
>     Bit 11 in intel PDC definitions is meant for OS capability to handle
>     hardware coordination of P-states. In Linux we have always supported
>     hwardware coordination of P-states. Just let the BIOSes know that we
>     support it, by setting this bit.
> 
>     Some BIOSes use this bit to choose between hardware or software coordination
>     and without this change below, BIOSes switch to software coordination, which
>     is not very optimal in terms of power consumption and extra
> wakeups from idle.
> 
>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>

the "coordination of P-states" is required when you have an SMP system
that cannot scale cpu voltage independently on each cpu, so the best
voltage/frequency have to be selected mediating between all the applied
policies.
The commit you found above just makes use hw coordination instead of sw
and the message explains why.

If you make sure you change *all* of the cpu policies you won't see the
behaviour you describe.

hth
-- 
mattia
:wq
