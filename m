Return-Path: <linux-kernel-owner+w=401wt.eu-S2992435AbXDRNPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992435AbXDRNPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992436AbXDRNPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:15:39 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21707 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992435AbXDRNPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:15:38 -0400
X-IronPort-AV: i="4.14,422,1170662400"; 
   d="scan'208"; a="52267373:sNHT16722699"
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Florin Iucha <florin@iucha.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070418123842.GF24044@iucha.net>
References: <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	 <20070417195823.943f9472.akpm@linux-foundation.org>
	 <1176865565.6796.16.camel@heimdal.trondhjem.org>
	 <20070418033055.GA24044@iucha.net>
	 <1176868485.6796.42.camel@heimdal.trondhjem.org>
	 <20070418040730.GC24044@iucha.net>
	 <20070417211350.ebba1493.akpm@linux-foundation.org>
	 <20070418043040.GD24044@iucha.net>
	 <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
	 <20070417223738.8f49a39f.akpm@linux-foundation.org>
	 <20070418123842.GF24044@iucha.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 18 Apr 2007 09:15:31 -0400
Message-Id: <1176902131.6796.62.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 18 Apr 2007 13:15:38.0377 (UTC) FILETIME=[A82D7F90:01C781BB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 07:38 -0500, Florin Iucha wrote:
> On Tue, Apr 17, 2007 at 10:37:38PM -0700, Andrew Morton wrote:
> > Florin, can we please see /proc/meminfo as well?
> 
>    http://iucha.net/nfs/21-rc7-nfs2/meminfo
> 
> > Also the result of `echo m > /proc/sysrq-trigger'
> 
>    http://iucha.net/nfs/21-rc7-nfs2/big-copy
> 
> This has 'echo m > /proc/sysrq-trigger', 'echo t >
> /proc/sysrq-trigger' and 'echo 0 > /proc/sys/sunrpc/rpc_debug'.

Thanks.

So it looks as if you have a massive backlog of requests waiting in the
RPC layer to get sent. That would indeed trigger the BDI congestion
control stuff, and prevent you from sending more requests. The
interesting bit is this:

[  399.665314] -pid- proc flgs status -client- -prog- --rqstp- -timeout -rpcwait -action- ---ops--
[  399.665338] 40373 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0de0        0 xprt_resend ffffffff804196bf ffffffff80440b10
[  399.665345] 40391 0001 0001    -11 ffff81007f418508 100003 ffff810078eb05c8        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665351] 40392 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0128        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665358] 40393 0001 0001    -11 ffff81007f418508 100003 ffff810078eb1158        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665364] 40394 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0f08        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665371] 40395 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0000        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665377] 40396 0001 0001    -11 ffff81007f418508 100003 ffff810078eb1030        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665384] 40397 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0cb8        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665390] 40398 0001 0001    -11 ffff81007f418508 100003 ffff810078eb06f0        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665397] 40399 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0940        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665404] 40400 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0818        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665410] 40401 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0378        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.665417] 40402 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0250        0 xprt_sending ffffffff804196bf ffffffff80440b10
[  399.669252] 41086 0001 0001      0 ffff81007f418508 100003 ffff810078eb0a68    15000 xprt_pending ffffffff804196bf ffffffff80440b10
[  399.669258] 41087 0001 0001    -11 ffff81007f418508 100003 ffff810078eb0b90        0 xprt_resend ffffffff804196bf ffffffff80440b10
[  399.669265] 41088 0001 0001    -11 ffff81007f418508 100003 ffff810078eb04a0        0 xprt_sending ffffffff804196bf ffffffff80440b10

There is only one request on the 'pending' queue. That would usually
indicate that the connection to the server is down. Can you check using
"netstat -t" whether or not there is a connection in the 'ESTABLISHED'
state to the server? Please also repeat the command a couple of times in
order to see if the socket/port number on the connection changes.

Cheers
  Trond
