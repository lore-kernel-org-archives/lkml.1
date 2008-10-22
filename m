Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYJVW3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYJVW3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYJVW3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:29:43 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:33576 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751380AbYJVW3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:29:42 -0400
Date: Thu, 23 Oct 2008 02:29:40 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081022222940.GA14636@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810221404.52798.david-b@pacbell.net> <20081022212217.GA32378@oksana.dev.rtsoft.ru> <200810221452.46786.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810221452.46786.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 02:52:46PM -0700, David Brownell wrote:
> On Wednesday 22 October 2008, Anton Vorontsov wrote:
> > > 
> > > > So if we register the board infos after 
> > > > the controller registered, then nobody will probe the board infos.
> > > 
> > > See above.  If you're doing it right, there's no problem.
> > > That is, scan the OF tables early.  Just like PNP tables
> > > get scanned early, for example.
> > 
> > Heh. If we don't want to be able to make the OF-parsing code
> > be a module then there is no problem at all. I can use the bus
> > notifiers. And it is most straightforward solution then.
> > 
> > But I quite dislike to bloat the kernel image with
> > maybe-never-used-on-this-board code.
> 
> So have it live in the __init text section.  If you're
> building a kernel with support for several boards, you
> know it's necessarily going to be larger than it would
> be if only one board were supported.  But you can shrink
> kernel size by judicious use of __init sections..

Won't work, unfortunately. I2C devices are created by the
i2c controllers, via drivers/of_i2c.c  of_register_i2c_devices().

There is a good reason to do so, the code needs to know
controller's OF node to walk down and register the child nodes
(devices). See drivers/i2c/busses/i2c-mpc.c -- it calls
of_register_i2c_devices() at the end of the probe().

Since we can't call __init stuff from non-__init, the scheme
you purpose won't work.

The same is for SPI (drivers/of_spi.c of_register_spi_devices()).

> > My aim was to make the 
> > OF-parsing part be a module too. Because in the long run we
> > need the OF-parsing stuff for _every_ driver that needs
> > platform data. It's quite expensive to have it always built-in,
> > don't you think?
> 
> If it's discarded early, after translating the data from
> OF format into what the drivers need, there will be no
> RAM footprint.

There is also kernel image size that matters...

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
