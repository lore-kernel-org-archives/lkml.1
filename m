Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZESG5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZESG5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZESG5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:57:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:55746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbZESG5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:57:12 -0400
Message-ID: <4A125841.5000608@kernel.org>
Date: Tue, 19 May 2009 15:57:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: david@lang.hm
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Intel X25E doesn't work with nv sata in current kernels
References: <alpine.DEB.1.10.0905181041310.15782@asgard>
In-Reply-To: <alpine.DEB.1.10.0905181041310.15782@asgard>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 06:57:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> according to but 12703 ( http://bugzilla.kernel.org/show_bug.cgi?id=12703 )
> this worked with older kernels, but with 2.6.29.[13] and 2.6.30-rc6
> 
> according to this ticket it did work with older vendor kernels, but it's
> not clear which ones (and no older vanilla kernels)
> 
> I have verified that this drive does work on a PCI controller card in
> the same machine (with the same cables), so this is definantly a
> controller/kernel issue
> 
> booting with libata.force=#:nohrst (with # being the SATA controller
> that the SSD is on) does allow it to be detected, but the patch listed
> in the ticket
> 
> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index 6cda12b..6673b1d 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -1565,7 +1565,7 @@ static int nv_noclassify_hardreset(struct ata_link
> *link, unsigned int *class,
>         bool online;
>         int rc;
> 
> -       rc = sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
> +       rc = sata_link_hardreset(link, sata_deb_timing_long, deadline,
>                                  &online, NULL);
>         return online ? -EAGAIN : rc;
>  }
> 
> does not work.
> 
> Tejun Heo was working on this back in April, but it looks like the
> troubleshooting petered out.
> 
> one issue that I did notice, in the dmesg I see
> 
> $ grep SATA dmesg
> ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 11
> ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 11
> ata1: SATA link down (SStatus 100 SControl 300)
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata3: SATA max UDMA/133 cmd 0xc880 ctl 0xc800 bmdma 0xc080 irq 5
> ata4: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xc088 irq 5
> ata3: SATA link down (SStatus 0 SControl 300)
> ata4: SATA link down (SStatus 0 SControl 300)
> ata5: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb480 irq 10
> ata6: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb488 irq 10
> ata5: SATA link down (SStatus 0 SControl 300)
> ata6: SATA link down (SStatus 0 SControl 300)
> 
> note the ata1 line. it detects something different than the links where
> there really is nothing plugged in, but it doesn't come up
> 
> booting with nohrst results in SStatus 123

Great, a new tester.  :-)

Let's track it on the bz.

Thanks.

-- 
tejun
