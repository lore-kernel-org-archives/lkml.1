Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbYBEUxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbYBEUxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbYBEUxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:53:22 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:42794
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYBEUxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:53:21 -0500
Message-ID: <47A8CCC0.8020703@microgate.com>
Date: Tue, 05 Feb 2008 14:53:20 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Rick Warner <rick@microway.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial port regression caused by "Char: tty_ioctl, use wait_event_interruptible_timeout"
 patch
References: <200802051402.26816.rick@microway.com> <47A8C4AB.3030301@microgate.com>
In-Reply-To: <47A8C4AB.3030301@microgate.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum wrote:
> Instead of reverting the patch can you try modifying
> this part of the patch:
> 
> +	if (wait_event_interruptible_timeout(tty->write_wait,
> +			!tty->driver->chars_in_buffer(tty), timeout))
> +		return;
> 
> by changing it to:
> 
> +	if (wait_event_interruptible_timeout(tty->write_wait,
> +			!tty->driver->chars_in_buffer(tty), timeout) < 0)
> +		return;
> 
> It looks like the patch changed the behavior of
> tty_wait_until_sent by not calling the driver
> specific wait_until_sent if a timeout occurs.

I mispoke, the patch changed the behavior by not
calling the driver specific wait_until_sent if
the condition is true.

Original behavior:
call driver->wait_until_sent() on
timeout or true condition
(skip for signal)

Patch behavior:
call driver->wait_until_sent() only
on timeout (rc == 0)
(skip for signal or true)

By modifying the patch as described above,
the original behavior is restored.

-- 
Paul Fulghum
Microgate Systems, Ltd.
