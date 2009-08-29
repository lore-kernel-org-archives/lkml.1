Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZH2Mzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZH2Mzq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 08:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZH2Mzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 08:55:45 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45182 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZH2Mzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 08:55:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1, v2] usb-use-kfifo-to-buffer-usb-generic-serial-writes.patch
Date: Sat, 29 Aug 2009 14:56:57 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: David VomLehn <dvomlehn@cisco.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com
References: <20090827013454.GA23601@cuplxvomd02.corp.sa.net> <20090828194810.GA10728@cuplxvomd02.corp.sa.net> <20090828210106.51b1182a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090828210106.51b1182a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908291456.59526.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 28. August 2009 22:01:06 schrieb Alan Cox:
> > It seems propagating errors back to user space appears somewhat
> > problematic, but this is true independent of whether a FIFO is used.
>
> The best I can think of would be to implement socket like behaviour from
> networking. That is
>
> - at the start of a write check for an asynchronous error event
> - if there is one, clear the event and report it
> - if not do the normal write
>
> and keep a single 's**t happened' variable to record such matters.

This looks like an excellent suggestion.

> > > user space writes to device
> > > user space waits for answer
> > >
> > > kernel transfers 1. buffer
> > > system suspension - 2. buffer cannot be transfered,
> > > 	as usb_serial_generic_write_start gets -EPERM
> > > system resumption - 2. buffer is never transmitted,
> > > 	user space times out and reports an error
>
> You would need to handle this in the shutdown - and beyond that you need

Why in shutdown?

> to wait for any FIFO in the device before you power it down.

This is not about powering down. If you power down a usb serial
device this will disconnect it unless you implement reset_resume()
which would therefore be another code path.
This problem arises in STR only.

> Its not really fixable as it isn't transactional and you have no idea if
> the state of the other device also changed. Consider
>
> ATD foo
> oops flight time
> suspend
>
> Arrive in Australia
> resume
> ATD foo
>
> Ouch that was an expensive data call...

As soon as you make the next write the buffered data will go out.
So if we don't know the optimal solution, we can still be consistent,
which would be to start IO after resumption in all cases.

	Regards
		Oliver

