Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZIQORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZIQORP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZIQORO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:17:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:61754 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZIQORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:17:12 -0400
Message-ID: <4AB244E0.1060109@windriver.com>
Date: Thu, 17 Sep 2009 09:17:04 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
References: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org><4AB1B860.4080105@windriver.com><20090917101441.478b3e9b@lxorguk.ukuu.org.uk><4AB22892.8000308@windriver.com><20090917140828.21341c05@lxorguk.ukuu.org.uk> <20090917141913.47f9451b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090917141913.47f9451b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 14:17:04.0563 (UTC) FILETIME=[88121830:01CA37A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 17 Sep 2009 14:08:28 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>   
>>> -			memset(&dummy, 0, sizeof(struct ktermios));
>>> -			tty->termios = termios;
>>> +			tty->termios = &usb_serial_tty_driver->init_termios;
>>>       
>> That will corrupt the master one which is a reference used for many ports.
>>
>>     

I agree. 

>> You need the serial_install stuff or something similar resurrecting to do
>> this properly.
>>     
>
> Here's a suggestion on how to do it.
>
> Add a tty->ops->init_termios()
>
> Make tty_init_termios() read
>
>        if (tp == NULL) {
>                 tp = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
>                 if (tp == NULL)
>                         return -ENOMEM;
>                 memcpy(tp, &tty->driver->init_termios,
>                                                 sizeof(struct ktermios));
> 		if (tty->ops->init_termios)
> 			tty->ops->init_termios(tty);
>                 tty->driver->termios[idx] = tp;
>         }
>
> Thats a good deal cleaner than the ->install override in the USB patches
> Greg inherited and will be usable for cleaning up USB stuff too.
>
>   
Sure we can add another layer of init_termios callbacks, but where is
the right place to store the termios per console?

Should the "struct console co*" get a new member for the baud, or should
it get a termios?  The source of the problem is how to inherit the
termios setting from the first user (the console code in this case).

Before making several more implementations it is probably worth
discussing few more of the details.  In the current code the ->install
override has the opportunity to apply the fixup by copying something
from a "struct console co* termios" if one existed.

Certainly you could do the same thing with the proposed call back you
mentioned, but then the serial_install() needs to be removed from the
usb code and the power management setup would need to find a new home...
or a copy of the new call back would need to go into the
serial_install() as well.

Jason.
