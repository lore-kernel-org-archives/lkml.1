Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYKGJLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYKGJLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYKGJLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:11:34 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:37099 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYKGJLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:11:32 -0500
Date: Fri, 7 Nov 2008 10:11:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Miller <davem@davemloft.net>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org
Subject: Re: I2C from interrupt context?
Message-ID: <20081107101118.286f3713@hyperion.delvare>
In-Reply-To: <20081106.154754.02648408.davem@davemloft.net>
References: <m3bpws8ln3.fsf@maximus.localdomain>
	<20081106.154754.02648408.davem@davemloft.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 15:47:54 -0800 (PST), David Miller wrote:
> From: Krzysztof Halasa <khc@pm.waw.pl>
> Date: Fri, 07 Nov 2008 00:44:48 +0100
> 
> [ Fixed i2c list address, it's now hosted at vger ]
> 
> > I'm updating my EEPROM console logger and have encountered a problem
> > - the logger (as any console) can be called with hardware interrupts
> > disabled and/or from interrupt context. It needs to write to I^2C
> > (using ARM (Xscale) GPIO) and possibly SMBUS-only EEPROM chip. Is it
> > at all supposed to be possible?
> 
> Not really.  The I2C operations need to be able to sleep and that's
> not allowed in interrupt context.

That's not totally correct. Since kernel 2.6.25, i2c_transfer()
supports being called in contexts where it cannot sleep. Of course, for
it to work, the underlying i2c adapter driver must also not sleep. As I
recall, only the i2c-pxa driver was explicitly modified to support this
at the moment (see member use_pio of struct pxa_i2c) but other drivers
could be modified in a similar way (and some i2c adapter drivers may be
naturally non-sleeping - everything based on i2c-algo-bit is likely to
fall into this category.)

The situation is far from perfect though. For one thing, I seem to
recall that Andrew Morton didn't like the approach taken in
i2c_transfer(). For another, i2c_smbus_xfer() was not yet modified so
at this point only I2C-level transactions can be non-sleeping,
SMBus-level transactions can't. But all this could be fixed by anyone
who cares about these specific issues.

-- 
Jean Delvare
