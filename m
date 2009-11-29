Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZK3UGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZK3UGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZK3UGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:06:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43976 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZK3UGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:06:04 -0500
Date: Sun, 29 Nov 2009 17:44:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bluetooth cf slow (10KB/sec), lots of dmesg spam
Message-ID: <20091129164450.GA1438@ucw.cz>
References: <20091129155801.GA1634@ucw.cz> <20091130153915.0a6910e3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130153915.0a6910e3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I believe the problem is 115200 bitrate between system and CF serial;
> 
> and lack of flow control I assume ?

I guess so. (But flow control can be hard for bluetooth, I guess. Data
are coming from the air...)

> > I did setserial baud_base 921600,  but that does not seem to speed it
> > up. Do I need to do some special magic to enable high speed?
> 
> Just set the baud rate to 921600. You may need to write an app to do this
> directly via the TERMIOS2 ioctl because it seems three years ago is a bit
> quick for the glibc maintainers to keep up.
> 
> Basically set the baud to BOTHER, set the ispeed = ospeed = 921600 and
> the kernel will do its best to give you your request

hciattach seems to do this:

...
open("/dev/ttyBT", O_RDWR|O_NOCTTY)     = 3
ioctl(3, TCFLSH, 0x2)                   = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_START or TCSETS, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_START or TCSETS, {B921600 -opost -isig -icanon -echo ...}) = 0

...set 921K using TCSETS/B921600... and kernel says ok, but ...

ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 -opost -isig -icanon -echo ...}) = 0

...we are still at 115200... I wonder if 921600 is the right speed to
use after all? Any other speeds I should try? (and can 400MHz arm
handle 921K on serial line?)

...when I was setting 921600 baud_base, I basically broke it so that
it used 115200, right? I guess I should play a bit more...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
