Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZH3Ahv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZH3Ahv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZH3Ahu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:37:50 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40568 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbZH3Ahu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NkUjpLvYQxD7f85fo9fKWc774nxRgEAF6lJaNk0/rNStoSfIdk+tRPgbdbBEcQEPnD
         IpcFwOZPk9r6aW2fZE51qd0jggwOgo/fKReXbLRib5p9YfglFcq0ItP0yEF3ZmZ+eho3
         7UrWbhC+4TRxuKr/gbsbXiXpgJ71SaXM0KqNE=
MIME-Version: 1.0
In-Reply-To: <63386a3d0908291603i76603a17hc20a8d219c1dc07a@mail.gmail.com>
References: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com>
	 <20090821105636.GA2850@sirena.org.uk>
	 <63386a3d0908291603i76603a17hc20a8d219c1dc07a@mail.gmail.com>
Date: Sun, 30 Aug 2009 02:37:51 +0200
Message-ID: <63386a3d0908291737m5a17eaddxd3c39471553cf500@mail.gmail.com>
Subject: Re: [PATCH] AB3100 regulator support v1
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/30 Linus Walleij <linus.ml.walleij@gmail.com>:

> So this is because I am in the parents probe() function of course,
> and it's all expected.

I was curious how wm8350 on MX31 did this while using only subsys_initcalls()
(wm8400 doesn't look like it's completed yet) and found:

subsys_initcall_() ->
drivers/mfd/wm8350-i2c.:wm8350_i2c_init() ->
drivers/mfd/wm8350-i2c.c:wm8350_i2c_probe() ->
drivers/mfd/wm8350-core.c:wm8350_device_init() ->
arch/arm/mach-mx3/mx31ads.c:mx31_wm8350_init() ->
drivers/regulator/wm8350-regulator.c:wm8350_register_regulator()

which creates a platform device and sets the parent to
the struct wm8350->dev. But this is actually the i2c_client dev
and then it is not so strange that it works nicely to have both
the 8350 core device as parent and the platform devices as
children in a subsys_initcall() since the i2c core does not
use the regular device driver matching scheme, but rolls it's
own (which does NOT try to take the parent's semaphore...)

Linus Walleij
