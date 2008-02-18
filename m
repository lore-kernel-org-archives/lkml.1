Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbYBRMQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbYBRMQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbYBRMQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:16:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45561 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758272AbYBRMQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:16:12 -0500
Date: Mon, 18 Feb 2008 04:13:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Message-Id: <20080218041340.f1e46ec9.akpm@linux-foundation.org>
In-Reply-To: <20080218111536.511c4fbc@crazy>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216211603.bb4f3582.randy.dunlap@oracle.com>
	<20080216214410.b9699910.akpm@linux-foundation.org>
	<20080218111536.511c4fbc@crazy>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 11:15:36 +0100 Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> Hi,
> 
> Le Sat, 16 Feb 2008 21:44:10 -0800,
> Andrew Morton <akpm@linux-foundation.org> a __crit :
> 
> > Bustage in x86-configurable-dmi-scanning-code.patch.  Previously,
> > DMI=y was just hardwired.  Now, it becomes selectable and stuff
> > breaks.
> > 
> > I guess the DMI=n version of dmi_check_system() could become a macro
> > so we don't emit a reference to its argument, but that might generate
> > unused-variable warnings elsewhere.
> 
> Thanks for your report. The issue is that some DMI fixup tables and
> callbacks are defined inside #ifdef CONFIG_DMI, some others are not. We
> need to normalize that to fix the build issue in all situations.
> 
> I've thought about it, and I see two options, but I can't decide which
> one is the best, so I request your opinion on that.
> 
>  1) Remove the #ifdef CONFIG_DMI around DMI fixup tables and callbacks
>     definition, so that everything exists and gcc is happy. gcc is able
>     to optimize out the DMI fixup table (it is not present in the binary
>     when compiling with DMI=n), but gcc doesn't seem to be able to
>     optimize out the DMI fixup callbacks (they are still present in the
>     binary). So this would leave some unused code in the binary, which
>     is not completely satisfying.
> 
>  2) Define macros such as DECLARE_DMI_FIXUP_TABLE and
>     DECLARE_DMI_FIXUP_CALLBACK, which could then be used like this:
> 
> DECLARE_DMI_FIXUP_CALLBACK(set_bios_reboot, __init, d, {
> 	if (reboot_type != BOOT_BIOS) {
> 		reboot_type = BOOT_BIOS;
> 		printk(KERN_INFO "%s series board detected. Selecting BIOS-method for reboots.\n", d->ident);
> 	}
> 	return 0;
> });
> 
> DECLARE_DMI_FIXUP_TABLE(reboot_dmi_table, __initdata, {
> 	{	/* Handle problems with rebooting on Dell E520's */
> 		.callback = set_bios_reboot,
> 		.ident = "Dell E520",
> 		.matches = {
> 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DM061"),
> 		},
> 	}
> });
> 
>      And use them everywhere, so that DMI fixup tables and callbacks
>      are properly compiled out when DMI=n. Here are the macro definition:
> 
> #ifdef CONFIG_DMI
> 
> #define DECLARE_DMI_FIXUP_TABLE(name, opts, contents...) \
> 	static struct dmi_system_id opts name [] = contents
> 
> #define DECLARE_DMI_FIXUP_CALLBACK(name, opts, id, contents...) \
> 	static int opts name(const struct dmi_system_id *id) contents
> 
> #else
> 
> #define DECLARE_DMI_FIXUP_TABLE(name, opts, contents...)
> 
> #define DECLARE_DMI_FIXUP_CALLBACK(name, opts, contents...)
> 
> #endif
> 
>      The issue I have with this option is that there are sometimes
>      "driver_data" associated to DMI callbacks (see
>      drivers/input/misc/wistron_btns.c for example) and I don't exactly
>       see how to create a similar DECLARE_DMI_FIXUP_CALLBACK_DATA macro.
> 

Option 3 wold be to add more #ifdef CONFIG_DMI lines around the place.  How
ugly would that get?

