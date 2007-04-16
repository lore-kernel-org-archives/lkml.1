Return-Path: <linux-kernel-owner+w=401wt.eu-S1751349AbXDPJUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbXDPJUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXDPJUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:20:19 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:44825 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbXDPJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:20:18 -0400
Subject: Re: NFS livelock / starvation ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Zhou Yingchao <yingchao.zhou@gmail.com>
Cc: akpm@zip.com.au, trond.myklebust@fys.uio.no, neilb@cse.unsw.edu.au,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <67029b170704160124y7bfcb535h8dfbeb1530446469@mail.gmail.com>
References: <67029b170704160124y7bfcb535h8dfbeb1530446469@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 11:20:13 +0200
Message-Id: <1176715213.3035.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 16:24 +0800, Zhou Yingchao wrote:
> When we run a two nfs client and a nfs server in the following way, we
> met a livelock / starvation condition.
> 
> MachineA        MachineB
>  Client1             Client2
>  Server
> 
> As shown in the figure, we run a client and server on one machine, and
> run another client on another machine. When Client1 and Client2 make
> many writes at the same time, the Client1's request is blocked until
> Client2's writes finished.
> 
> We check the code, Client1 is blocked in generic_file_write-> ...
> >balance_dirty_pages, balance_dirty_pages call writeback_inodes to
> (only) flush data of the related fs.
> 
> In nfs, we found that the Server has enhanced its dirty_thresh. So in
> the loop of writeback_inodes, Client1 has no data to write out, and
> the condition "ns_reclaimable+wbs.nr_writeback<=dirty_thresh" will not
> be true until Client2 finishes its write request to Server. So the
> loop will only end after Client2 finished its write job.
> 
> The problem in this path is: why we write only pages of the related fs
> in writeback_inodes but check the dirty thresh for total pages?

I am working on patches to fix this.

Current version at (against -mm):
  http://programming.kicks-ass.net/kernel-patches/balance_dirty_pages/

However, after a rewrite of the BDI statistics work there are some
funnies, which I haven't had time to analyse yet :-/

I hope to post a new version soonish...

