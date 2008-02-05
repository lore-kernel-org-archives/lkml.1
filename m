Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbYBEUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbYBEUTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbYBEUSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:18:53 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:52615
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427AbYBEUSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:18:52 -0500
Message-ID: <47A8C4AB.3030301@microgate.com>
Date: Tue, 05 Feb 2008 14:18:51 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Rick Warner <rick@microway.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial port regression caused by "Char: tty_ioctl, use wait_event_interruptible_timeout"
 patch
References: <200802051402.26816.rick@microway.com>
In-Reply-To: <200802051402.26816.rick@microway.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Warner wrote:
> I narrowed down the problem doing a binary search on git snapshots between .22 
> and .23, and found the breakage between git6 and git7.  Further isolating it 
> found the patch mentioned in the subject to be the cause.  I reversed the 
> patch in the .23 source and it now works properly.
> 
> Should the code be reverted back as I did, or is there something I should 
> change in our userspace code that reads from the serial port to correct it 
> instead?

Instead of reverting the patch can you try modifying
this part of the patch:

+	if (wait_event_interruptible_timeout(tty->write_wait,
+			!tty->driver->chars_in_buffer(tty), timeout))
+		return;

by changing it to:

+	if (wait_event_interruptible_timeout(tty->write_wait,
+			!tty->driver->chars_in_buffer(tty), timeout) < 0)
+		return;

It looks like the patch changed the behavior of
tty_wait_until_sent by not calling the driver
specific wait_until_sent if a timeout occurs.

-- 
Paul Fulghum
Microgate Systems, Ltd.
