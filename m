Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYGOMUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYGOMUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYGOMPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:15:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56106 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193AbYGOMPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:15:13 -0400
Message-ID: <487C94CC.3090402@firstfloor.org>
Date: Tue, 15 Jul 2008 14:15:08 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, davem@davemloft.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
References: <20080713.202035.172246136.davem@davemloft.net> <20080715024424R.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.64.0807141720350.30981@devserv.devel.redhat.com> <20080715114058A.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.64.0807150759430.12202@devserv.devel.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0807150759430.12202@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka wrote:
>>> BTW. what should the block device driver do when it receives a mapping
>>> error? (if it aborts the request and it was write request, there will be
>>> data corruption).
>>
>> I'm not sure how a aborted request can corrupt data on disk.
> 
> Writes are done by an async daemon and no one checks for their
> completion status. If there are three writes to directory, inode table
> and inode bitmap and one of these writes fail, there's no code to undo
> the other two. So the filesystem will be corrupted on write failure.

Normally journaling in ordered mode takes care of that. The transaction
is not committed until all earlier data has been successfully written.
And even the other fs typically turn the file system read only
on IO error to prevent further corruption.

Bigger issue is when the IOMMU mapping fails, but the driver doesn't have
error handling code. In the early days of the x86-64 GART IOMMU I managed
to corrupt a few super blocks this way because random data would be written then.

The block drivers have this pretty much all fixed these days, but in some other
areas (like network drivers) it looks much worse. So if your file system is
actually a network file system this might be a problem.

-Andi
