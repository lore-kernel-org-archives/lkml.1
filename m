Return-Path: <linux-kernel-owner+w=401wt.eu-S1765894AbXHQS2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765894AbXHQS2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbXHQS1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:27:43 -0400
Received: from smtp111.sbc.mail.re2.yahoo.com ([68.142.229.94]:47477 "HELO
	smtp111.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756013AbXHQS1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:27:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=h51MBt7uB3PlF+b6AruUqMlmdHdjIVLGei0t1qawh0TsQFTr5elMe/575/hiiCuD4LPtP2Fkoq7MfalobX3Te9bZa0VofrZddeGIMeWNO9aBO/F2mTcvgqDMmmpj0N2bxvIYjQOzlhOlWR2c0clm/3laCz2Odv80a/wFC/pToVQ=  ;
X-YMail-OSG: m9DHcmAVM1mFguAXDAADJ2LfjaTLhsiuUOkBUK802S5uueagCw95CHTy5vzlKI.H6VCB9zNz32h1N7VlTEQc0FfvxD9f7xqan3CE255OTVjvDKUKE7zjL1lRGZYOGtOMquqUIB1SjIXxSfY-
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Fri, 17 Aug 2007 11:24:54 -0700
User-Agent: KMail/1.9.6
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <1186544139342-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1186544139342-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708171124.54839.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Again, the patch descriptions need work.  This changes the
IRQ code (to add those labels).  $SUBJECT doesn't mention IRQs,
neither does the description ...


On Tuesday 07 August 2007, Bryan Wu wrote:
> --- a/arch/blackfin/mach-common/ints-priority-dc.c
> +++ b/arch/blackfin/mach-common/ints-priority-dc.c
> @@ -221,7 +221,7 @@ static unsigned int bf561_gpio_irq_startup(unsigned int irq)
>  
>         if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
>  
> -               ret = gpio_request(gpionr, NULL);
> +               ret = gpio_request(gpionr, "IRQ");
>                 if (ret)
>                         return ret;
>  
> @@ -261,7 +261,7 @@ static int bf561_gpio_irq_type(unsigned int irq, unsigned int type)
>  
>                 if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
>  
> -                       ret = gpio_request(gpionr, NULL);
> +                       ret = gpio_request(gpionr, "IRQ");
>                         if (ret)
>                                 return ret;
>  

Just for the record, this is an unusual way to use these calls.

Other platforms completely decouple these issues from the
IRQ infrastructure ... doing the pinmux and gpio claiming
separately from the request_irq()/free_irq() paths, mostly
as part of board setup.  Doing all of that "early":

 - keeps those error returns from causing hard-to-track-down
   runtime bugs;

 - works always, even on platforms where a given IRQ may
   appear on any of several pins/balls;

 - makes it easier to cross-check against board schematics,
   by keeping most board-specific setup in one source file;

 - shrinks the kernel's runtime footprint;

 - allows the label to be more descriptive ... describeing
   exactly *which* IRQ, so that using the labels for better
   diagnostics actually gives better diagnostics.

Again, not "wrong"; but probably sub-optimal.  You might
want to move towards earlier binding now, while Linux is
still young on Blackfin and you don't have legacy code to
worry about.

- Dave

