Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYJPQ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYJPQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYJPQ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:56:15 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:44254 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751507AbYJPQ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:56:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cOCPVMS1j8Z6LxVGHMwFstwWEI5wDBOJpfkVOqCxb/x5q8cZv6nG01bZJ2vnCV98ZvaemHP4F6CnDJVeGw3KkBC+RngiwpPLzjITgjGs0QUXuVbYEusn8tstTOKmaAK8L6+CnT3OsBoBDnle2/dxEIZBcEh86c8mkO66G8hLf+U=  ;
X-YMail-OSG: _dh0xQ0VM1kTK3oN1hhyS46zP00qEvpkxRziXR6LY0LMiTrooVt6NAveLmrF.fRmH7ZLdzmBqhbjwWCyhHDnIn5wOyKOshulSXRXxVXI.UH4JOQML6LlzWCNTCv0OlRnGOQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH] gpiolib: fix oops on reading sysfs exported GPIOs
Date: Thu, 16 Oct 2008 09:56:12 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20081016144503.GA17455@oksana.dev.rtsoft.ru> <200810160843.08553.david-b@pacbell.net> <20081016163523.GA27938@oksana.dev.rtsoft.ru>
In-Reply-To: <20081016163523.GA27938@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160956.12845.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Anton Vorontsov wrote:
> > Not true; the API explicitly allows GPIOs to be treated
> > as bidirectional, even when they're configured as outputs.
> > That's because most GPIOs *are* bidirectional.
>
> I just recalling somebody was speaking about not wasting cycles with
> the checks in the gpio_{set,get}_value().

void __gpio_set_value(unsigned gpio, int value)
{
        struct gpio_chip        *chip;

        chip = gpio_to_chip(gpio);
        WARN_ON(extra_checks && chip->can_sleep);
        chip->set(chip, gpio - chip->base, value);
}

So not many checks there at all.  The get() path has one
additional check -- is the method null? -- for the reason
summarized above.  And if you're coming from userspace via
sysfs, you won't even notice those checks.


> And the solution was that 
> before using the gpio_{set,get} one should always try to issue the
> "direction" calls to ensure that gpio controller is capable of that
> direction... 

The reason to use gpio_direction_{output,input}() calls is
mostly to turn the output drivers on/off.  Secondarily they
do report errors when that particular GPIO can't do that.

If you really want GPIO operations to be two instructions
with no subroutine calls, make sure your platform supports
inlining the gpio_get_value() calls that have constant params
that correspond to on-chip GPIOs.  (Can't be done over I2C...)

That *CAN* make a big difference in bitbang speed ... multiple
megabits per second with SPI, for example, vs less than one.

- Dave
