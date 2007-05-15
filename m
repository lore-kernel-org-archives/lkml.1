Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbXEOOZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbXEOOZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 10:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbXEOOZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 10:25:07 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:56131 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbXEOOZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 10:25:04 -0400
Message-ID: <4649C2D1.7020704@de.ibm.com>
Date: Tue, 15 May 2007 16:25:21 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - CONFIG_STATISTIC and Intel PowerTOP...
References: <20070509012322.199f292b.akpm@linux-foundation.org> <8277.1179199530@turing-police.cc.vt.edu>
In-Reply-To: <8277.1179199530@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> 
> So I'm trying to get the Intel PowerTop stuff working, and discovered that /
> proc/timer_stats and/or /proc/tstats has moved to /debug in -mm2 - but only if
> you're building for S390.  For other architechtures it just evaporates
> entirely.  I had to bash this patch in to get it to get included in an x86_64
> build:

My mistake. I should have submitted patches that make CONFIG_STATISTICS a 
Kconfig option for all archs.

Meanwhile, the patch that implements timerstats using lib/statistic.c
has been dropped from -mm, because there is already a tool, called powertop, 
that looks for timerstats in procfs. This fixes your issue.

I am wondering whether I should submit Kconfig patches as a precautionary 
measure anyway.

> 
> --- linux-2.6.21-mm2/arch/x86_64/Kconfig.statistics     2007-05-14 23:01:00.000000000 -0400
> +++ linux-2.6.21-mm2/arch/x86_64/Kconfig        2007-05-14 23:00:45.000000000 -0400
> @@ -793,6 +793,8 @@
> 
>  source "kernel/Kconfig.marker"
> 
> +source "lib/Kconfig.statistic"
> +
>  endmenu
> 
>  source "arch/x86_64/Kconfig.debug"
> 
> Am just replicating the choice to put it in arch/s390/Kconfig - not sure why
> it was in there rather than lib/Kconfig.debug - is there a reason here?

CONFIG_STATISTICS really is instrumentation support. Its users might provide 
statistics of general interest just as well as for debugging purposes, though.

> 
> Having bashed *that* into place, I hit this at kernel link time:
> 
> WARNING: lib/built-in.o - Section mismatch: reference to .init.text:statistic_hotcpu from .data between 'statistic_hotcpu_notifier' (at offset 0x640) and 'io_tlb_lock'
> 

I am not confident, but my guess is:

I should mark statistic_hotcpu_notifier as __cpuinitdata because it references 
statistic_hotcpu(), which is marked __cpuinit. This makes a similar warning just 
seen during a test compile on i386 go away.


Martin

