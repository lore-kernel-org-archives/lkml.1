Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYIZTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYIZTtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYIZTtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:49:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYIZTtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:49:08 -0400
Message-ID: <48DD3CAE.9050809@zytor.com>
Date: Fri, 26 Sep 2008 12:49:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Rafal <newsgroup@limcore.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel unable to adjust timeofday
References: <gbio4j$aqq$1@ger.gmane.org> <47571.1222440706@turing-police.cc.vt.edu>
In-Reply-To: <47571.1222440706@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 26 Sep 2008 15:29:53 +0200, Rafal said:
>> Hello, my system (64bit Ubuntu amd64 box) drifts about 10 seconds per hour
>> (i.e. time visible in the system).
> 
> First thing to do is figure out why your box has *such* a dreadfully poor
> clock. You're drifting at around 3,000 parts-per-million.  NTP is only able
> to deal with drifts up to 500 ppm, and most systems clocks are *much* more
> stable than that (for instance, my laptop is drifting at 2 ppm at the moment).
> The fact you're way outside the sane range leads to trouble...
> 

There are two possibilities:

Either, his system uses a ceramic oscillator instead of a crystal.  In 
that case, you're screwed.  Those can be ±10,000 ppm or more.  The other 
is that he is on a system which has a wrong frequency crystal installed 
for what the time base expects (usually 14.31818 MHz on PCs) -- say 15 
MHz.  In that case the clock is still stable, it's just *inaccurate*.

In the latter case, the adjtimex(8) command can be used to tell the 
kernel the approximate rate the clock is ticking, and then let NTP do 
the fine-tuning.

If you have manually determined that you are gaining 244 seconds in 24 
hours of free-running operation, you would use the following formula to 
calculate the tick interval:

            S
tick =  -------- * 10000
          G + S

... where S is the real sample interval (24 hours = 86400 seconds) and G 
is the amount of time gained in that time (244 seconds in this case); if 
you are *losing* time then G would be negative.

In this case:
            86400
tick = ------------- * 10000 = 9971.8 ~ 9972
         244 + 86400

So you would set:

adjtimex --tick 9972

... in your startup scripts, before ntpd is started.

If NTP still goes off the rails, then adjust the tick value in steps of 
about 5 until you can get it to converge.

	-hpa
