Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbYETJVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbYETJVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758401AbYETJVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:21:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12639 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbYETJVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:21:09 -0400
Date: Tue, 20 May 2008 11:20:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       mgreer@mvista.com, rtc-linux@googlegroups.com,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, ab@mycable.de,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [i2c] [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
Message-ID: <20080520112040.08c809a1@hyperion.delvare>
In-Reply-To: <200805100936.52057.david-b@pacbell.net>
References: <200805070120.03821.david-b@pacbell.net>
	<Pine.LNX.4.55.0805100301100.10552@cliff.in.clinika.pl>
	<20080510085340.29c26aef@hyperion.delvare>
	<200805100936.52057.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, 10 May 2008 09:36:50 -0700, David Brownell wrote:
> > It's not that easy. There are some drivers which are both in-tree and
> > out-of-tree, for which such a change means adding ifdefs.
> 
> Actually, I thought it *WAS* that easy.  See the appended patch,
> which goes on top of the various doc and (mostly SMBus) fault
> handling patches I've sent ... the old names are still available
> (only needed by out-of-tree drivers), but marked as __deprecated.
> So:  no #ifdefs required.

No #ifdefs required until we drop the deprecated helpers, which will
inevitably happen, even if only in several years. So in practice,
#ifdefs would be required for out-of-tree drivers (or semi-out-of-tree
drivers such as v4l/dvb drivers).

> I agree it's not worth while for *all* the SMBus functions that
> use names-made-up-for-Linux.  But for the two which are really
> badly misnamed (after *different* SMBus operations), I suggest
> fixing would be a reasonable thing.

That's tempting, but see below.

> > And there is 
> > i2c-dev.h (the user-space one) which has similar functions,
> 
> That's problematic in its own right though.  Not only that
> the *kernel* file Documentation/i2c/dev-interface referring
> to those functions, which are unavailable from the header
> provided by the kernel.  Or that there's no relationship
> between the kernel and userspace files of the same name.
> But also that those functions are actually a bit too large
> to be appropriate as inlines, even once you manage to track
> it down (as part of a "tools" package, not a "library").

I agree that the i2c-dev.h mess needs some love and this is on my to-do
list for this year. That's not necessarily related to the problem at
hand though.

> > if we 
> > rename only the kernel variants, there will be some confusion. But if
> > we rename also the user-space variants, then it's up to 2.4 kernel
> > users to have different names for kernel-space and user-space functions.
> 
> True, but that would be a question for a "libsmbus" or somesuch
> to deal with.  Not a kernel issue.

Whether it's in the kernel or outside the kernel is irrelevant. The
developers are likely to be the same, and the person who will have to
deal with the confusion is the same (i.e.: me.)

> ===========
> Two of the SMBus operations are using confusingly inappropriate names:
> 
>   i2c_smbus_read_byte() does not execute the SMBus "Read Byte" protocol
>   	... it implements the SMBus "Receive Byte" protocol instead!!
> 
>   i2c_smbus_write_byte() does not execute the SMBus "Write Byte" protocol
>   	... it implements the SMBus "Send Byte" protocol instead!!
> 
> This patch changes the names of those functions, so they no longer
> use names of different operations (which they do not implement).
> 
> ---
>  Documentation/i2c/chips/max6875   |    4 ++--
>  Documentation/i2c/smbus-protocol  |   12 +++++-------
>  Documentation/i2c/writing-clients |    4 ++--
>  drivers/gpio/pcf857x.c            |    8 ++++----
>  drivers/hwmon/ds1621.c            |    2 +-
>  drivers/hwmon/lm90.c              |    2 +-
>  drivers/i2c/chips/eeprom.c        |   10 +++++-----
>  drivers/i2c/chips/max6875.c       |    2 +-
>  drivers/i2c/chips/pcf8574.c       |    4 ++--
>  drivers/i2c/chips/pcf8591.c       |   10 +++++-----
>  drivers/i2c/chips/tsl2550.c       |   16 ++++++++--------
>  drivers/i2c/i2c-core.c            |   12 ++++++------
>  drivers/media/video/saa7110.c     |    2 +-
>  drivers/media/video/saa7185.c     |    2 +-
>  drivers/media/video/tda9840.c     |    8 ++++----
>  drivers/media/video/tea6415c.c    |    4 ++--
>  drivers/media/video/tea6420.c     |    4 ++--
>  drivers/w1/masters/ds2482.c       |   10 +++++-----
>  include/linux/i2c.h               |   20 ++++++++++++++++++--
>  19 files changed, 75 insertions(+), 61 deletions(-)

I'm not going to take this, sorry. I still believe that it will cause
more trouble than is worth at this point in time. For example, after
applying your patch, we'd have functionality defines no longer matching
the SMBus helper names (I2C_FUNC_SMBUS_READ_BYTE,
I2C_FUNC_SMBUS_WRITE_BYTE). And you can't easily rename these because
they are part of the i2c-dev API.

I'm not saying that the suggested cleanup shouldn't be done, nor that
it cannot be done. All I'm saying is that it will be a lot of work if
we do it properly, and potentially a lot of trouble for many developers
out there, all for a marginal benefit, and I think that our time can be
better used to solve other, more important problems. And you've done a
very good job at documenting the current implementation, so I hope that
it is clear enough for everyone now.

Thanks,
-- 
Jean Delvare
