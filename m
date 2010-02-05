Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0BEUtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:49:55 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36782 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755787Ab0BEUtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:49:51 -0500
Date: Fri, 5 Feb 2010 23:49:49 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH RFC 0/3] Implement refcounting for OF GPIO chips
Message-ID: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

OF GPIO infrastructure is using dynamic GPIO bases, so it is possible
that of_get_gpio()'s returned GPIO number will be no longer valid, or
worse, it may point to an unexpected GPIO controller.

This scenario is possible:

driver A:               driver B:              driver C:
---------               ---------              ---------
                        gpiochip_add()
gpio = of_get_gpio()
                        gpiochip_remove()
                                               gpiochip_add()
gpio_request(gpio);
gpio_set_value(gpio);

That is, driver A assumes that it is working with GPIO from driver B,
but in practice it may disappear and driver C will take its GPIO base
number, so it will provide the same GPIO numbers.

The above situation is hard to trigger, but the issue is there
nonetheless, and so needs fixing.

Thanks,

p.s. The patches are based on top of
     '[PATCH v2 0/4] OF GPIO integration for I2C/SPI GPIO chips'
     http://lkml.org/lkml/2010/2/5/243

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
