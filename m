Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbXDPIYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbXDPIYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXDPIYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:24:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:40166 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbXDPIYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GHoLNpr7E8UW4ro4APo6kXiOtcWJ/FIs68kZ+/0+N2XYppImHuMEY4ffZ432dAv/wPlC77NNV3iuS4kzqgBxfQ18SsatyGfza8wjIAmwN3L8oNQELlR0dh4ySAr/7z3nXhyxyFwWxabe7Xbf7GKp2YEX1USQUKVfn7cdFTHvSNU=
Message-ID: <67029b170704160124y7bfcb535h8dfbeb1530446469@mail.gmail.com>
Date: Mon, 16 Apr 2007 16:24:51 +0800
From: "Zhou Yingchao" <yingchao.zhou@gmail.com>
To: akpm@zip.com.au, trond.myklebust@fys.uio.no, neilb@cse.unsw.edu.au,
       nfs@lists.sourceforge.net
Subject: NFS livelock / starvation ?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we run a two nfs client and a nfs server in the following way, we
met a livelock / starvation condition.

MachineA        MachineB
 Client1             Client2
 Server

As shown in the figure, we run a client and server on one machine, and
run another client on another machine. When Client1 and Client2 make
many writes at the same time, the Client1's request is blocked until
Client2's writes finished.

We check the code, Client1 is blocked in generic_file_write-> ...
>balance_dirty_pages, balance_dirty_pages call writeback_inodes to
(only) flush data of the related fs.

In nfs, we found that the Server has enhanced its dirty_thresh. So in
the loop of writeback_inodes, Client1 has no data to write out, and
the condition "ns_reclaimable+wbs.nr_writeback<=dirty_thresh" will not
be true until Client2 finishes its write request to Server. So the
loop will only end after Client2 finished its write job.

The problem in this path is: why we write only pages of the related fs
in writeback_inodes but check the dirty thresh for total pages?

-- 
Yingchao Zhou
***********************************************
 Institute Of Computing Technology
 Chinese Academy of Sciences
***********************************************
