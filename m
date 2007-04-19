Return-Path: <linux-kernel-owner+w=401wt.eu-S2993177AbXDSIGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993177AbXDSIGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993190AbXDSIGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:06:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:1948 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993177AbXDSIFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cefDZIC+EypOzkAovBxced8lsq8B6vCTQCsKIMZ9/35aXfe37udaYavi9QjwG+Eoj26XfAdwzzZ3BVRURgs3z3BsOETcN4HpExMRu87r1TFDL6MWAGVcHVndCbVNqiSxST2xIIoHckRICBWmZOnLC/S5Y9VzobJun0qmQOE/4qI=
Message-ID: <38b2ab8a0704190105x68414f34w51f109f1f289ca7d@mail.gmail.com>
Date: Thu, 19 Apr 2007 10:05:19 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: question on generic gpio interface
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200704170942.49626.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com>
	 <200704160646.59407.david-b@pacbell.net>
	 <38b2ab8a0704170004h12c4ea41we6bdab3a1b443a18@mail.gmail.com>
	 <200704170942.49626.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, David Brownell <david-b@pacbell.net> wrote:
> In this case I'm not entirely sure how it'd work.  I've seen a few
> drivers which let userspace peek and poke at GPIO signals -- like
> one for Gumstix boards -- but generalizing the model isn't simple.
> Sub-problems include:
>
>  - Configuring the relevant pins.  Especially for SOC cases, GPIO
>    roles are multiplexed with several others.  So there are two
>    issues:  (a) the platform-specific setup of that multiplexing,
>    plus (b) the board-specific knowledge of what pins are truly
>    available for use as GPIOs, and not otherwise in use.
>

what about create a module "user-gpio" for example that could request
some gpios that the board could have declared using resource
subsystem, like this:

static struct resource foo_gpio_resource[] = {
        [0] = {
                .start = 10,
                .end  = 11,
                .flags = IORESOURCE_GPIO,
        },
       [1] = {
                .start = 26,
                .end  = 31,
                .flags = IORESOURCE_GPIO,
        },
};

struct platform_device foo_device_usergpio = {
        .name           = "user-gpio",
        .id             = -1,
        .num_resources  = ARRAY_SIZE(foo_gpio_resource),
        .resource       = foo_gpio_resource,
};

This way "user-gpio" module knows which pins are avalaible to userspace.

>  - Enumerating those GPIOs to userspace.  One SOC might have just
>    a few dozen, another might have a few hundred; and then there
>    are all the board-specific ones, on FPGA or I2C chips etc.
>

This point is actully the one where I'm really not sure...

Enumerating user GPIOs would always start from 0 to GPIO_USER_NR - 1
and an application that need to be portable should use a config file
to specify which GPIO num to use...

>  - Exposing those pins to userspace.  It'd be unsafe to let pins
>    claimed by drivers be managed by userspace; the default should
>    be that only unclaimed GPIOs can be accessed.
>

Well an extreme solution would be to test in gpio_request(), if the
passed gpio nr is a user one then gpio_request() would return an
error. We could use is_user_gpio() function implemented by user-gpio
module

Thanks
-- 
Francis
