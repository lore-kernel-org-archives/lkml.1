Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbXD0GF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbXD0GF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbXD0GF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:05:28 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:24701 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbXD0GFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:05:22 -0400
Message-ID: <46319297.905@bigpond.net.au>
Date: Fri, 27 Apr 2007 16:05:11 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
References: <463166C2.6060106@bigpond.net.au> <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05ps.mx.bigpond.com from [138.130.231.4] using ID pwil3058@bigpond.net.au at Fri, 27 Apr 2007 06:05:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 27 Apr 2007, Peter Williams wrote:
>> The 2.6.21 kernel is hanging during the post boot phase where various daemons
>> are being started (not always the same daemon unfortunately).
>>
>> This problem was not present in 2.6.21-rc7 and there is no oops or other
>> unusual output in the system log at the time the hang occurs.
> 
> Can you use "git bisect" to narrow it down a bit more? It's only 125 
> commits, so bisecting even just three or four kernels will narrow it down 
> to a handful.

As the changes became, smaller the builds became quicker :-) and after 7 
iterations we have:


author	Neil Horman <nhorman@tuxdriver.com>
	Fri, 20 Apr 2007 13:54:58 +0000 (09:54 -0400)
committer	Jeff Garzik <jeff@garzik.org>
	Tue, 24 Apr 2007 16:43:07 +0000 (12:43 -0400)
commit	b748d9e3b80dc7e6ce6bf7399f57964b99a4104c
tree	887909e1f735bb444ef0e3e370f34401fa6eee02	tree | snapshot
parent	d91c088b39e3c66d309938de858775bb90fd1ead	commit | diff
sis900: Allocate rx replacement buffer before rx operation

The sis900 driver appears to have a bug in which the receive routine
passes the skbuff holding the received frame to the network stack before
refilling the buffer in the rx ring.  If a new skbuff cannot be 
allocated, the
driver simply leaves a hole in the rx ring, which causes the driver to stop
receiving frames and become non-recoverable without an rmmod/insmod 
according to
reporters.  This patch reverses that order, attempting to allocate a 
replacement
buffer first, and receiving the new frame only if one can be allocated. 
  If no
skbuff can be allocated, the current skbuf in the rx ring is recycled, 
dropping
the current frame, but keeping the NIC operational.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
