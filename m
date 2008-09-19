Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYISSfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYISSfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYISSfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:35:45 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39227 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbYISSfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:35:45 -0400
Date: Fri, 19 Sep 2008 20:35:20 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>,
       Anti Sullin <anti.sullin@artecdesign.ee>
Subject: Re: [PATCH] atmel_serial: update the powersave handler to match
 serial core
Message-ID: <20080919203520.2969dffd@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <866907.89401.qm@web26206.mail.ukl.yahoo.com>
References: <866907.89401.qm@web26206.mail.ukl.yahoo.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 18:35:10.0244 (UTC) FILETIME=[724E3E40:01C91A86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Trimarchi <trimarchimichael@yahoo.it> wrote:
> > I agree it would be useful. It would require changing the port mux
> > configuration from the driver though, and there's no standardized
> > interface for doing that. Maybe this is a good motivation to come up
> > with one?
> >   
> 
> I think that a driver can do the request to a the gpio layer (may can be implemented
> by the gpio-lib ) and give it only the gpio. The "gpio-lib" can save and restore
> the status of the gpio, and request the handler, passing the gpio-id as 
> a data. So when the handler fire, we can now which peripheral is
> interested on the wake-up event.

I don't think the gpio layer is supposed to touch the portmux. David
has always been very clear about that. But if we somehow manage to get
the pin configured as a GPIO, we can use the GPIO layer to request a
pin change interrupt.

It _might_ work even if you don't reconfigure the pin as a GPIO...but
then I think we'd be relying on undocumented behaviour.

> > Btw, I assume the first character you receive will be lost when you do
> > this, right?
> >  
> 
> Yes, I haven't done a lot of test to see how many chars are lost (sure one I think). 
> Depends on the time spent after
> 
>  /* Wait for interrupt to wake us up */ 
>   mcr p15, 0, r0, c7, c0, 4 

Yes, we need to reach the atmel_serial resume handler before the UART
gets any chance to recognize the character. It's probably too late for
the first one, but it may catch the next one assuming the baud rate
isn't too high.

Haavard
