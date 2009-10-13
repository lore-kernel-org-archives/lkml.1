Return-Path: <linux-kernel-owner+w=401wt.eu-S934150AbZJMXUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150AbZJMXUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761585AbZJMXUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:20:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:35950 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZJMXUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:20:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mJax19ZDjQjChQheJee80Rq8bxu+LIdB5ltGM2kyl9dD7aHP4SuIgi+e+dh82RGTYr
         vHrQ2+CGHJDqSJdO8Ybsb1NkB2OHBAjTGTFoY+U6VslLoFj0i3P3LPCh3fCfiofxfzzt
         l36icUqaJYFupGMFhpF02Fkn6ShwiI9nuPlys=
Date: Wed, 14 Oct 2009 01:16:41 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091013231641.GA4404@Pilar.aei.mpg.de>
References: <20091011180134.GA5197@core.coreip.homeip.net> <20091011193100.GA4410@Pilar.aei.mpg.de> <20091012090224.GB7403@core.coreip.homeip.net> <20091012100929.GA4402@Pilar.aei.mpg.de> <20091013032414.GC2887@core.coreip.homeip.net> <20091013121109.GB4619@Pilar.aei.mpg.de> <20091013182643.GC21593@core.coreip.homeip.net> <20091013190819.GA7555@Pilar.aei.mpg.de> <20091013194654.GD21593@core.coreip.homeip.net> <20091013202459.GE21593@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013202459.GE21593@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[restoring Cc: list]

On Tue 13.Oct'09 at 13:24:59 -0700, Dmitry Torokhov wrote:
>
> Could you please try this patch (again if you could post dmesg that
> would be great). Thank you!

The patch quoted below also fixes the problem. I attached the
syslog with i8042.debug (with a s2ram in the middle) to the
bugzilla: 

http://bugzilla.kernel.org/show_bug.cgi?id=14392

(cool! the address above was pasted with the touchpad,
so it is really working :-)

Thanks Dmitry!

> 
> Input: atkbd - postpone restoring LED/repeat rate at resume
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> We need to postpone restoring LED state and typematic settings until
> keyboard is finished reconnecting upon resume. Normally driver core
> and PM infrastructure takes care of proper ordering and dependencies,
> but or case actual reconnect is done asynchronously from kseriod.
> So while driver core thinks that keyboard was resumed and it is time
> to let input core run it's resume handlers in reality keyboard is not
> ready yet. The solution is to keep rescheduling work that adjusts LED
> and rate settings until keyboard is fully enabled.
> 
> Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/input/keyboard/atkbd.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> index a45157d..022f3cb 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -574,11 +574,22 @@ static void atkbd_event_work(struct work_struct *work)
>  
>  	mutex_lock(&atkbd->event_mutex);
>  
> -	if (test_and_clear_bit(ATKBD_LED_EVENT_BIT, &atkbd->event_mask))
> -		atkbd_set_leds(atkbd);
> +	if (!atkbd->enabled) {
> +		/*
> +		 * Serio ports are resumed asynchronously so while driver core
> +		 * thinks that device is already fully operational in reality
> +		 * it may not be ready yet. In this case we need to keep
> +		 * rescheduling till reconnect completes.
> +		 */
> +		schedule_delayed_work(&atkbd->event_work,
> +					msecs_to_jiffies(100));
> +	} else {
> +		if (test_and_clear_bit(ATKBD_LED_EVENT_BIT, &atkbd->event_mask))
> +			atkbd_set_leds(atkbd);
>  
> -	if (test_and_clear_bit(ATKBD_REP_EVENT_BIT, &atkbd->event_mask))
> -		atkbd_set_repeat_rate(atkbd);
> +		if (test_and_clear_bit(ATKBD_REP_EVENT_BIT, &atkbd->event_mask))
> +			atkbd_set_repeat_rate(atkbd);
> +	}
>  
>  	mutex_unlock(&atkbd->event_mutex);
>  }
