Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXFWOHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXFWOHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXFWOHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:07:33 -0400
Received: from users.sycamorenet.com ([12.146.0.130]:3922 "EHLO
	edsel.sycamorenet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754898AbXFWOHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:07:32 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH -rt] Preemption problem in kernel RT Patch
Date: Sat, 23 Jun 2007 10:08:06 -0400
Message-ID: <77B279EC7347F341A6AE891AA6AD68E9314252@ranchero.sycamorenet.com>
In-Reply-To: <1182499431.20203.62.camel@chaos>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -rt] Preemption problem in kernel RT Patch
Thread-Index: Ace0o/ktcDrf+6G3QneWCrysPnD9cgA9+6fw
From: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 23 Jun 2007 14:08:08.0265 (UTC) FILETIME=[ECEBC390:01C7B59F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,


> please fix your mail client to do proper line wraps at column 78.

	Outlook sucks.  I'll install thunderbird this weekend.  sorry.

> Nice, but nevertheless wrong theory.
> 
> This check is part of the RT-Patch and it _is_ entirely correct: 
> Something tries to do a spin_lock() on a lock, which the same task has
> already locked before. That's what the BUG_ON is catching.
>
> There is nothing which can make a task magically the owner of a lock,
> whether preemption is enabled or not.

	Thanks for straightening me out.  I was reading the function 
try_to_take_rt_mutex wrong...  The problem makes more sense now.  The tunnel 
code encapsulates the current packet in a new packet and calls ip_output 
to get it to the destination.  If the routing table is changing(which 
I'm doing when this happens) it could be called recursively.  The tunnel
code tries to handle recursion at the top of ipip_tunnel_xmit:

	if (tunnel->recursion++) {
		tunnel->stat.collisions++;
		goto tx_error;
	} 

	The problem is it tries to take dev->lock which it already owns in 
dev_queue_xmit before the check for recursion.

	Unfortunately, every time I put in debug to see the routing 
changes which cause the bug, it doesn't happen.  I'll certainly try to 
reproduce it with CONFIG_PROVE_LOCKING on, but it won't be till end of next 
week as we have a release going out.

	Thanks for your help,

		Mark Beauchemin





