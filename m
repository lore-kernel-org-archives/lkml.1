Return-Path: <linux-kernel-owner+w=401wt.eu-S932799AbZAIXmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbZAIXmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932338AbZAIXkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:40:51 -0500
Received: from www.tglx.de ([62.245.132.106]:58271 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbZAIXku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:40:50 -0500
Date: Sat, 10 Jan 2009 00:40:39 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Hugo Villeneuve <hugo@hugovil.com>
Cc: Thiago Galesi <thiagogalesi@gmail.com>,
       Florian Fainelli <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: FPGA programming driver architecture
Message-ID: <20090109234038.GB3044@local>
References: <20081212150314.6ea24996.hugo@hugovil.com> <200812131358.03010.florian@openwrt.org> <20090108151827.72f50cee.hugo@hugovil.com> <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com> <20090109100725.77a07e74.hugo@hugovil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109100725.77a07e74.hugo@hugovil.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 10:07:25AM -0500, Hugo Villeneuve wrote:
> 
> I think that for the moment, I will focus on implementing the core
> module and the parallel/SPI interfaces only. Later we may want to add
> more fonctionality (vendors, JTAG, etc).

That's a good plan, but you'll have to make sure different FPGA programming
drivers can be added easily to some fpga-core no matter which interface they
use.

> 
> But for now, my main problem is that I need to have some insight on how
> I actually implement the different modules:
> 
> Bus driver?
> class driver?
> platform driver?

Those are not mutually exclusive. If you register an spi driver, it'll appear
on that bus. It would be a good idea to also create a class "fpga". And an
FPGA will likely be a platform device unless you create a complete subsystem
that offers something like register_fpga_device(). The latter would be a nice
thing to have, I had to write FPGA programming drivers and had to implement
them as some char device in drivers/misc because there was no place where
they could go...

IMHO, the ideal solution would be to have an FPGA programming subsystem.
Somewhere in my board support I'd setup some struct fpga_device that
contains an element "bus_type" which can be set to FPGA_BUS_PARALLEL or
FPGA_BUS_SPI or whatever. A "name" element declares which driver I'd like
to use for my chip. A call to some fpga_register_device() with a
pointer to that struct would make the fpga subsystem remember that device and
look for an apropriate driver. Drivers register themselves by a call to some
register_fpga_driver() function. The fpga core would then make sure the
drivers probe function is called with pointers to the struct fpga_device of
the registered devices. That's how other subsystems work.

Such a subsystem would solve any FPGA programming problems (and your "main
problem" mentioned above) once and for all.

Thanks,
Hans

