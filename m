Return-Path: <linux-kernel-owner+w=401wt.eu-S965703AbYCSWfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbYCSWfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964972AbYCSVGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:06:54 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:20317 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762534AbYCSVGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:06:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=b4O+sBnlqNUpkvvPJ9WlLHCNQ8Hv12eXidy5cmrPARK9GPTocGzaZPPKrVwgOzblkK2J933UdiUILPfKCrfPly7IX4dioK7b5Lb8uqD8Rny0cGVCTCUeL1kInh3UyPqT4LXaDzykJ5bboWi5CcyoCN6omoDKJYNLEtmlJ8BuJbI=  ;
X-YMail-OSG: 1srDS2oVM1nqqo867jiKPamOCBcmJFGpCdhfUTqQNyfXR_8Xi6dL4t28lYvidAKNjE2.NPm.Rw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Date: Tue, 18 Mar 2008 11:06:13 -0800
User-Agent: KMail/1.9.6
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
References: <20080316184349.GA28543@khazad-dum.debian.net> <200803161246.23909.david-b@pacbell.net> <20080318001429.896acf51.akpm@linux-foundation.org>
In-Reply-To: <20080318001429.896acf51.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803181206.14162.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008, Andrew Morton wrote:
> On Sun, 16 Mar 2008 11:46:23 -0800 David Brownell <david-b@pacbell.net> wrote:
> 
> > On Sunday 16 March 2008, Henrique de Moraes Holschuh wrote:
> > > Is the use of "if (preempt_count())" to know when to defer led gpio work to
> > > a workqueue needed? __Shouldn't "if (in_atomic())" be enough?
> > 
> > At this point, I don't know of any such reason.
> > 
> > I remember hunting for the right heuristic, and settling on
> > that one for reasons that I can't recall now.  They may even
> > be no longer applicable.
> 
> Both are incorrect. 

So something like the appended patch would seem "better"?


> <greps for in_atomic>
> 
> omigawd, what have we done, and how can we fix it? :(

 
==============
It appears that we can't just check to see if we're in a task
context ... so instead of trying that, just make the relevant
leds always schedule a little worklet.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/leds/leds-gpio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- g26.orig/drivers/leds/leds-gpio.c	2008-03-18 01:32:08.000000000 -0700
+++ g26/drivers/leds/leds-gpio.c	2008-03-18 02:01:23.000000000 -0700
@@ -49,13 +49,13 @@ static void gpio_led_set(struct led_clas
 	if (led_dat->active_low)
 		level = !level;
 
-	/* setting GPIOs with I2C/etc requires a preemptible task context */
+	/* Setting GPIOs with I2C/etc requires a task context, and we don't
+	 * seem to have a reliable way to know if we're already in one; so
+	 * let's just assume the worst.
+	 */
 	if (led_dat->can_sleep) {
-		if (preempt_count()) {
-			led_dat->new_level = level;
-			schedule_work(&led_dat->work);
-		} else
-			gpio_set_value_cansleep(led_dat->gpio, level);
+		led_dat->new_level = level;
+		schedule_work(&led_dat->work);
 	} else
 		gpio_set_value(led_dat->gpio, level);
 }


