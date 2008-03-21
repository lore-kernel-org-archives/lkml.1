Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbYCUVgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbYCUVgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbYCUVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:36:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669AbYCUVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:36:32 -0400
Date: Fri, 21 Mar 2008 14:35:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 3/3] EDAC Add e752x parameter for sysbus_parity
 selection
Message-Id: <20080321143524.318d002a.akpm@linux-foundation.org>
In-Reply-To: <47e17ddf.xF+lLzMkHllCZjZq%dougthompson@xmission.com>
References: <47e17ddf.xF+lLzMkHllCZjZq%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 14:55:59 -0600
dougthompson@xmission.com wrote:

> +/* Setup system bus parity mask register.
> + * Sysbus parity supported on:
> + *   e7320/e7520/e7525 + Xeon
> + *   i3100 + Xeon/Celeron
> + * Sysbus parity not supported on:
> + *   i3100 + Pentium M/Celeron M/Core Duo/Core2 Duo
> + */
> +static void e752x_init_sysbus_parity_mask(struct e752x_pvt *pvt)
> +{
> +	char *cpu_id = cpu_data(0).x86_model_id;
> +	struct pci_dev *dev = pvt->dev_d0f1;
> +	int enable = 1;
> +
> +	/* Allow module paramter override, else see if CPU supports parity */
> +	if (sysbus_parity != -1) {
> +		enable = sysbus_parity;
> +	} else if (cpu_id[0] &&
> +		   ((strstr(cpu_id, "Pentium") && strstr(cpu_id, " M ")) ||
> +		    (strstr(cpu_id, "Celeron") && strstr(cpu_id, " M ")) ||
> +		    (strstr(cpu_id, "Core") && strstr(cpu_id, "Duo")))) {
> +		e752x_printk(KERN_INFO, "System Bus Parity not "
> +			     "supported by CPU, disabling\n");
> +		enable = 0;
> +	}
> +
> +	if (enable)
> +		pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x0000);
> +	else
> +		pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x0309);
> +}

Is that the best way of working out whether the CPU supports system bus
parity?  We do have cpu capability infrastructure in x86 core and I'd have
though it would be better for x86 core to work this out, set the suitable
flag and have clients (ie: EDAC) test that flag?

