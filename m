Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbYI3IkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbYI3IkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYI3IkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:40:09 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37069 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYI3IkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:40:08 -0400
Date: Tue, 30 Sep 2008 10:38:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org, kkeil@suse.de,
       agospoda@redhat.com, arjan@linux.intel.com, david.graham@intel.com,
       bruce.w.allan@intel.com, jkosina@suse.cz, john.ronciak@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com
Subject: Re: [RFC PATCH 08/12] e1000e: allow bad checksum
In-Reply-To: <20080930031957.22950.5669.stgit@jbrandeb-bw.jf.intel.com>
Message-ID: <Pine.LNX.4.64.0809301030020.2307@twin.jikos.cz>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
 <20080930031957.22950.5669.stgit@jbrandeb-bw.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Jesse Brandeburg wrote:

>  	for (i = 0;; i++) {
> -		if (e1000_validate_nvm_checksum(&adapter->hw) >= 0)
> +		if (e1000_validate_nvm_checksum(hw) >= 0) {
> +			/* copy the MAC address out of the NVM */
> +			if (e1000e_read_mac_addr(&adapter->hw))
> +				e_err("NVM Read Error reading MAC address\n");
>  			break;
> +		}
>  		if (i == 2) {
>  			e_err("The NVM Checksum Is Not Valid\n");
> -			err = -EIO;
> -			goto err_eeprom;
> +			e1000e_dump_eeprom(adapter);
> +			/*
> +			 * set MAC address to all zeroes to invalidate and
> +			 * temporary disable this device for the user. This
> +			 * blocks regular traffic while still permitting
> +			 * ethtool ioctls from reaching the hardware as well as
> +			 * allowing the user to run the interface after
> +			 * manually setting a hw addr using
> +			 * `ip link set address`
> +			 */
> +			memset(hw->mac.addr, 0, netdev->addr_len);
> +			break;
>  		}
>  	}

BTW wouldn't something like

	if (e1000_validate_nvm_checksum(hw) >= 0 ||
	    e1000_validate_nvm_checksum(hw) >= 0) {
		/* copy the MAC address out of the NVM */
		if (e1000e_read_mac_addr(&adapter->hw))
		e_err("NVM Read Error reading MAC address\n");
	} else {
		e_err("The NVM Checksum Is Not Valid\n");
		e1000e_dump_eeprom(adapter);
		/*
		 * set MAC address to all zeroes to invalidate and
		 * temporary disable this device for the user. This
		 * blocks regular traffic while still permitting
		 * ethtool ioctls from reaching the hardware as well as
		 * allowing the user to run the interface after
		 * manually setting a hw addr using
		 * `ip link set address`
		 */
		memset(hw->mac.addr, 0, netdev->addr_len);
	}

just be much more readable? Having for(;;) loop which always performs 
three iterations, and having "if" inside that distinguishes two iterations 
from each other just looks peculiar to my eyes :)

Thanks,

-- 
Jiri Kosina
SUSE Labs

