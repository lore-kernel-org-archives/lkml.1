Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYGXRVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYGXRVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYGXRUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:20:53 -0400
Received: from mailhub248.itcs.purdue.edu ([128.210.5.248]:47343 "EHLO
	mailhub248.itcs.purdue.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbYGXRUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:20:52 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2008 13:20:52 EDT
From: Michael Shuey <shuey@purdue.edu>
Reply-To: shuey@purdue.edu
Organization: Purdue University ITaP/RCS
Subject: high latency NFS
Date: Thu, 24 Jul 2008 13:11:31 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3166
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200807241311.31457.shuey@purdue.edu>
X-PMX-Version: 5.4.0.320885
X-PerlMx-Virus-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently toying with Linux's NFS, to see just how fast it can go in a 
high-latency environment.  Right now, I'm simulating a 100ms delay between 
client and server with netem (just 100ms on the outbound packets from the 
client, rather than 50ms each way).  Oddly enough, I'm running into 
performance problems. :-)

According to iozone, my server can sustain about 90/85 MB/s (reads/writes) 
without any latency added.  After a pile of tweaks, and injecting 100ms of 
netem latency, I'm getting 6/40 MB/s (reads/writes).  I'd really like to 
know why writes are now so much faster than reads, and what sort of things 
might boost the read throughput.  Any suggestions?
1
The read throughput seems to be proportional to the latency - adding only 
10ms of delay gives 61 MB/s reads, in limited testing (need to look at it 
further).  While that's to be expected, to some extent, I'm hoping there's 
some form of readahead that can help me out here (assume big sequential 
reads).

iozone is reading/writing a file twice the size of memory on the client with 
a 32k block size.  I've tried raising this as high as 16 MB, but I still 
see around 6 MB/sec reads.

I'm using a 2.6.9 derivative (yes, I'm a RHEL4 fan).  Testing with a stock 
2.6, client and server, is the next order of business.

NFS mount is tcp, version 3.  rsize/wsize are 32k.  Both client and server 
have had tcp_rmem, tcp_wmem, wmem_max, rmem_max, wmem_default, and 
rmem_default tuned - tuning values are 12500000 for defaults (and minimum 
window sizes), 25000000 for the maximums.  Inefficient, yes, but I'm not 
concerned with memory efficiency at the moment.

Both client and server kernels have been modified to provide 
larger-than-normal RPC slot tables.  I allow a max of 1024, but I've found 
that actually enabling more than 490 entries in /proc causes mount to 
complain it can't allocate memory and die.  That was somewhat suprising, 
given I had 122 GB of free memory at the time...

I've also applied a couple patches to allow the NFS readahead to be a 
tunable number of RPC slots.  Currently, I set this to 489 on client and 
server (so it's one less than the max number of RPC slots).  Bandwidth 
delay product math says 380ish slots should be enough to keep a gigabit 
line full, so I suspect something else is preventing me from seeing the 
readahead I expect.

FYI, client and server are connected via gigabit ethernet.  There's a couple 
routers in the way, but they talk at 10gigE and can route wire speed.  
Traffic is IPv4, path MTU size is 9000 bytes.

Is there anything I'm missing?

-- 
Mike Shuey
Purdue University/ITaP
