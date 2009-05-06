Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbZEFNDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbZEFNDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZEFNDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:03:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:42587 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbZEFNDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:03:08 -0400
Message-ID: <4A018A69.5030800@windriver.com>
Date: Wed, 06 May 2009 08:02:33 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb,early_printk: unregister early usb before	rest_init()
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <1241575205-12199-2-git-send-email-jason.wessel@windriver.com> <1241575205-12199-3-git-send-email-jason.wessel@windriver.com> <1241575205-12199-4-git-send-email-jason.wessel@windriver.com> <1241575205-12199-5-git-send-email-jason.wessel@windriver.com> <20090506073456.GC17457@elte.hu>
In-Reply-To: <20090506073456.GC17457@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2009 13:02:24.0419 (UTC) FILETIME=[E657DF30:01C9CE4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jason Wessel <jason.wessel@windriver.com> wrote:
>
>> The early_printk EHCI debug driver can hang the system or cause
>> unpredictable results because two separate APIs will attempt to write
>> to the mapped PCI region.
[clip]
>> +postcore_initcall(usb_early_debug_cleanup);
>
> We already have CON_BOOT which allows the unregistering of early
> consoles, via disable_boot_consoles() initcall in kernel/printk.c.
>
> The hang should be solved differently: either by calling
> disable_boot_consoles() explicitly after console_init() - or by
> introducing another CON_ flag that marks the console for early
> forced unregistering.

I thought about adding another flag in console_init() such that an
early console which cannot safely be used can elect to unregister.
There are two problems with this.

1) We actually need a call back to unset ehci_debug, or the
   console_unregister needs to set/clear a flag which then must be
   checked on each early_printk write, else any further call laying
   around for early_printk can crash the system.

2) Ideally you want to keep printk alive for as long as possible,
   which means you can have it all the way through start_kernel()
   before the "blackout period" while waiting for pci and usb init.

Given these two issues, is it your preference still to see a patch
that changes console_init or add another call back to start_kernel() ?

An earlier iteration of this patch added a call back in start_kernel
just before rest_init(), but it seemed like it was not needed since we
can hook on to part of the relevent function init chain.

I am open to fixing this in what ever manner is acceptable.

Cheers,
Jason.
