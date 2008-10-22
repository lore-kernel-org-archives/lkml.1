Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbYJVEXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbYJVEXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYJVEWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:22:52 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:42168 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750749AbYJVEWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:22:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JaXmMo8lv/fMuYYMNJhmCN2gls6uoAtw5MCKSqZ7/P5EaPyUIQ50Cca5YJXbXXQ1M9l2p3O6D55QmTf+ZjnxoIwvQRsc3r/0/zeN5zktAQWc9obdlSTWJFK97+p9Kc8FsA8a7SsVyGUr6sEmBBsamOv7SEiopu8t1fZFWrRrakY=  ;
X-YMail-OSG: uhbrWwUVM1kAY5VsG0s6ghTDeOrmHpYBLz51nkGPMDW.3fCVF0w9quQW_eQvbzUSi4nuRk9wGTVdSJrD4YxW_NEzVs._Kt.bB8Sz5E5La6beKTtujb3pUSuwj1refMJVsBmrkJpeahrr044lP1o17PkNtK0ooP5k3H0JGwI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: benh@kernel.crashing.org, avorontsov@ru.mvista.com
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Date: Tue, 21 Oct 2008 21:22:48 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081022014243.GA19362@oksana.dev.rtsoft.ru> <1224642497.7654.319.camel@pasglop>
In-Reply-To: <1224642497.7654.319.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810212122.49121.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2008, Benjamin Herrenschmidt wrote:
> The notifier can be registered before the devices, though it's a little
> bit fishy and fragile.
> 
> Easier I suppose to just have OF specific hooks in the bus code.

Like what I suggested:  "chip-aware OF glue drivers".  The relevant
bus code being the "of_platform_bus_type" infrastructure.

Example:  instead of Anton's patch #6 modifying the existing pca953x
driver, an of_pca953x driver that knows how to poke around in the OF
device attributes to (a) create the pca953x_platform_data, (b) call
i2c_register_board_info() to make that available later, and then
finally (c) vanish, since it's not needed any longer.

Better that than either the $SUBJECT patch, or modifying gpiolib to
grow OF-specific hooks ... hooks that can at best solve *one* of the
problems:  which GPIO numbers to use with this chip.  The platform
data does solve other problems(*) like:  (i) how to initialize the
polarity inversion register, (ii) arranging to set up other devices
only after their GPIOs are ready, (iii) initializing things that
device drivers won't always know about, or which may need to be
set up before such drivers are available.

- Dave

(*) A trivial example of (ii) would be LEDs driven by those GPIOs.

    A less trivial example:  see arch/arm/mach-davinci/board-evm.c
    in current GIT.  There are three pcf8574 I2C expanders used for
    various things ... LEDs, audio PLL, device power supplies, reset
    lines for external devices, more.
