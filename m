Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYI0S3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYI0S3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYI0S3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:29:11 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:29319 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752921AbYI0S3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:29:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oqUexMaTOMY3jjFWZGp6LvjwU8Vvqw+U3XqAiXFDo2KMWn27kAC8tDMHIADcq4Tv4k8oIDMhb2Efh2DC+X9menbipS74x6UkuH9UIN4AFvmFK6QfYYa4O7Qcjm+Sq7AFmtYWy4Xza6/x0N59PO5VsrisDFyeU8Lpb5xIPvUZwkE=  ;
X-YMail-OSG: xXrlnUoVM1mU0T5PCybKKjA_WPS10nV4vYEDpzQYf4om9ZUN0tuZpjrw7FiuiX.5JLoGt4SOAPeR0KNF_ZT_bo0ghK2.8X7IzCWS9NUkIBFEOfd02fZKl2ExW.GwZG2dIhFrx.RMSvEHTNCUn1dWY._pipwf
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Magnus Damm" <magnus.damm@gmail.com>
Subject: Re: [patch 2.6.27-rc7] gpiolib: request/free hooks
Date: Sat, 27 Sep 2008 11:29:06 -0700
User-Agent: KMail/1.9.9
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <200809241508.11091.david-b@pacbell.net> <aec7e5c30809270800y7a4b59eem8af480d5899a791a@mail.gmail.com>
In-Reply-To: <aec7e5c30809270800y7a4b59eem8af480d5899a791a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271129.07241.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 September 2008, Magnus Damm wrote:
> 
> Looking good. I'm currently hacking on some pinmuxed gpio code for
> SuperH, and I'd like to use these request/free callbacks to select
> proper pinmux state.

I'm not so keen on that particular overloading, but I can
understand why it might be wanted on systems which have a
happy one-to-one mapping between GPIOs and pins.

If you do that, be ready to provide a pinmux-only interface
at some point when this "piggybacking" breaks something...

 
> I have one comment below though:
> 
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -781,6 +785,7 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
> >  int gpio_request(unsigned gpio, const char *label)
> >  	...
> 
> The code above doesn't catch double gpio_request() user calls
> properly. Or rather, the user will receive an error but the
> chip->request() callback may get called twice.
> 
> What about modifying the gpiolib code to handle that? I think that
> sounds like a better idea than cover ing that case in the chip code...

Yeah.  Better to test-and-set the flag and then request, and backout
if it fails, than the other way.  Just who wrote that crap in the
first place?  Sigh.  (Notice it's done that way already in the code
path handling implicit requesting ... )

I'll send an updated patch along soonish.

- Dave
