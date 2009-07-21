Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZGUTEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZGUTEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbZGUTEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:04:20 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:65152 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbZGUTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:04:17 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 15:04:17 EDT
Date: Tue, 21 Jul 2009 19:55:09 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "A, Raghu" <raghu.a@ti.com>
Cc: "pierre@ossman.eu" <pierre@ossman.eu>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Dasgupta, Romit" <romit@ti.com>
Subject: Re: Restoring back the system state from MMC after a successful
	hibernation
Message-ID: <20090721185509.GA31923@console-pimps.org>
References: <2A3DCF3DA181AD40BDE86A3150B27B6B02F1B9BF4C@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2A3DCF3DA181AD40BDE86A3150B27B6B02F1B9BF4C@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 07:35:55PM +0530, A, Raghu wrote:
> Hi, 
> 
> I am trying a hibernate-restore procedure on my system, wherein I store the context image on a swap partition on a MMC device (/dev/mmcblk0). The hibernation process happens smoothly. However, when I try to restore back, after including "resume = /dev/mmcblk0" in the bootargs, I find that the MMC card does not get detected by the time late_initcall(software_resume) is called, as a result of which the restore does not happen.
> 
> To resolve the problem, I have included a mmc_flush_scheduled_work() call immediately after the mmc_detect_change(host, 0) call in mmc_start_host(struct mmc_host *host) function defined in linux/drivers/mmc/core/core.c, so that instead of mmc_rescan happening sometime later, it now happens right away, and the MMC card gets detected at the end of the host's .probe() callback itself.
> 
> /*****
> 
> void mmc_start_host(struct mmc_host *host)
> 
> {
>         mmc_power_off(host);
>         mmc_detect_change(host, 0);
>         mmc_flush_scheduled_work();
> }
> 
> The host's probe() routine calls mmc_add_host , which in turn calls mmc_start_host.
> 
> *****/
> 
> Is this approach correct? Or is there any other way I can get the MMC card detected before late_initcall(software_resume) happens?
> 

I think this is a good idea. Based on the comment for mmc_add_host(), by
the time we've exited mmc_add_host() the host should be ready to start
servicing requests, so mmc_start_host() really needs to have the
detected the card by the time it returns.

Perhaps it would be a good idea for mmc_detect_change() to grow another
argument that allows the detection to be synchronous?

