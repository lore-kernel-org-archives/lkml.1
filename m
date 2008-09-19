Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYISJMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYISJMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 05:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYISJMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 05:12:46 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:38077 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYISJMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 05:12:45 -0400
Message-ID: <48D36D02.4090003@cateee.net>
Date: Fri, 19 Sep 2008 11:12:34 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
References: <s5hbpyny7bl.wl%tiwai@suse.de> <20080918122541.2c3c7b39@areia.chehab.org> <48D27734.3040600@cateee.net> <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>
In-Reply-To: <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of replying all other emails, it is simpler to explain my
approach.

The purpose of my program is to find all CONFIG_s, which are needed to 
support all the hardware (and some more), and to show them in 
menuconfig. This is the main difference with Takashi purpose:
he wants to build a bootable (without initramfs) kernel, starting
to an high modular kernel (usually found in distribution),
so no usable on an already optimized machine.

Anyway there are a lot of overlapping tasks, which we could
exchange.

My design (files and sample output are in 
http://cateee.net/sources/autokernconf/autokernconf-2008-08-29/ ):

kdetect.sh: detects hardwares, in a redundant manner, in order
to have data if there are missing one ore more between: /proc,
/sys, lspci, ...

autokernconf.sh: a shell script which read the driver database
(lkddb.list) and kdetect output; it generates the desired CONFIG_s.

So far, so simple, and similar to Takashi method. I only split
the task in two programs (detection and configuration).

The big difference is in the additional program, which generated the
driver database: it reads all sources, it checks 25 subsystems
(see http://cateee.net/lkddb/statistics.html ), taking in account
to preprocessors (#ifdef CONFIG_...), #defines, static strings, masks, 
all architectures, etc.
Additionally it parse Makefile and Kconfig to find the dependencies
of every source file.

It misses some generic detection (CPU, memory), which Takashi is
doing, and the kconfig integration.

So I think most part could be integrated with the Takashi proposal, and 
doing optionally the parsing of full driver database.

ciao
	cate



Mauro Carvalho Chehab wrote:
> On Thu, 18 Sep 2008, Giacomo A. Catenazzi wrote:
> 
>> The tools should have extensive knowledge about Kconfig,
>> and the CONFIG_ dependencies
> 
> Since CONFIG_ and their dependencies are constantly 
> changing/adding/removing at kernel, the better would be to have a good 
> Kconfig parsing, avoiding to have lots of "local knowledge" about 
> symbols. The better model seems to be the one where subsystem 
> maintainers don't need to take extra care for not breaking the tool when 
> touching at Kconfig/Makefiles.
> 
> Also, it occured me that some drivers have "implicit" Kconfig 
> dependencies inside that may limit its work. Looking on a random driver, 
> just as an example, you have things like:
> 
> $ grep ifdef cpufreq_stats.c
> cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
> 
> So, I suspect that the script might also need to parse the selected 
> files to seek for additional rules.
> 
> I'm not sure what to do after discovering such things: Assume the option 
> that generates smaller code? Assume the option that generates the most 
> complete code? Maybe the better would be to use the selected config 
> profile as a hint for such symbols. If not found there, then ask user.
> 
>> it should handle a lot of
>> structures (text/binary; line/record oriented; etc.), which
>> it is not easy in shell (awk, od, sed with extended regexp are
>> not core utilities).
> 
> True.
> 
>> So my suggestion is: do it in a high level language, to find and
>> stabilize the design, and then integrate it in kconfig later (using
>> C).
> 
> Seems a good approach to me.
> 

