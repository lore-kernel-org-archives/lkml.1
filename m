Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXEREIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXEREIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 00:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbXEREIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 00:08:09 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:64867 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbXEREII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 00:08:08 -0400
Message-ID: <464D2697.5040902@comcast.net>
Date: Fri, 18 May 2007 00:07:51 -0400
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
CC: Dave Jones <davej@redhat.com>, Duane Griffin <duaneg@dghda.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States
 driver
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <20070516204807.GA23751@redhat.com> <20070518030436.GB20793@ifa.hawaii.edu>
In-Reply-To: <20070518030436.GB20793@ifa.hawaii.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua Hoblitt wrote:
> I think it's pretty clear that Dave and Daniel were both correct and
> that ACPI_PROCESSOR is the correct dependency for multi-socket systems.
> However, it's worth noting that this dependency seems to be unrelated to
> SMP support.  Ed Sweetman has reported that his single-socket but
> multi-core system doesn't require ACPI_PROCESSOR for powernow support.
> I just tried booting 2.6.21 w/o SMP support and w/o ACPI_PROCESSOR on
> one of my multi-socket/multi-core systems.  Sure enough, powernow 
> won't work without ACPI_PROCESSOR:
>
>   

I said before and originally, in response to the original post by you, 
that i didn't need acpi p-states driver, which is what this thread was 
suggesting.  We later determined that the thread title was misleading, 
this thread should be titled   "Kconfig powernow-k8 driver should depend 
on ACPI_PROCESSOR driver"

I've always compiled acpi_processor in the kernel, i use acpi, i have a 
processor, it seemed to fit.
> powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 2220 processors (version 2.00.00)
> powernow-k8: BIOS error - no PSB or ACPI _PSS objects
>
> I suppose this means that the BIOS does something different to enable
> SMP on a multi-core single socket and multi-socket systems.  Anyways, I
> believe the question that needs to be answered is: is it reasonable for
> X86_POWERNOW_K8 to select ACPI_PROCESSOR if SMP is set?  I'm not sure we
> can do anything more intelligent unless Kconfig had more knowledge of
> how the hardware other than just SMP/!SMP.
>
> -J
>
>   

My patch does the most intelligent thing thus far, it lets the user 
decide.  If the user is smart enough to enable cpufreq's powernow-k8 
driver, then the user is smart enough to decide if he wants/needs to use 
the acpi support of that driver.    I'm just exposing the driver that is 
causing all of this confusion to the user, since this is the driver that 
gets enabled/disabled behind the scenes depending on acpi_processor 
being selected.  Now it's not automatically handled, the user can enable 
acpi support or disable it (in the powernow driver), even if 
acpi_processor is compiled in.

you should be able to use the acpi support of Powernow-k8 even in UP 
situations, so only enabling it for SMP is wrong.  Enabling it whenever 
you have acpi compiled in and acpi_processor compiled in is wrong, 
because the user may be using a UP system and not want to lookup the 
acpi tables for powernow for some ungodly reason.   Just allowing the 
user to handle it works best.  See my previous post for the patch. 

> --
> On Wed, May 16, 2007 at 04:48:07PM -0400, Dave Jones wrote:
>   
>> On Wed, May 16, 2007 at 08:53:13PM +0100, Duane Griffin wrote:
>>  > On 16/05/07, Prakash Punnoor <prakash@punnoor.de> wrote:
>>  > > Maybe you want to give a hint in the p states driver help text?
>>  > 
>>  > I think a hint is the right thing to do, but in the PowerNow! driver
>>  > rather than the p states one. How about adding something like this to
>>  > the X86_POWERNOW_K8 (and X86_POWERNOW_K7?) help text:
>>
>> The mobile K7s which had powernow support weren't SMP capable, so they're
>> irrelevant.
>>
>>  > "ACPI support is required for non-UP systems and requires ACPI_PROCESSOR
>>  >  to be selected. If ACPI_PROCESSOR is compiled as a module then this
>>  >  option must be too in order for ACPI support to be available."
>>
>> X86_POWERNOW_K8_ACPI is already 'default y'. I think the problem lies in
>> that people aren't enabling its dependancy, ACPI_PROCESSOR.
>>
>> We want something along the lines of..
>>
>> config X86_POWERNOW_K8_ACPI
>> 	bool
>> 	if SMP & X86_POWERNOW_K8_ACPI
>> 	  select ACPI_PROCESSOR
>>
>> kconfig language quirks aside..
>>
>>
>> 	Dave
>>
>> -- 
>> http://www.codemonkey.org.uk
>>     

