Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbZKZG1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbZKZG1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 01:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZKZG07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 01:26:59 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:34079 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbZKZG06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 01:26:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=jWrBbLL/9AfJn/2Xb7x/0fgyWKAPnhibfwvT3wH0z6tI+mut/DHvkJbja+BpDdQGwX
         PDsPoooxS1jyGbzkRqtJ33v0B3trlE6Njo/gcO5Di+84XLUy9PRbuF+gcobIQMpIHqj/
         +5BTY0VDbBByQKgFnd1rOdfEQla83J0YAc1k8=
Subject: Re: [PATCH v2] [loongson] yeeloong2f: add platform specific support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Richard Purdie <rpurdie@rpsys.net>, lm-sensors@lm-sensors.org,
       linux-input@vger.kernel.org, linux-laptop@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, sfr@linuxcare.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091126060854.GK23244@core.coreip.homeip.net>
References: <9ef5a0038ec5e9b584be8c960693c434a323620a.1258803311.git.wuzhangjin@gmail.com>
	 <9ef5a0038ec5e9b584be8c960693c434a323620a.1258803311.git.wuzhangjin@gmail.com>
	 <20091126041047.GC23244@core.coreip.homeip.net>
	 <1259215215.4989.38.camel@falcon.domain.org>
	 <20091126060854.GK23244@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 26 Nov 2009 14:26:44 +0800
Message-ID: <1259216804.4989.54.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 22:08 -0800, Dmitry Torokhov wrote:
[...]
> > > > +	/* SW_VIDEOOUT_INSERT? not included in hald-addon-input! */
> > > > +	{KE_KEY, EVENT_CRT_DETECT, KEY_PROG1},
> > 
> > any available event for reporting the inserted CRT in hald-addon-input?
> 
> Hmm.. not really. Again, does not seem to be related to input subsystem
> but video one.

It's time to remove it from keymap now, I have done some job in the
video_output subdriver for this event ;)

> > > > +	/* Seems battery subdriver should report it */
> > > > +	{KE_KEY, EVENT_OVERTEMP, KEY_PROG2},
> > > 
> > > Does not seem to be an input event?
> > > 
> > 
> > It is not an input event, Will remove it from the keymap table.
> >  
> > BTW: how can we handle this stuff(overtemp...)? lm-sensors? Perhaps
> > temp1_max_alarm or temp1_crit_alarm?
> > 
> 
> Not really sure... HWMON list is a good place to ask I think.

okay, will split the hwmon driver out and send it to lm-sensors mailing
list.

> 
> > > > +	/*{KE_KEY, EVENT_AC_BAT, KEY_BATTERY},*/
> > > > +	{KE_KEY, EVENT_CAMERA, KEY_CAMERA},	/* Fn + ESC */
> > > > +	{KE_KEY, EVENT_SLEEP, KEY_SLEEP},	/* Fn + F1 */
> > > > +	/* Seems not clear? not included in hald-addon-input! */
> > > > +	{KE_KEY, EVENT_BLACK_SCREEN, KEY_PROG3},	/* Fn + F2 */
> > > 
> > > Do you mean "lock screen"?
> > 
> > not lock, close the backlight of the display, any available event here?
> 
> What is it then? A switch that turns off backlight? What is the expected
> reaction to it?
> 

Yes, a switch for turning off/on the backlight, seems no need to report
this key to the users, will remove it too.

> > > > +	if (!yeeloong_hotkey_dev)
> > > > +		return -ENOMEM;
> > > 
> > > Error unwinding?
> > 
> > Sorry, not clear what do you mean here?
> 
> If you just return you will have the SCI stuff that you did a few lines
> above installed... I am concerned whether it is a good idea.
> 

get it, thanks!

I have checked the return value in the module init function:

[...]

yeeloong_init()
{
	[...]
        ret = yeeloong_hotkey_init(&yeeloong_pdev->dev);
        if (ret) {
                yeeloong_hotkey_exit();
                printk(KERN_INFO "Fail init yeeloong hotkey driver.\n");
                return ret;
        }
	[...]

}

[...]

static void yeeloong_hotkey_exit(void)
{
        /* free irq */
        remove_irq(SCI_IRQ_NUM, &sci_irqaction);
	 ...
}

but as a standalone driver, It's better to do something as following:

if (!yeeloong_hotkey_dev) {
	yeeloong_hotkey_exit();
	return -ENOMEM;
}

Thanks & Regards!
	Wu Zhangjin

