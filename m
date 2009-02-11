Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZBKBcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZBKBcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZBKBbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:31:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:59278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZBKBbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:31:52 -0500
Message-ID: <49922A7A.7090609@kernel.org>
Date: Wed, 11 Feb 2009 10:31:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Resume from hibernation fails with pata_it821x RAID volume
References: <200902022242.01170.linux@rainbow-software.org>
In-Reply-To: <200902022242.01170.linux@rainbow-software.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 01:31:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> Hello,
> hibernation didn't work for me since I started to use IT8212 controller. Now I 
> did some debugging (booting with no_console_suspend init=/bin/sh).
> 
> Found that resume fails (2.6.28) with "serial number mismatch 'some 
> garbage' != 'some other garbage'" and "revalidation failed" messages. That's 
> because the controller firmware fills different serial number in the IDENTIFY 
> every boot.
> 
> The patch below fixes the resume simply clearing the serial number. The proper 
> fix would be probably to fill in the serial number of the RAID volume 
> instead. I assume that there must be something like that stored on the drives 
> but I don't know where.
> 
> 
> Fix resume on pata_it821x RAID volume by clearing the serial number in 
> IDENTIFY data, which is otherwise different on each boot.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.28-orig/drivers/ata/pata_it821x.c	2009-01-02 17:18:36.000000000 +0100
> +++ linux/drivers/ata/pata_it821x.c	2009-02-02 17:47:57.000000000 +0100
> @@ -561,6 +561,9 @@
>  		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
>  		id[86] |= 0x0400;	/* LBA48 on */
>  		id[ATA_ID_MAJOR_VER] |= 0x1F;
> +		/* Clear the serial number because it's different each boot
> +		   which breaks validation on resume */
> +		memset(&id[ATA_ID_SERNO], 0x20, ATA_ID_SERNO_LEN);
>  	}
>  	return err_mask;
>  }

Looks good to me.  Alan, Jeff?

-- 
tejun
