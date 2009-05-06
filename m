Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbZEFPSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbZEFPSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760387AbZEFPSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:18:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35093 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759451AbZEFPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:18:08 -0400
Date: Wed, 6 May 2009 11:18:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
In-Reply-To: <1241575205-12199-6-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Jason Wessel wrote:

> The problem that this patch tries to solve is that data is lost
> because there are too many outstanding transmit urb's.
> 
> The question is what is the right way to force the controller to catch
> up, and ideally let the kernel do some other things in the mean time?

What do standard serial port drivers do?

> This patch takes the route of forcibly polling the hcd device to drain
> the urb queue and initiate the bulk write call backs.
> 
> NOTE this patch is not signed off, it is a question of what is the
> right way to do this?

This patch is highly questionable.

Is the idea to force the HCD to search for completed URBs before the
host controller has issued a completion interrupt?  Wouldn't it be
better instead to use more URBs?

Besides, why should there be too many outstanding transmit URBs?  A
normal serial debugging port running at 115200 baud can transmit no
more than 12 bytes per ms.  You should be able to surpass that using
only three URBs!  In fact, if you buffer up to 8 bytes per URB then
with only two URBs you could send 64 bytes per ms, which is equivalent
to 640000 baud.  Do you really need to go more than (say) ten times
faster than that?

Even if people do agree this is a reasonable thing to do (which I
doubt), the poll_hcd_irq() code doesn't belong hidden away in
serial/usb_debug.c.  It belongs in core/hcd.c.

Alan Stern

