Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbXISHLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbXISHLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 03:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXISHLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 03:11:15 -0400
Received: from 66-126-254-34.unm.net ([66.126.254.34]:60943 "EHLO
	nxmail.netxen.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752734AbXISHLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 03:11:15 -0400
X-Greylist: delayed 1650 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 03:11:15 EDT
Message-ID: <46F0C51B.2070205@netxen.com>
Date: Wed, 19 Sep 2007 12:13:39 +0530
From: Dhananjay Phadke <dhananjay@netxen.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070418)
MIME-Version: 1.0
To: Vernon Mauery <vernux@us.ibm.com>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NetXen driver causing slab corruption in -RT kernels
References: <200709181117.59041.vernux@us.ibm.com>
In-Reply-To: <200709181117.59041.vernux@us.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That "00 0e 1e ..." is netxen's mac address, so sounds like the NIC is
dumping a frame in the skb already freed (and poisoned) by the stack.
I suppose -RT kernels preempt the softirq, giving a chance for this race.

The netxen driver doesn't seem to clear the mapped address of the skb in
rx descriptor, instead it replaces it with mapped address of newly
allocated skb. Also, the rx ring is replenished in bursts (at the end of
poll routine), this can help the race if preempted in between.

I am currently reworking the rx handling, hopefully it will fix this.

Thanks for reporting in detail.

-Dhananjay


Vernon Mauery wrote:
> In doing some stress testing of the NetXen driver, I found that my machine was 
> dying in all sorts of weird ways.  I saw several different crashes, BUG 
> messages in the TCP stack and some assert messages in the TCP stack as well.  
> I really didn't think that there could be six different bugs all at once in 
> the TCP/IP stack, so I started looking at possible memory corruption.
> 
> I first saw this on 2.6.16-rt22 with a backported netxen driver from 2.6.22.  
> I figured I should try the latest kernel, so I tried it on 2.6.23-rc6-git7 
> but could not trigger the slab corruption messages with CONFIG_DEBUG_SLAB, so 
> I figured the race must only exist in the -RT kernels.  Next I tried 
> 2.6.23-rc6-git7-rt1 (I applied patch-2.6.23-rc4-rt1 patch to 2.6.23-rc6-git7 
> and fixed the 5 failing hunks).  After an hour or so, lots of slab corruption 
> messages showed up:
> 
> Slab corruption: size-2048 start=f40c4670, len=2048
> Slab corruption: size-2048 start=f313cf48, len=2048
> Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> Last user: [<c0166be4>](kfree+0x80/0x95)
> 010: 6b 6b 00 0e 1e 00 16 13 00 0e 1e 00 19 3d 08 00
> 020: 45 00 05 dc 92 ab 40 00 40 11 8a 5b 0a 02 02 03
> 030: 0a 02 02 04 80 0c 80 0d 05 c8 dc 39 00 00 00 00
> 040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Prev obj: start=f313c730, len=2048
> Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> Last user: [<f8f06186>](netxen_post_rx_buffers_nodb+0x62/0x1f0 [netxen_nic])
> 000: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 010: 5a 5a 00 0e 1e 00 16 13 00 0e 1e 00 19 3d 08 00
> Next obj: start=f313d760, len=2048
> Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> Last user: [<f8f06186>](netxen_post_rx_buffers_nodb+0x62/0x1f0 [netxen_nic])
> 000: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 010: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> Slab corruption: size-2048 start=f395a6f0, len=2048
> Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> Last user: [<c0166be4>](kfree+0x80/0x95)
> 010: 6b 6b 00 0e 1e 00 16 13 00 0e 1e 00 19 3d 08 00
> 020: 45 00 05 dc 92 ac 40 00 40 11 8a 5a 0a 02 02 03
> 030: 0a 02 02 04 80 0c 80 0d 05 c8 dc 39 00 00 00 00
> 040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Next obj: start=f395af08, len=2048
> Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> Last user: [<f8f06186>](netxen_post_rx_buffers_nodb+0x62/0x1f0 [netxen_nic])
> 000: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 010: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> Last user: [<c0166be4>](kfree+0x80/0x95)
> 010: 6b 6b 00 0e 1e 00 16 13 00 0e 1e 00 19 3d 08 00
> 020: 45 00 05 dc 92 aa 40 00 40 11 8a 5c 0a 02 02 03
> 030: 0a 02 02 04 80 0c 80 0d 05 c8 dc 39 00 00 00 00
> 040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> Next obj: start=f40c4e88, len=2048
> Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> Last user: [<f8f06186>](netxen_post_rx_buffers_nodb+0x62/0x1f0 [netxen_nic])
> 000: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 010: 5a 5a 00 0e 1e 00 16 13 00 0e 1e 00 19 3d 08 00
> 
> The stress test that I am running is basically a mixed bag of stuff I threw 
> together.  It runs eight concurrent netperf TCP streams and two concurrent 
> UDP streams in both directions, (and on both 10GbE interfaces), ping -f in 
> both directions, some more disk/cpu loads in the background and a little bit 
> of NFS traffic thrown in for good measure.
> 
> --Vernon
