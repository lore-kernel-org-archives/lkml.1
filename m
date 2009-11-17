Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZKQS4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZKQS4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZKQS4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:56:39 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41890 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZKQS4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:56:38 -0500
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Johan Hovold <jhovold@gmail.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
References: <20090924154023.GA27480@localhost>
	<20091003140902.38628d8a@lxorguk.ukuu.org.uk>
	<m13a4df19g.fsf@fess.ebiederm.org>
	<200911171941.34781.oliver@neukum.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 10:56:40 -0800
In-Reply-To: <200911171941.34781.oliver@neukum.org> (Oliver Neukum's message of "Tue\, 17 Nov 2009 19\:41\:34 +0100")
Message-ID: <m1pr7hdlp3.fsf@fess.ebiederm.org>
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

Oliver Neukum <oliver@neukum.org> writes:

> Am Dienstag, 17. November 2009 19:35:07 schrieb Eric W. Biederman:
>> Boiled down.  ftdi_chars_in_buffer is essentially
>>  priv->tx_outstanding_bytes. tx_outstanding_bytes is incremented when an
>>  urb request is sent and tx_outstanding_bytes is decremented when an urb
>>  request completes.
>> 
>> It turns out I have a moderately noisy usb line, and so I occasionally
>> get messages like:
>> 
>> ehci_hcd 0000:00:0a.1: detected XactErr len 0/7 retry 31
>> 
>> Which as best as I can tell result in the urb getting abandoned and
>> neither completed nor canceled (because we have hit the maximum
>> retry count and they still don't succeed).
>
> The URB should be finished with an error code in urb->status.
> ftdi_write_bulk_callback() does decrement the counter even in
> the error case.
>
>> Which appears to result in tx_outstanding_bytes getting stuck at
>> some positive number.
>
> Do you see this message
>
>  	if (status) {
> 		dbg("nonzero write bulk status received: %d", status);
> 		return;
> 	}
>
> if you enable debugging output?

I will have to give that a try.  The problem isn't that easy to reproduce.
But I do have a 100% correlation between urb retry counts and hangs
in tty_wait_until_sent.

Eric
