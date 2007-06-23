Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbXFWO0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbXFWO0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbXFWO0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:26:14 -0400
Received: from www.osadl.org ([213.239.205.134]:52032 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756835AbXFWO0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:26:13 -0400
Subject: RE: [PATCH -rt] Preemption problem in kernel RT Patch
From: Thomas Gleixner <tglx@linutronix.de>
To: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       David Miller <davem@davemloft.net>
In-Reply-To: <77B279EC7347F341A6AE891AA6AD68E9314252@ranchero.sycamorenet.com>
References: <77B279EC7347F341A6AE891AA6AD68E9314252@ranchero.sycamorenet.com>
Content-Type: text/plain
Date: Sat, 23 Jun 2007 16:26:06 +0200
Message-Id: <1182608766.20203.208.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Sat, 2007-06-23 at 10:08 -0400, Beauchemin, Mark wrote:
> 	Thanks for straightening me out.  I was reading the function 
> try_to_take_rt_mutex wrong...  The problem makes more sense now.  The tunnel 
> code encapsulates the current packet in a new packet and calls ip_output 
> to get it to the destination.  If the routing table is changing(which 
> I'm doing when this happens) it could be called recursively.  The tunnel
> code tries to handle recursion at the top of ipip_tunnel_xmit:
> 
> 	if (tunnel->recursion++) {
> 		tunnel->stat.collisions++;
> 		goto tx_error;
> 	} 
> 
> 	The problem is it tries to take dev->lock which it already owns in 
> dev_queue_xmit before the check for recursion.

Hmm, this sounds scary. On a vanilla kernel (with debugging disabled),
this code will simply deadlock.

Do you have a test case? If you need more help, please contact the
netdev folks (netdev@vger.kernel.org).

> 	Unfortunately, every time I put in debug to see the routing 
> changes which cause the bug, it doesn't happen.  I'll certainly try to 
> reproduce it with CONFIG_PROVE_LOCKING on, but it won't be till end of next 
> week as we have a release going out.

Well, you won't see much more than you already debugged. You see the
place where the lock was taken and the call trace of the function in the
same way you have seen it with the BUG_ON().

	tglx


