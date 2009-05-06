Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZEFTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZEFTZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZEFTY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:24:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35473 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755022AbZEFTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:24:57 -0400
Date: Wed, 6 May 2009 15:24:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jason Wessel <jason.wessel@windriver.com>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
In-Reply-To: <200905061917.09454.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Oliver Neukum wrote:

> Something a bit a like this:
> 
> commit a02639fe7d3f9788263305cff0669eac91f54002
> Author: Oliver Neukum <oneukum@linux-d698.(none)>
> Date:   Wed May 6 19:14:30 2009 +0200
> 
>     terrible implementation of usb serial write buffering

For algorithm discussions like this, I find reading code rather
difficult.  English or pseudo-code presentations are a lot more
intelligible.

A little thought yielded the following algorithm.  It assumes there is
a fixed set of URBs allocated, unlike what you have done.  Does it make
sense to take this approach?

Let N be the total number of URBs allocated, each capable of holding up 
to B bytes.  Let NIF be the number of URBs in flight at any time, so 
the number of available URBs is N - NIF.  The number of available bytes 
might be < (N - NIF)*B because the next URB might be partially full.

P is an adjustable parameter of the algorithm.  For simplicity you can
take P = 1, but increasing P (any value below N is okay) would yield
reduced latency at the cost of more partially-filled URB submissions
(so possibly reduced throughput).

    Write routine:
	Copy bytes into the available URB buffers, submitting URBs as 
	they get filled.  At the end, if the next URB is partially full 
	then submit it only if NIF < P.

    Completion routine:
	If the next URB to send is partially filled, submit it.

    write_room routine:
	Return the actual number of bytes remaining in the available 
	URBs, but no more than (N-P)*B.

How does that sound?  Converting \n to \r\n will add some complication 
but not too much.  

Allocating URBs on the fly adds a lot of complication.  There has to be 
a minimum number of pre-allocated URBs; otherwise write_room could 
never return a positive value.  If you allocate additional URBs 
later on, when would you free them?

Alan Stern

