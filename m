Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368Ab0AHHQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0AHHQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 02:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251Ab0AHHQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 02:16:22 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:50858 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0AHHQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 02:16:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uU8mSYJcRbvnM15dnVTFnNVnWzXEmDyX26RNscImmD03A7h0CvxDHXwvFkH/yVEC7G
         76X8mb6mkrcjdOWiwmNLkKmlc0mOZymVnY+JTMhrzm7/lqg3uA8IkTyjovUAbZPLeS1/
         LmTImD8cXslCf7J8noNNf1CCvx1LCO17hBMqI=
MIME-Version: 1.0
In-Reply-To: <A780F468-EA15-49EA-83B4-D472E92CA91A@niasdigital.com>
References: <f17812d71001072114g95c267cpa6dc06a636c6d9a@mail.gmail.com> 
	<A780F468-EA15-49EA-83B4-D472E92CA91A@niasdigital.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 8 Jan 2010 15:16:00 +0800
Message-ID: <f17812d71001072316j54514eb4mf7ff2df619515874@mail.gmail.com>
Subject: Re: [PATCH] gpio: introduce gpio_request_one() and friends
To: Ben Nizette <bn@niasdigital.com>
Cc: David Brownell <david-b@pacbell.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 2:08 PM, Ben Nizette <bn@niasdigital.com> wrote:
>
> On 08/01/2010, at 4:14 PM, Eric Miao wrote:
>
>> commit 29cd35f57699fd93a12132186d52109a55ed57e7
>> Author: Eric Miao <eric.y.miao@gmail.com>
>> Date:   Fri Jan 8 12:16:28 2010 +0800
>>
>>    gpio: introduce gpio_request_one() and friends
>>
>>    gpio_request() without initial configuration of the GPIO is normally
>>    useless, introduce gpio_request_one() together with GPIOF_ flags for
>>    input/output direction and initial output level.
>
> Well yea it is useless without initial configuration but I've always done that configuration before any gpiolib calls.  The initial direction and state stuff really has to be set up and pin-mux or gpio-chip-activate time otherwise it'll glitch; by the time we get to gpio_request time I've got everything just how I like it and just want the refcount aspect of gpio_request.
>

The hardware will anyway glitch if the pin mux and GPIO registers are
different, which is almost true on every platform. The problem is not
to prevent GPIO from being glitch, but how to survive GPIO glitch.

1. from HW, in some cases the reset state of GPIOs are input, which
is basically high-z from the outside, so is not likely to cause problems.

2. if the GPIO reset state is output, with a fixed level (either high or low),
yet the software initializes it to be the opposite, then glitch happens, and
this will impact the external. In such cases, software needs to make sure
there will be no negative impact, e.g. put the external impact chip into
reset or power off state until GPIOs connected are configured to known state.

> I'm obviously thinking in a very small-minded platform-gpio-only kind of a way, what system have you got which uses this (and how does it not glitch)?
>

Mostly PXA processor based systems and they do glitch with careless
configuration and hw design. The patch here is not going to solve the
glitch problem, but to group the request and configuration together as
most GPIO API users are using these two together, and some are using
gpio_request + gpio_direction_* again and again repeatedly for a bunch
of GPIOs, which is not clean.
