Return-Path: <linux-kernel-owner+w=401wt.eu-S933426AbYA2TAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbYA2TAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYA2TAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:00:21 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34909 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYA2TAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:00:19 -0500
Date: Tue, 29 Jan 2008 21:00:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sections mismatches: How to mark new false positives?
Message-ID: <20080129190046.GR8767@does.not.exist>
References: <20080129170255.GP8767@does.not.exist> <20080129181305.GB14056@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080129181305.GB14056@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 07:13:06PM +0100, Sam Ravnborg wrote:
> On Tue, Jan 29, 2008 at 07:02:55PM +0200, Adrian Bunk wrote:
> > I'm getting the following in the latest -git:
> > 
> > <--  snip  -->
> > 
> > ...
> > WARNING: arch/x86/kernel/built-in.o(.exit.text+0x1db): Section mismatch in reference from the function msr_exit() to the variable .cpuinit.data:msr_class_cpu_notifier
> > ...
> > 
> > <--  snip  -->
> > 
> > That's obviously a false positive (unregister_hotcpu_notifier() is a 
> > noop if CONFIG_HOTPLUG_CPU=n), but how can I silence the warning?
> 
> What is the purpose of __cpuinit?
> It seems to be used for two purposes:
> 
> To annotate code that is used to initialize cpu's
>   if CONFIG_HOTPLUG_CPU=n then discard it after
>                                init has completed
>   if CONFIG_HOTPLUG_CPU=y then keep it
> 
> To annotate all 'core' cpu hotplug related code
>   if CONFIG_HOTPLUG_CPU=n then it is not used and
>                                can safely be discarded
>   if CONFIG_HOTPLUG_CPU=y then keep it
> 
> And the variable msr_class_cpu_notifier belongs to the last category.
> So the root cause of all the __cpu* related section mismatch
> warnings are the misuse of __cpuinit to mark all core functions.
> 
> How are we going to fix this?
> 
> I see a couple of possibilities:
> 
> 1) annotate like hell to hide the misuse of __cpuinit
> 2) introduce __cpu to make cpu hotplug 'core' stuff
> 3) drop section mismatch checks for __cpu stuff

My main point is not related to __cpu*

E.g. look at the following warnings:

WARNING: drivers/pci/built-in.o(.text+0xa385): Section mismatch in 
reference from the function cpci_configure_slot() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x13052): Section mismatch in 
reference from the function cpqhp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x1561c): Section mismatch in 
reference from the function ibm_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x26176): Section mismatch in 
reference from the function shpchp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()

The code seems to be 100% correct, but how can I silence the warnings 
without needlessly bloating the kernel in the CONFIG_HOTPLUG=n case?

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

