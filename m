Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXI3DCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXI3DCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXI3DCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:02:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44542 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbXI3DCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:02:37 -0400
Date: Sun, 30 Sep 2007 05:02:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Extending kbuild syntax
Message-ID: <20070930030258.GA10852@stusta.de>
References: <20070929201145.GA20377@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070929201145.GA20377@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 10:11:45PM +0200, Sam Ravnborg wrote:
>...
> The second is the more controversial suggestion.
> In several Makefile we have simple if expression of the variants:
> if ($(CONFIG_FOO),y)
>   obj-$(CONFIG_BAR) += fubar.o
> endif
> 
> The pattern varies over this theme.
> The suggestion here is to introduce a few helpers:
> 
> obj-y-if-$(CONFIG_FOO) += fubar.o
> This one shall read:
> if $(CONFIG_FOO) is y or m then set += to obj-y

IMHO for people who are not kbuild junkies the pattern is more clear 
with the current syntax.

But you should better ask some guinea pigs who have not already seen as 
many kernel Makefiles as I have...

> In several cases we will need it to be more complicated like the this:
> obj-y-ify-$(CONFIG_FOO) += fubar.o
> This one shall read:
> if $(CONFIG_FOO) is y (thats the ify thing) then += to obj-y
> 
> And we can mix it like the following:
> obj-$(CONFIG_BAR)-ify-$(CONFIG_FOO) += fubar.o
> This one shall read:
> if $(CONFIG_FOO) equal y then += to obj-$(CONFIG_BAR)
> 
> 
> The full list of new variables are (for obj-y):
> obj-y-if-y
> obj-y-if-m
>
> obj-y-ify-y
> obj-y-ifm-m
> 
> obj-y-ifn-
> 
> And similar for obj-m:
> obj-m-if-y
> obj-m-if-m
> 
> obj-m-ify-y
> obj-m-ifm-m
> 
> obj-m-ifn-
> 
> The 'y' and 'm' can be replaced by $(CONFIG_FOO) but the one right
> to the if are not supposed to be replaced.
> 
> 
> To better express how to use it I have tried to update a few Makefiles
> to use the new syntax. See below.
> 
> On MAJOR drawback is the linking order.
> I have no way to keep the link order if the new syntax are sued. The
> .o files will either be put before .o files specified with obj-y or obj-m or
> after the same.
> 
> For some places this does not matter but for other places (fs/Makefile)
> I will expect it to matter a lot.
> 
> Comments?
> Is this just to magic for bare humans to grasp.
> Or mabe the linking order is so important that we do not want it?
>...

Some of the cases have the following pattern:

config X86_POWERNOW_K8_ACPI
        bool
        depends on X86_POWERNOW_K8 && ACPI_PROCESSOR
        depends on !(X86_POWERNOW_K8 = y && ACPI_PROCESSOR = m)
        default y

Your suggested syntax has to be enhanced with three additional
variables for handling such cases.


The complicated cases can be handled either in kconfig or in kbuild,
and I think kconfig is the better place for them:

Handling it in kconfig has the advantage that we also get a variable we 
can use in C code.

For all the *-if-m and *-m-if{,n}-* cases this is a huge advantage over 
having to express the whole dependency in each #if.

Compare
  #if defined(CONFIG_ACPI_PROCESSOR) || (defined(CONFIG_ACPI_PROCESSOR_MODULE && defined(MODULE))
with
  #ifdef CONFIG_X86_POWERNOW_K8_ACPI

> 	Sam
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

