Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0BIR2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:28:37 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:48160 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab0BIR2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:28:35 -0500
MIME-Version: 1.0
In-Reply-To: <20100205205045.GC4178@oksana.dev.rtsoft.ru>
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru> <20100205205045.GC4178@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Feb 2010 10:28:15 -0700
X-Google-Sender-Auth: 171526f772438628
Message-ID: <fa686aa41002090928o6911d095ydca1e1e670a0fc22@mail.gmail.com>
Subject: Re: [PATCH 3/3] of/gpio: Introduce of_put_gpio(), add ref counting 
	for OF GPIO chips
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 1:50 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> OF GPIO infrastructure is using dynamic GPIO bases, so it is possible
> that of_get_gpio()'s returned GPIO number will be no longer valid, or
> worse, it may point to an unexpected GPIO controller.
>
> This scenario is possible:
>
> driver A:               driver B:              driver C:
> ---------               ---------              ---------
>                        gpiochip_add()
> gpio = of_get_gpio()
>                        gpiochip_remove()
>                                               gpiochip_add()
> gpio_request(gpio);
> gpio_set_value(gpio);
>
> That is, driver A assumes that it is working with GPIO from driver B,
> but in practice it may disappear and driver C will take its GPIO base
> number, so it will provide the same GPIO numbers.
>
> With this patch that situation is no longer possible. Though drivers
> will need to learn to put GPIOs back, so that GPIO controllers could
> be removed.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Rather than having a lock at the device tree data pointer level which
mixes usage with potentially many other drivers; wouldn't it make more
sense to use a mutex at the of_gc subsystem context?

g.
