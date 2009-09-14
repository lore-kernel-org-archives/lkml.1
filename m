Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZINW2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZINW2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZINW2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:28:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:25645 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZINW2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xxZu/130cVkDvD4/xX7eS5ZEIDtzeCZ091wDRC6rELwb4I7Tb/R0LOt1JYeYT3kCY4
         h1iCHrQgNh02/gOphtPlZ2bAIinLCY5sIHi6dRUzlKc/zO+5XFLMuVZn0DfDllF+o526
         VxIetaROE0C71uXnTA0iSL0ppNvbn7wGlhwLs=
Date: Tue, 15 Sep 2009 00:28:51 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: e9hack <e9hack@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: Trouble with USB serial driver (ftdi_sio.c) on 2.6.31
Message-ID: <20090914222851.GA14235@localhost>
References: <4AAB8F3F.40403@googlemail.com>
 <20090914164333.GB25381@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914164333.GB25381@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 09:43:33AM -0700, Greg KH wrote:
> On Sat, Sep 12, 2009 at 02:08:31PM +0200, e9hack wrote:
> > I've some trouble with the USB serial driver (ftdi_sio.c for a FT232RL from FTDI). If the 
> > port is opened for the first time, the driver works perfectly. If the port is closed and 
> > open again, it isn't possible to read any data from port. Writing data to the port works. 
> > The FT232RL must be reconnect to get it working again. A reboot without reconnect doesn't 
> > solve this problem. 

I have a similar problem with the same chip after upgrading to 2.6.31,
although the first read after reconnecting the device (usually) works.

> {sigh}  Yes, this driver is a bit messed up in .31, sorry.  We are
> working through it and hope to have a fix in one of the upcoming
> .31-stable releases.

I've spent some time tracking down the problem and I might have some
information that could be useful:

The commit introducing the regression is
335f8514f200e63d689113d29cb7253a5c282967, which changes the way DTR/RTS
are handled on open; they used to be set prior to setting up the read
urb, now they're set after (in dtr_rts()). Depending on when the first
read callback is made, the driver may stop reading from the device.

The problem became more apparent with
557aaa7ffab639d0190b935a041b16ae44606342 which lowered the device
latency timeout to 1ms, but since setting the timeout does not take
effect until the port is closed and re-opened the driver mostly works
the first time after reconnecting the device.

My test setup opens the port and writes some bytes to a FT232RL with
rx and tx connected, and then reads the looped back data. This usually
works the first time after connecting, whereas reads never return any
data after reopening the port.

When it fails, the first read_bulk callback is made before dtr_rts
returns and port.count is incremented. In particular, the read callback
does not process the data as port.count is 0 at the time and the driver
stops reading from the device. Should the callback be made somewhat
later (as with the default 16ms latency timeout), port.count is non-zero
and all is fine.

Disabling dtr_rts() and calling set_mctrl before setting up the read
urb (as it used to be done) fixes the problem and could be used as a
temporary work-around. But I guess the read callback must be made able
to handle a port count of zero?

Let me know if I can help out with implementing or testing any fixes.

Regards,
Johan Hovold

