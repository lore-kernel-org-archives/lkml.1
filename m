Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZFJBBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZFJBBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZFJBBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:01:47 -0400
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:37801 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751446AbZFJBBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:01:46 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 21:01:46 EDT
X-Yahoo-Newman-Id: 383289.53424.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DgE6IDWyT1ijg2cdy59NpXQKypMSMFphBJ5pKUAXcrgGAqDr4jfBD4Xs4huYRLdnLoT5zHk8HGMnRmqIwFPLSfmzbW9Dx603K5yvWyIBeA+4MyGgQqhBYZZm4dFHdWMCKE5dZzCsKEGpnoHeqK7dXkxrdQfqoYWJwykn6SMggPw=  ;
X-YMail-OSG: HPgXpoMVM1mjbecQUkbxCO9GpqV2p2BqRpPALLfX0DbefQ3XAJsdurjc1tzcj92yF40DyUJwFIqtBnSwXiBTZoL4l.mtzctsBxHWjO115cm4hF1Xr0ryPqjOHwwo_YCP0cRU8UNIoPHjKOk7J9Ket2XW0QJUSWRRq_Hrkrz4Kg3i0zSAN6tCRbmqmGVuMawBo6kWgfPNop.vj7O.qOl.wjlfW1Qg9E8GI.pmATZLl6.Kv8pDorTsD4B8yg.xGtsbl15MywHTvQ3HheRgAtziCDvTLbLdB6z6Kw6_hdH9X6S2iVeuLA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Subject: Re: [PATCH] gpiolib: add gpio_request/free_irq
Date: Tue, 9 Jun 2009 17:56:11 -0700
User-Agent: KMail/1.9.10
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <200906051151.05779.hartleys@visionengravers.com> <200906052219.47888.david-b@pacbell.net> <BD79186B4FD85F4B8E60E381CAEE19090191701F@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090191701F@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906091756.11839.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, H Hartley Sweeten wrote:
> On Friday, June 05, 2009 10:20 PM, David Brownell wrote:
> > On Friday 05 June 2009, H Hartley Sweeten wrote:
> > Add support functions to gpiolib to request/free gpio irqs.
> > 
> > I'm not keen on this.
> > 
> >  - At best it's a convenience layer ... for something that's
> >    not the least bit awkward to do otherwise.
> 
> 		... deletia ...
> 
> >  - Coupling it to gpiolib sort of defeats the point of saying
> >    that gpiolib is just an *implementation* of the interface.
> >    Where's the code to run for non-gpiolib platforms?
> > 
> 
> But if a driver is using the gpiolib interface calls wouldn't that
> prevent that driver from working on a platform that does not support
> gpiolib? File include/linux/gpio.h defines all the gpiolib calls to
> either return an error code or WARN_ON(1) when called.

There are three kinds of config to be concerned with:

 - Platform doesn't support the GPIO calls at all.  In those
   cases, drivers using <linux/gpio.h> get NOP stubs; you have
   this case covered.

 - Platforms supporting the calls but not using gpiolib.
   That's the case I pointed out -- you don't handle it.

 - Platforms supporting the calls with gpiolib.  This is the
   other case you handle.


> >  - Since it implicitly couples gpio_request() to a flavor of
> >    request_irq(), it precludes sharing those IRQs.
> > 
> 
> Can't the IRQ be shared by passing IRQF_SHARED as one of the flags?

Only one of them will be able to gpio_request(), so it
doesn't matter at all what you say to request_irq().


> > Basically, board setup can know that the GPIO is being used
> > as an IRQ, and do the request()/direction_input() before it
> > passes gpio_to_irq() to the driver. That's worked in every
> > case I've happened across so far...
> 
> I agree it works as-is right now.  I just thought this would be a
> convenient wrapper to handle a common setup step.  If it's overkill
> or not appropriate to add to gpiolib please disregard the patch.


