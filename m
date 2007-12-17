Return-Path: <linux-kernel-owner+w=401wt.eu-S935854AbXLQLWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935854AbXLQLWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764192AbXLQLVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:21:54 -0500
Received: from mx33.mail.ru ([194.67.23.194]:6536 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbXLQLVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:21:53 -0500
Date: Mon, 17 Dec 2007 14:24:16 +0300
From: Anton Vorontsov <cbou@mail.ru>
To: Andres Salomon <dilinger@queued.net>
Cc: cbouatmailru@gmail.com, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071217112416.GA25948@localhost.localdomain>
Reply-To: cbou@mail.ru
References: <20071216212443.4a1fff3d@ephemeral> <1197858984.3798.201.camel@shinybook.infradead.org> <20071217055123.GA2274@zarina> <20071217024139.2f81e36d@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20071217024139.2f81e36d@ephemeral>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 02:41:39AM -0500, Andres Salomon wrote:
[...]
> > > On Sun, 2007-12-16 at 21:24 -0500, Andres Salomon wrote:
> > > > This API has the power_supply drivers device their own device_attribute
> > > > list; I find this to be a lot more flexible and cleaner.  
> > 
> > I don't see how this is more flexible and cleaner. See below.
> > 
> > > > For example,
> > > > rather than having a function with a huge switch statement (as olpc_battery
> > > > currently has), we have separate callback functions.
> > 
> > Is this an improvement? Look into ds2760_battery.c. I scared to
> > imagine what it will look like after conversion.
> 
> Why?  It would not look bad after conversion.  Basically:
> 
> static ssize_t ds2760_battery_get_status(struct device *dev,
>                 struct device_attribute *attr, char *buf)
> {
> 	struct ds2760_device_info *di = to_ds2760_device_info(psy);
> 	return power_supply_status_str(di->charge_status, buf);
> }
> static ssize_t ds2760_battery_get_voltage_now(struct device *dev,
>                 struct device_attribute *attr, char *buf)
> {
> 	struct ds2760_device_info *di = to_ds2760_device_info(psy);
> 	ds2760_battery_read_status(di);
> 	return sprintf(buf, "%d\n", di->voltage_uV);
> }
> 
> ....an so on.
> 
> If I wanted to get really clever, I could do:
> 
> #define DS2760_CALLBACK(name, fmt, var)                       \
> static ssize_t ds2760_battery_get_##name(struct device *dev,  \
> 		struct device_attribute *attr, char *buf)     \
> {                                                             \
> 	struct ds2760_device_info *di = to_ds2760_device_info(psy); \
>         ds2760_battery_read_status(di);                       \
> 	return sprintf(buf, fmt, var);                        \
> }
> 
> DS2760_CALLBACK(voltage_now, "%d\n", di->voltage_uV)
> DS2760_CALLBACK(current_now, "%d\n", di->current_uA)
> 
> etc.. but, I'm not trying to compress lines of code, I'm trying
> to ensure things are readable.

Hehe, look: http://lkml.org/lkml/2007/4/11/397

These macros are indeed what I've tried to avoid, dozen open-coded
similar functions not a good option either. I also tried to avoid
"function per property" stuff...

[lots of sense snipped]

I see your point now. Basically, now I'm encourage to think just one
more time: is there third (better) option in addition to current and
this? I still hope there is some not obvious, but elegant solution.
If there isn't, I'm ready to surrender and will help with everything
I can.


Thanks!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
