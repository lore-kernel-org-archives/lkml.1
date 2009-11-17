Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZKQSfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZKQSfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZKQSfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:35:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:39787 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZKQSfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:35:14 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost> <4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org> <20091002084755.GA7382@localhost>
	<20091002173308.6158d734@lxorguk.ukuu.org.uk>
	<m1ske1wgdi.fsf@fess.ebiederm.org>
	<20091003140902.38628d8a@lxorguk.ukuu.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 10:35:07 -0800
In-Reply-To: <20091003140902.38628d8a@lxorguk.ukuu.org.uk> (Alan Cox's message of "Sat\, 3 Oct 2009 14\:09\:02 +0100")
Message-ID: <m13a4df19g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Fri, 02 Oct 2009 16:00:41 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>>
>>
>> I have seen a hang in:
>>   /bin/stty (changing the baud rate)
>>     set_termios
>>       tty_wait_until_sent
>>         tty_chars_in_buffer
>>           ftdi_chars_in_buffer
>>
>> Where the driver wedged for a serial port and no progress
>> was made.
>>
>> This happened to me several times with 2.6.31.  My initial
>> hypothesis was this was a hardware error (as it only happened
>> on single piece of hardware).  With all of the driver problems
>> I suspect it could be a driver bug.
>
> Driver bug I would think - or setup. If you've genuinely got the port
> flow controlled then a request to set the termios after the I/O will wait
> until a signal or carrier change (or indeed forever) quite correctly.

I have finally tracked this one down.  But I'm not certain if there is
anything we can do in software to make things better.

Boiled down.  ftdi_chars_in_buffer is essentially priv->tx_outstanding_bytes.
tx_outstanding_bytes is incremented when an urb request is sent and
tx_outstanding_bytes is decremented when an urb request completes.

It turns out I have a moderately noisy usb line, and so I occasionally
get messages like:

ehci_hcd 0000:00:0a.1: detected XactErr len 0/7 retry 31

Which as best as I can tell result in the urb getting abandoned and
neither completed nor canceled (because we have hit the maximum
retry count and they still don't succeed).

Which appears to result in tx_outstanding_bytes getting stuck at
some positive number.


Is it possible to handle this more gracefully in software?
Is it possible to handle this in a way that makes it clear there
was a hardware error that we could not recover from.  A little
debug level error doesn't usually even make it to the log.

Eric
