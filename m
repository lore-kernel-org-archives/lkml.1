Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZGVMMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZGVMMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZGVMMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:12:13 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:47817 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZGVMMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:12:13 -0400
Message-ID: <4A6701E3.3000204@csr.com>
Date: Wed, 22 Jul 2009 13:11:15 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <pierre@ossman.eu>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2009 12:11:15.0292 (UTC) FILETIME=[82CF01C0:01CA0AC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> This patch modified the MMC core code to optionally call the
> set_ios() operation on the driver with the clock frequency set
> to 0 (gate) after a grace period of at least 8 MCLK cycles, then
> restore it (ungate) before any new request. This gives
> the driver the option to shut down the hardware block clock and
> thus (in known designs) the MCI clock to the MMC/SD card when
> the clock frequency is 0, i.e. the core has stated that the MCI
> clock does not need to be generated.

I'm not sure this is the right approach.

1. With some controllers (e.g., PXA270 I think) turning the clock on and
off is slow.  This means if you're doing back-to-back commands you
should leave the clock on for best performance.  I think there needs to
be a higher level active/idle knob for the user of the card (be it the
block driver or an SDIO function driver) to control whether to idle the
bus clock or controller.

2. Some controllers cannot detect SDIO interrupts if the clock is
stopped.  There should either be a distinction between clock off and
clock idle.

3. Regardless of point 1 above.  Using a workqueue item in this way
seems overkill.  Consider using a timer and simply calling mod_timer()
at the start of every command.  When the timer expires, idle the clock.
 You will probably need a "command in progress" bit to ensure you don't
idle the clock if the timer expires in the middle of a command.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
