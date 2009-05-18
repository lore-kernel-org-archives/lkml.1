Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZEROo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZEROo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZEROot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:44:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30446 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZEROos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:44:48 -0400
Date: Mon, 18 May 2009 16:44:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org,
       sameo@linux.intel.com, linux-i2c@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: Add U300 AB3100 core support v1
Message-ID: <20090518164440.2124a4fa@hyperion.delvare>
In-Reply-To: <63386a3d0905180722u282f0dd3ua62b119a1a6a97e8@mail.gmail.com>
References: <63386a3d0905140129s5fd0f32cxde1114489678f012@mail.gmail.com>
	<4A0BF776.9030301@compulab.co.il>
	<63386a3d0905180722u282f0dd3ua62b119a1a6a97e8@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, 18 May 2009 16:22:36 +0200, Linus Walleij wrote:
> Here we have a problem. See above:
> msgs[0].addr = ab3100_i2c_client->addr + 1;
> 
> So this chip actually has two addresses. A "special" address
> to deal with test registers, one address up. The I2C framework
> assume all devices have one and one address only (which is
> of course mostly true).

No, the I2C framework doesn't assume this. All the I2C framework
assumes is that only one device can use a given address on any one I2C
segment (which seems reasonable.)

> Here is a special case. When the first device has registered,
> you know that the other address is available as well.
> 
> You could think of several ugly solutions:
> 
> * Keep using i2c_transfer() directly as we do now.
> 
> * Make a raw copy of the i2c_device with something like
>   memcpy(mock_client, i2c_client, sizeof(i2c_client);
>   mock_client->addr++;
>   then use i2c_master_send()
> 
> * Register a new i2c_device in board_info for the other
>   address while strictly speaking it is the same device, and
>   this will yield a lot of probing and synchronization code,
>   because writing the test registers is used when probing the
>   first device, so we have to wait for that device to be probed
>   before we can probe the other one etc.
> 
> Right now I lean toward the first alternative.

Neither is correct. Simply use i2c_new_dummy() on the second I2C
address, and keep a pointer to the instantiated i2c_client for future
use. Don't forget to call i2c_unregister_device() in your .remove()
method.

-- 
Jean Delvare
