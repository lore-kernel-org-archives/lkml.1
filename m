Return-Path: <linux-kernel-owner+w=401wt.eu-S1030361AbXCLPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361AbXCLPJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXCLPJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:09:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41735 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030361AbXCLPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:09:04 -0400
Date: Mon, 12 Mar 2007 11:09:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45F5188D.4030106@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703121100460.2489-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Jiri Slaby wrote:

> Bisecting figured out the culprit:
> Commit: 17230acdc71137622ca7dfd789b3944c75d39404
> Author: Alan Stern <stern@rowland.harvard.edu> Mon, 19 Feb 2007 15:52:45 -0500
> 
>      UHCI: Eliminate asynchronous skeleton Queue Headers
> 
>      This patch (as856) attempts to improve the performance of uhci-hcd by
>      removing the asynchronous skeleton Queue Headers.  They don't contain
>      any useful information but the controller has to read through them at
>      least once every millisecond, incurring a non-zero DMA overhead.
> 
>      Now all the asynchronous queues are combined, along with the period-1
>      interrupt queue, into a single list with a single skeleton QH.  The
>      start of the low-speed control, full-speed control, and bulk sublists
>      is determined by linear search.  Since there should rarely be more
>      than a couple of QHs in the list, the searches should incur a much
>      smaller total load than keeping the skeleton QHs.
> 
>      Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>      Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> -mm minus (only) this one is OK.

Okay, here's how to track this down.  I assume that even after the
keyboard stops working you can access the machine via a network
connection.

So turn on CONFIG_USB_DEBUG, CONFIG_USB_MON, and CONFIG_DEBUG_FS.  Then
modprobe uhci-hcd with debug=2, and mount a debugfs filesystem.  Before
using the keyboard, start a cat process to capture the usbmon output for
the keyboard's bus (see the instructions for usbmon in
Documentation/usb/usbmon.txt).

After hanging the keyboard, get a copy of the appropriate controller's 
file in the uhci/ subdirectory of the debugfs filesystem.  Post it along 
with the usbmon log, and I'll try to figure out what happened.

Alan Stern

