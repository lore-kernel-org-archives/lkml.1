Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbYETVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbYETVBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbYETVBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:01:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52524 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760200AbYETVBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:01:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/3, RFC] watchdog dev BKL pushdown
Date: Tue, 20 May 2008 23:00:34 +0200
User-Agent: KMail/1.9.9
Cc: Wim Van Sebroeck <wim@iguana.be>, Christoph Hellwig <hch@infradead.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
References: <13762.1211142411@vena.lwn.net> <20080520154711.GD2724@infomag.infomag.iguana.be> <20080520193135.432acc90@core>
In-Reply-To: <20080520193135.432acc90@core>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805202300.35591.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX187EdP6NrkO4vwH3tpkXIxCYqNnf0mi7mkIa9U
 6jTm8ajBgqz2khWnglVJn9RMb6ypK/03HX985mMxhPZ9Y2hcHO
 q7J7Oi8Q39JhxWy7wZAvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Alan Cox wrote:
> Current patch (& example conversions) below.

Very nice code!

> +       if (w->ops->ioctl) {
> +               r = w->ops->ioctl(w, cmd, arg);
> +               if (r != -ENOIOCTLCMD)
> +                       return r;
> +       }

Are you planning this as a transitional method for
converting drivers, or are you aware of any driver that
actually needs its own ioctl method?

> +static const struct file_operations watchdog_fops = {
> +       .owner          = THIS_MODULE,
> +       .llseek         = no_llseek,
> +       .write          = watchdog_write,
> +       .unlocked_ioctl = watchdog_ioctl,
> +       .open           = watchdog_open,
> +       .release        = watchdog_release,
> +};

All the ioctl numbers are compatible, so it would be good
to register the watchdog ioctl function as compat_ioctl
as well. Once all drivers are using the common abstraction,
we can also kill their COMPATIBLE_IOCTL() entries in
fs/compat_ioctl.c.

> --- /dev/null
> +++ b/drivers/watchdog/watchdog.h

There are a few watchdog drivers living outside of drivers/watchdog/,
I could find:

* arch/um/drivers/harddog_kern.c
* drivers/char/ipmi/ipmi_watchdog.c
* drivers/rtc/rtc-m41t80.c
* drivers/s390/char/vmwatchdog.c
* drivers/sbus/char/cpwatchdog.c
* drivers/sbus/char/riowatchdog.c

In order to conver those to the new model, you either have to
move them to the right place, or move the new declarations to
include/linux/watchdog.h.

	Arnd <><
