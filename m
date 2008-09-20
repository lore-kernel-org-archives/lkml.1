Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYITJbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYITJbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 05:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYITJb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 05:31:26 -0400
Received: from web26208.mail.ukl.yahoo.com ([217.12.10.245]:38050 "HELO
	web26208.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751009AbYITJbZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 05:31:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ePlKowjOLbi2TkwSUnQjwgEe1T3CrTkk5jxxQLVOWd1BM/vV4YaxzGc+yiF0OxZ/ZeYBaDgytD2E+SmHO3BPMm+cr8yn1dw9GGBE3ms5hXG6IWe0YPYJZrQyzxn2/oByVEs6bEnk4xgpki2wMK6Qf38xqv7E23ZLZZYOJOlMeVQ=;
X-YMail-OSG: QR8_94kVM1nW.Zfjz00l1ewDtgk1L04p7xNB7khwRQnUtq1Y4Q6XQ0FeTNfgMuaF4A--
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Sat, 20 Sep 2008 09:31:23 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] atmel_serial: update the powersave handler to match serial core
To: Anti Sullin <anti.sullin@artecdesign.ee>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <332452.26141.qm@web26208.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Messaggio originale -----
> Da: Anti Sullin <anti.sullin@artecdesign.ee>
> A: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Cc: Michael Trimarchi <trimarchimichael@yahoo.it>; linux-serial@vger.kernel.org; linux-kernel@vger.kernel.org; Andrew Victor <linux@maxim.org.za>
> Inviato: Venerdì 19 settembre 2008, 23:49:29
> Oggetto: Re: [PATCH] atmel_serial: update the powersave handler to match serial core
> 
> Haavard Skinnemoen wrote:
> > Michael Trimarchi wrote:
> >  
> >>> I agree it would be useful. It would require changing the port mux
> >>> configuration from the driver though, and there's no standardized
> >>> interface for doing that. Maybe this is a good motivation to come up
> >>> with one?
> >>>  
> >>>      
> >> I think that a driver can do the request to a the gpio layer (may can be 
> implemented
> >> by the gpio-lib ) and give it only the gpio. The "gpio-lib" can save and 
> restore
> >> the status of the gpio, and request the handler, passing the gpio-id as 
> >> a data. So when the handler fire, we can now which peripheral is
> >> interested on the wake-up event.
> >>    
> >
> > I don't think the gpio layer is supposed to touch the portmux. David
> > has always been very clear about that. But if we somehow manage to get
> > the pin configured as a GPIO, we can use the GPIO layer to request a
> > pin change interrupt.
> >
> > It _might_ work even if you don't reconfigure the pin as a GPIO...but
> > then I think we'd be relying on undocumented behaviour.
> >  
> I believe that you don't need to reconfigure the pin. The gpio hw does
> not require the pin to be multiplexed to any given state, so does not 
> request_irq (correct?).
> I did this trick in my [2/3] MCI driver patch I sent to arm-linux-kernel at 
> 18.03.2008 (the
> e-mail subject line was wrong, [1/3], though) and I'm using that patch still on 
> my
> production devices to avoid some rare but critical SD data corruption (mainline 
> kernel still 
> screws up the filesystem on SD sometimes). The same should be easily usable on 
> serial port, too.
>

I must to check this point. I do it few months ago, and if I remember I change
the serial configuration on rx line to a gpio and request and interrupt. I don't
have the hardware to recheck.

> >  
> >>> Btw, I assume the first character you receive will be lost when you do
> >>> this, right?
> >>>  
> >>>      
> >> Yes, I haven't done a lot of test to see how many chars are lost (sure one I 
> think). 
> >> Depends on the time spent after
> >>
> >>  /* Wait for interrupt to wake us up */ 
> >>   mcr p15, 0, r0, c7, c0, 4 
> >>    
> >
> > Yes, we need to reach the atmel_serial resume handler before the UART
> > gets any chance to recognize the character. It's probably too late for
> > the first one, but it may catch the next one assuming the baud rate
> > isn't too high.
> >  
> I believe, that we loose quite many characters. We are running at 32/16kHz
> (switching the master clock divider /2 off proved unstable) and
> this is not enough to even receive 9600 baud until we have the fast clock
> running again.
> 
> Some quick calculations:
> For waking up, we need to switch on the main oscillator, wait until it
> stabilizes (default should be max: ~60ms), switch on plla, wait until it
> locks (2ms), switch on pllb, wait until it locks (2ms), switch system to PLLA...
> And then set up the drivers again... On 115200 baud, this is almost 1kB!
> 
> So in many applications we could not use this. But this might still come handy
> in a lot of cases we can poll and find out what caused the data on the serial
> port etc. Or on applications, where this loss of data does not matter (like 
> debug
> console where the resume is usable even if it does not wake up on the first 
> byte).

Of course, but it is the same for all devices when you do a suspend with a 
slow clock.
 
> 
> 
> -- 
> Anti Sullin
> Embedded Software Engineer
> Artec Design LLC
> Akadeemia tee 23A, 12618, Tallinn, Estonia
> http://www.artecdesign.ee 

Regards Michael

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
