Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbYBEVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbYBEVdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760601AbYBEVdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:33:00 -0500
Received: from mail.microway.com ([64.80.227.22]:39557 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758202AbYBEVc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:32:59 -0500
From: Rick Warner <rick@microway.com>
Organization: Microway, Inc.
To: Paul Fulghum <paulkf@microgate.com>, linux-kernel@vger.kernel.org
Subject: Re: serial port regression caused by "Char: tty_ioctl, use wait_event_interruptible_timeout" patch
Date: Tue, 5 Feb 2008 16:32:53 -0500
User-Agent: KMail/1.9.7
References: <200802051402.26816.rick@microway.com> <47A8C4AB.3030301@microgate.com> <47A8CCC0.8020703@microgate.com>
In-Reply-To: <47A8CCC0.8020703@microgate.com>
Message-Id: <200802051632.54058.rick@microway.com>
X-Sanitizer: Advosys mail filter
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modification solved my problem.  Will this change go into mainline, or 
will we need to maintain our own branch of the kernel to keep this working?

Thanks,
Rick

On Tuesday 05 February 2008, Paul Fulghum wrote:
> Paul Fulghum wrote:
> > Instead of reverting the patch can you try modifying
> > this part of the patch:
> >
> > +	if (wait_event_interruptible_timeout(tty->write_wait,
> > +			!tty->driver->chars_in_buffer(tty), timeout))
> > +		return;
> >
> > by changing it to:
> >
> > +	if (wait_event_interruptible_timeout(tty->write_wait,
> > +			!tty->driver->chars_in_buffer(tty), timeout) < 0)
> > +		return;
> >
> > It looks like the patch changed the behavior of
> > tty_wait_until_sent by not calling the driver
> > specific wait_until_sent if a timeout occurs.
>
> I mispoke, the patch changed the behavior by not
> calling the driver specific wait_until_sent if
> the condition is true.
>
> Original behavior:
> call driver->wait_until_sent() on
> timeout or true condition
> (skip for signal)
>
> Patch behavior:
> call driver->wait_until_sent() only
> on timeout (rc == 0)
> (skip for signal or true)
>
> By modifying the patch as described above,
> the original behavior is restored.



-- 
Richard Warner
Lead Systems Integrator
Microway, Inc
(508)732-5517
