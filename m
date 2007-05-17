Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbXEQK3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbXEQK3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbXEQK3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:29:36 -0400
Received: from sccrmhc15.comcast.net ([204.127.200.85]:44537 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbXEQK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:29:35 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 06:29:35 EDT
Message-ID: <464C2D56.6030402@comcast.net>
Date: Thu, 17 May 2007 06:24:22 -0400
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Daniel Drake <dsd@gentoo.org>, davej@redhat.com, duaneg@dghda.com,
       prakash@punnoor.de, jhoblitt@ifa.hawaii.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
References: <20070516235050.9B4237B409F@zog.reactivated.net> <20070517090227.GB3975@ucw.cz>
In-Reply-To: <20070517090227.GB3975@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>   
>> powernow-k8 uses PSB BIOS tables to read frequency info on UP systems, but
>> on SMP it requires the acpi-processor driver. Kconfig should be updated
>> accordingly to avoid the issues that users are running into.
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=8075
>> https://bugs.gentoo.org/show_bug.cgi?id=178585
>>
>> Signed-off-by: Daniel Drake <dsd@gentoo.org>
>>
>> Index: linux/arch/i386/kernel/cpu/cpufreq/Kconfig
>> ===================================================================
>> --- linux.orig/arch/i386/kernel/cpu/cpufreq/Kconfig
>> +++ linux/arch/i386/kernel/cpu/cpufreq/Kconfig
>> @@ -81,6 +81,7 @@ config X86_POWERNOW_K7_ACPI
>>  config X86_POWERNOW_K8
>>  	tristate "AMD Opteron/Athlon64 PowerNow!"
>>  	select CPU_FREQ_TABLE
>> +	select ACPI_PROCESSOR if SMP
>>  	depends on EXPERIMENTAL
>>  	help
>>  	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
>>     
>
> It is still possible to run SMP kernel on UP machine -- so this sounds
> wrong.
>
>   

It's possible to run a kernel with drivers for hardware you dont have.  
But not having the dependencies correct for those drivers for that 
hardware you dont have just because it's possible you can run a kernel 
with those drivers without that hardware isn't correct. Got it?

if an SMP K8 system needs ACPI_PROCESSOR for the cpufreq driver, then we 
need to make this dependency,  just because you can configure your 
kernel to include drivers you dont need (like smp on a up system) 
doesn't mean that dependency is wrong,  it just means you've configured 
your system with drivers you dont need.  Looking up the acpi table on a 
UP system probably wont break anything, since the driver should check if 
it's not able to and fallback to non-acpi methods before failing 
completley.  If it doesn't then this patch should be fine.  Otherwise 
we'd need to add a check in the driver to see if we're actually running 
in an smp configuration and use the correct method. 


The Kconfig dependency would still be valid in either case.  If the 
lookup for acpi tables fails with no fallback to the non-acpi way of 
using the cpufreq driver, then we have to fix the driver.


