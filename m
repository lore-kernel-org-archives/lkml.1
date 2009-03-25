Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZCYXk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZCYXk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZCYXkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:40:11 -0400
Received: from gw.goop.org ([64.81.55.164]:34874 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbZCYXkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:40:10 -0400
Message-ID: <49CAC0D6.3040301@goop.org>
Date: Wed, 25 Mar 2009 16:40:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "Alex.Zeffertt" <Alex.Zeffertt@citrix.com>,
       stable@kernel.org
Subject: Re: [PATCH] clockevent: on resume program the next oneshot tick	with
 the next actual event
References: <1237988429-26474-1-git-send-email-Ian.Campbell@citrix.com>	 <49CA678A.30606@goop.org> <1238003202.3691.174.camel@zakaz.uk.xensource.com>
In-Reply-To: <1238003202.3691.174.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> Hmm, yes I think so too. I misread tick_dev_program_event(), it seems
> like it Does The Right Thing and I do see the Xen set_next_event hook
> get called which I thought wasn't getting called earlier.
>
> Turns out the virtual timer IRQ isn't getting reinitialised before
> tick_oneshot_resume runs so we are just missing the interrupt, doh!
>   

While that ordering is a bug, I'm still not sure it completely explains 
what we're seeing here.

In drivers/xen/manage.c:do_suspend() we call clock_was_set(), which has 
the specific effect of causing all the timer events to get retriggered 
on all cpus.  This is necessary because we don't unplug/replug all the 
cpus, and the normal sysdev_resume() timer resume only resumes the 
current cpu (which is cpu 0 in this case).  It also deals with the 
clocksource timebase shifting, as it will over suspend/resume (esp 
suspend/reboot/resume, or suspend/migrate/resume).  Your patch will only 
re-trigger the next cpu0 timer event, and leave the rest hanging without 
a next event.

So the question is why does your patch help?

I'm seeing much worse symptoms on my test machine: the resumed domain is 
just sitting there spinning dead with 100% cpu use.  I don't know if 
this is related or something else.

    J

> Subject: xen: resume interrupts before system devices.
>
> otherwise the first timer interrupt after resume is missed and we never
> get another.
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 0489ea2..5269bb4 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -68,15 +68,15 @@ static int xen_suspend(void *data)
>  	gnttab_resume();
>  	xen_mm_unpin_all();
>  
> -	sysdev_resume();
> -	device_power_up(PMSG_RESUME);
> -
>  	if (!*cancelled) {
>  		xen_irq_resume();
>  		xen_console_resume();
>  		xen_timer_resume();
>  	}
>  
> +	sysdev_resume();
> +	device_power_up(PMSG_RESUME);
> +
>  	return 0;
>  }
>  
>
> Ian.
>
>
>
>   
>>     J
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     
>
>   

