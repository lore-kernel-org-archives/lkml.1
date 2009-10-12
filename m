Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZJLGLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZJLGLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZJLGLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:11:48 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:12953
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbZJLGLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:11:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYAANtk0kp8qN+D/2dsb2JhbAAI1W+ELQSBWA
X-IronPort-AV: E=Sophos;i="4.44,544,1249228800"; 
   d="scan'208";a="591274690"
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
From: Ben Nizette <bn@niasdigital.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, dsilvers@simtec.co.uk
In-Reply-To: <20091010135343.775e535f@bike.lwn.net>
References: <20091010134814.0bac8624@bike.lwn.net>
	 <20091010135343.775e535f@bike.lwn.net>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 17:11:44 +1100
Message-Id: <1255327904.5347.79.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 13:53 -0600, Jonathan Corbet wrote:
> GPIO: add gpio_lookup()
> 
> GPIOs have names associated with them, but drivers cannot use those names
> and must thus rely on hardwired GPIO numbers.  That, in turn, makes dynamic
> assignment hard to use.  This patch adds a little function gpio_lookup()
> which returns the GPIO number associated with a name.
> 

OK for something supposedly basic, all this gpio stuff is getting messy.
The gpio framework was written to use gpio numbers as they were
recognised as being common to all possible implementations of the
framework.  Now gpiolib, one implementation (ok I think currently the
only implementation) of that framework, has the ability to have names
associated with the gpios it handles so userspace can get a better idea
of which gpio are which.  This is kind of OK (see below) because gpiolib
and gpio-sysfs are inextricably linked.  With the addition of this
patch, drivers are going to start not depending on the gpio framework
but on an implementation of that framework - gpiolib.  Or at least
require that all future implementations track this dual namespace.

I didn't notice Daniel's original patch fly by otherwise I would have
said something at the time, but storing the names at the chip level
seems an odd idea.  Given that at that stage they were only for sysfs
id, why not just give them as an argument to gpio_export()?

Back to this patch though, the gpio names have to come from the platform
code via some platform_data for the gpio chip [1], the driver then looks
up that pre-defined name to find the gpio number.  Why not just pass the
gpio number straight to the end device driver through platform_data and
bypass the middle-man?

At a higher level, there have been a number of pushes recently; for one
reason or another people really really seem to want the dual number/name
namespace inside the kernel.  With this patch we're at the stage where
this is true and gpiolib has functionality outside the gpio framework
concepts.  In order to keep drivers properly cross-platform we have some
options:  We can keep adding concepts and required functionality to the
gpio framework interface, recognise that some drivers won't be quite as
cross-platform as they could/should be or simply note that it's now been
2.5 years since the gpio framework and gpiolib were merged and it's
still the only implementation; maybe it's time to ditch the distinction
and simply make gpiolib /the/ way you wire up gpios.

David's call really, thoughts?

	--Ben.

[1] which is ugly for at least avr32, the only platform I know
intimately, but not my current point

