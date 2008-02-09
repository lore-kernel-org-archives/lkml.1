Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYBIBOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYBIBOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 20:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbYBIBOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 20:14:22 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:25512 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755754AbYBIBOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 20:14:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=A18EBfTESqpduSGeJadaPr2UMpFXk9lBXF3sl91NA4/Sr2LyN9XTqvQ31cuW3597bSnqWuZE3B+vbrgAwBK9iRsEB5MWm8CQP6TyemvfJ8s1wpsot15Kg1DEq5sLD/PB36uj0uf+KOom/0nhMM8WHBc0V27YROiLiynCsV1IstI=  ;
X-YMail-OSG: 9Wu2aeAVM1leCDn7v1xAzgTcWds_RuabbahvKt8Q7SkgCkm5fRw8HmtoHMO15B_ylURkIMZ2rQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH 1/2] prevent gpio chip drivers from unloading while used
Date: Fri, 8 Feb 2008 17:14:18 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0802081159580.5301@axis700.grange> <200802081601.10673.david-b@pacbell.net> <Pine.LNX.4.64.0802090132010.8364@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0802090132010.8364@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802081714.18795.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > As long as one or more GPIOs on a gpio chip are used its driver should not 
> > > be unloaded.
> > 
> > The mechanism currently in place is to have gpiochip_remove() fail
> > if the platform's teardown() logic doesn't reject it.  (It may be
> > practical to have the teardown code get rid of the users...)  That
> > would be reflected as an "rmmod" failure.
> > 
> > Are you saying that doesn't work?
> 
> Yes, that's what I'm saying. I had a GPIO in use and rmmod-ed pca953x. It 
> did produce an error message
> 
> pca953x 0-0041: gpiochip_remove() failed, -16
> 
> , but rmmod completed.

Doesn't that seem buglike to you?

Oh, right -- the module exit code will ignore that status, it doesn't
even have a way to report failures any more.  Crap.

So it looks like we have no choice but to do this.  Can you make sure
all the rmmod-capable gpio_chip drivers support this?  Ignore the SOC
support, that never supports rmmod -- just the stuff in drivers/gpio.


> AFAIU, the only 2 ways currently to prevent rmmod  
> from completing, are: increment module use-count, then the respective 
> module_exit() function is not called at all and rmmod fails with -EBUSY. 
> Or block in rmmod until the resource becomes free. None of these has 
> happened. BTW, I think, there's the same problem with i2c adapter drivers.

Right.  In fact, every time you'd expect driver removal errors to
cause module removal to fail.   Maybe this is part of that whole
"should we even *support* rmmod" discussion, which I tuned out.

- Dave


