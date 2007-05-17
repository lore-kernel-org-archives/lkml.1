Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXEQVk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXEQVk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXEQVkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:40:51 -0400
Received: from rwcrmhc15.comcast.net ([216.148.227.155]:49460 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXEQVku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:40:50 -0400
Message-ID: <464CCBCF.3010001@comcast.net>
Date: Thu, 17 May 2007 17:40:31 -0400
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Len Brown <lenb@kernel.org>, Daniel Drake <dsd@gentoo.org>,
       duaneg@dghda.com, prakash@punnoor.de, jhoblitt@ifa.hawaii.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
References: <20070516235050.9B4237B409F@zog.reactivated.net> <200705171413.42595.lenb@kernel.org> <20070517182340.GA25691@redhat.com> <464CC920.6030409@comcast.net>
In-Reply-To: <464CC920.6030409@comcast.net>
Content-Type: multipart/mixed;
 boundary="------------090905010105050400080107"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090905010105050400080107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ed Sweetman wrote:
> Dave Jones wrote:
>> On Thu, May 17, 2007 at 02:13:42PM -0400, Len Brown wrote:
>>
>>  > > Index: linux/arch/i386/kernel/cpu/cpufreq/Kconfig
>>  > > ===================================================================
>>  > > --- linux.orig/arch/i386/kernel/cpu/cpufreq/Kconfig
>>  > > +++ linux/arch/i386/kernel/cpu/cpufreq/Kconfig
>>  > > @@ -81,6 +81,7 @@ config X86_POWERNOW_K7_ACPI
>>  > >  config X86_POWERNOW_K8
>>  > >      tristate "AMD Opteron/Athlon64 PowerNow!"
>>  > >      select CPU_FREQ_TABLE
>>  > > +    select ACPI_PROCESSOR if SMP
>>  > >      depends on EXPERIMENTAL
>>  > >      help
>>  > >        This adds the CPUFreq driver for mobile AMD 
>> Opteron/Athlon64 processors.
>>  >  > Unfortunately this patch will not actually enable 
>> ACPI_PROCESSOR in
>>  > the SMP=y ACPI=n case.  "select" doesn't work for targets that
>>  > have dependencies.
>>
>> I don't think we can fix this perfectly tbh, but the above at
>> least gets us close for the majority of users.
>>
>> Are there many x86-64 users that don't enable acpi ?
>>
>>     Dave
>>
>>   
> I've just always compiled acpi_processor in, it's only logical that if 
> you are using a power management feature, that you compile in the 
> power management interface, and if your stuff deals directly with the 
> cpu, you may want to compile the acpi_processor driver in.  The only 
> reason I knew to do that though, was because i go through each 
> option.  Someone else looking to just enable cpufreq, would skip the 
> sub-drivers of ACPI, and never know better. We dont suggest anywhere 
> in the cpufreq driver, we dont mention restrictions or limits of the 
> driver without acpi, and we certainly dont select it or make it 
> dependent (except silently and invisibly to the user).
> Every other cpufreq driver demands acpi.  In windows you have to have 
> acpi, the p states are called acpi p states everywhere.  The problem 
> here is that the author to the powernow_k8 driver found a way to get 
> some cpufreq functionality without acpi.
> So to make everyone happy, maybe we should have the silently 
> selected/deselected driver exposed to the user, as a sub-driver.
> ->  Powernow K8 / athlon64  cpufreq driver     y/m/n
> ------->    ACPI support      y/m/n
>

Here's a patch


--------------090905010105050400080107
Content-Type: text/x-patch;
 name="powernow.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="powernow.patch"

--- ./linux-backup/arch/x86_64/kernel/cpufreq/Kconfig	2007-02-04 13:44:54.000000000 -0500
+++ ./linux-2.6.21-rc5-mm2/arch/x86_64/kernel/cpufreq/Kconfig	2007-05-17 17:37:24.000000000 -0400
@@ -10,7 +10,7 @@
 
 comment "CPUFreq processor drivers"
 
-config X86_POWERNOW_K8
+config  X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
 	help
@@ -21,10 +21,10 @@
 	  If in doubt, say N.
 
 config X86_POWERNOW_K8_ACPI
-	bool
+	tristate "ACPI support"
 	depends on X86_POWERNOW_K8 && ACPI_PROCESSOR
 	depends on !(X86_POWERNOW_K8 = y && ACPI_PROCESSOR = m)
-	default y
+
 
 config X86_SPEEDSTEP_CENTRINO
 	tristate "Intel Enhanced SpeedStep (deprecated)"

--------------090905010105050400080107--
