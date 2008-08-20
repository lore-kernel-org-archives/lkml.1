Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYHTSiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYHTSiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYHTShu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:37:50 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21558 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYHTShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:37:48 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/3] Introduce interface to report BIOS bugs
Date: Wed, 20 Aug 2008 12:37:42 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, len.brown@intel.com,
       arjan@linux.intel.com, linux-acpi@vger.kernel.org,
       Christian Kornacker <ckornacker@suse.de>
References: <1219251726-24746-1-git-send-email-trenn@suse.de> <1219251726-24746-2-git-send-email-trenn@suse.de>
In-Reply-To: <1219251726-24746-2-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201237.43338.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2008 11:02:04 am Thomas Renninger wrote:
> From: Christian Kornacker <ckornacker@suse.de>
> 
> This is mostly needed for ACPI systems.
> ACPI introduces an endless amount of possible BIOS
> bugs like wrong values, missing functions, etc.
> The kernel has to sanity check all of them and should
> report BIOS bugs as such to the user.

I can't quite decide whether the whole idea is over-engineering
or not.  I guess my hesitation is mainly that things like this take
ongoing maintenance to keep them valuable, and that's often where
things fall apart.

> +#define 	FW_EMERG	KERN_EMERG  /* System cannot boot */
> +#define 	FW_ALERT 	KERN_ALERT  /* Risk of HW or data damage, 
> +					       e.g. overheating, dmraid */
> +#define 	FW_CRIT 	KERN_CRIT   /* A major device is not functional
> +					       e.g. hpet, lapic, network... */
> +#define 	FW_ERR		KERN_ERR    /* A major device is not working
> +					       as expected, e.g. cpufreq stuck
> +					       to lowest freq, lowered
> +					       performance, increased power
> +					       consumption... */
> +#define		FW_WARN		KERN_WARNING /* A minor device does not work
> +						or is not fully functional,
> +						e.g. backlight brightness,
> +						Hotplug capabilities of a
> +						device that should be
> +						hot-plugable will not work */
> +#define		FW_INFO		KERN_INFO    /* Anything else related to BIOS
> +						that is worth mentioning */
> +
> +
> +#ifdef CONFIG_REPORT_FIRMWARE_BUGS
> +  #define FW_PRINT_WARN(severity, fmt, args...) printk("%s[BIOS]: " fmt "\n", \
> +						       severity, ##args)
> +#else
> +  #define FW_PRINT_WARN(severity, fmt, args...) do { } while (0)
> +#endif
> +
> +#define FW_PRINT_CRIT(severity, fmt, args...) printk("%s[BIOS]: " fmt "\n", \
> +						     severity, ##args)

I think there are too many possibilities (FW_PRINT_WARN vs FW_PRINT_CRIT,
then one of FW_INFO, FW_WARN, FW_ERR, FW_CRIT, FW_ALERT, FW_EMERG).
A simpler interface with only one or two choices would give 90% of the
benefit.

My preference would be to *not* add a newline inside the interface.
Everybody knows printk needs a newline, and it's simpler if all the
printk variants follow that same rule.

The "BIOS" string is very x86-centric.  I'd prefer something like
"firmware" or "FW" that's also applicable to non-x86 systems.

I'm on a real dev_printk() kick at the moment, so I'd like to see
a way to hook a message to *something*, whether it's a specific
device, an ACPI method, a table at a specific physical address, etc.
For example, this:

+                       FW_PRINT_CRIT(FW_ERR, PFX "No ACPI _PSS objects for CPU"
+                                     " other than CPU0. Complain to your BIOS"
+                                     " vendor");

would be nicer if it could report the specific CPU device.
Admittedly, many of the places you touch don't currently have
an idea of a "device."  But sometimes that's a deficiency in
the current Linux implementation, so I think your interface
should at least allow a device.

Maybe even something as simple as:

    #define FW_BUG	"[FW bug]: "

would be sufficient, with the idea that people could do this:

    dev_err(&dev->dev, FW_BUG "interrupts left enabled\n");

I think the user-space value derives from having a consistent string
to grep for, so this gives you that.  I'm not sure what value we get
from adding the new FW_PRINT_CRIT()/FW_PRINT_WARN() interfaces in the
kernel.

Bjorn
