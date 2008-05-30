Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbYE3MHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbYE3MHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYE3MGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:06:55 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:4464 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750885AbYE3MGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:06:54 -0400
Date: Fri, 30 May 2008 16:06:52 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: fix build errors for drivers not strictly
	requiring GPIOs
Message-ID: <20080530120652.GA1286@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080527142029.GA31778@polina.dev.rtsoft.ru> <200805292028.10906.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200805292028.10906.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 08:28:10PM -0700, David Brownell wrote:
> On Tuesday 27 May 2008, Anton Vorontsov wrote:
> > Since commit 7560fa60fcdcdb0da662f6a9fad9064b554ef46c (gpio: <linux/gpio.h>
> > and "no GPIO support here" stubs) drivers can use GPIOs if they're available,
> > but don't require them.
> > 
> > This patch actually enables this feature, otherwise drivers will stumble
> > against this:
> > 
> > include/asm-generic/gpio.h:111: error: redefinition of 'gpio_is_valid'
> > include/linux/gpio.h:21: error: previous definition of 'gpio_is_valid' was here
> 
> This looks to me like pure user error ... what was anyone doing
> including <asm-generic/gpio.h> in that way?  There are a *lot* of
> bogus include combinations, and we don't try to "fix" them.

This is true, partially. I saw these errors for the drivers using
linux/of_gpio.h, it includes asm/gpio.h, which includes
asm-generic/gpio.h (I submitted of_gpio.h patch before linux/gpio.h work,
though git log might say otherwise). And yes, I should fix of_gpio.h too.

The thing is, I always thought that it is _good_ practice for the nested
headers to declare/define things conditionally by themselves. That way
you'll not have to fix all combinations, everything will (should) just
work. I.e.

#include <linux/of_gpio.h>
#include <asm-generic/gpio.h>
#include <asm/gpio.h>
#include <linux/gpio.h>

^^ This insanity will work.

Though with current headers, you'll easily catch the bogus users of
the asm/gpio.h thus will discipline the users, that might be a plus
too... ;-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
