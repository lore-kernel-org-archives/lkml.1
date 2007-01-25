Return-Path: <linux-kernel-owner+w=401wt.eu-S1030225AbXAYPoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225AbXAYPoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030215AbXAYPoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:44:09 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:15005 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030225AbXAYPoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:44:08 -0500
Message-ID: <45B8D041.8050507@cfl.rr.com>
Date: Thu, 25 Jan 2007 10:44:01 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Denis Vlasenko <vda.linux@googlemail.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701212102.43028.vda.linux@googlemail.com> <45B4E3A3.40706@cfl.rr.com> <200701242215.47777.vda.linux@googlemail.com>
In-Reply-To: <200701242215.47777.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2007 15:44:17.0053 (UTC) FILETIME=[ABD634D0:01C74097]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14956.003
X-TM-AS-Result: No--10.534100-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> I will still disagree on this point (on point "use O_DIRECT, it's faster").
> There is no reason why O_DIRECT should be faster than "normal" read/write
> to large, aligned buffer. If O_DIRECT is faster on today's kernel,
> then Linux' read()/write() can be optimized more.

Ahh but there IS a reason for it to be faster: the application knows 
what data it will require, so it should tell the kernel rather than ask 
it to guess.  Even if you had the kernel playing vmsplice games to get 
avoid the copy to user space ( which still has a fair amount of overhead 
), then you still have the problem of the kernel having to guess what 
data the application will require next, and try to fetch it early.  Then 
when the application requests the data, if it is not already in memory, 
the application blocks until it is, and blocking stalls the pipeline.

> (I hoped that they can be made even *faster* than O_DIRECT, but as I said,
> you convinced me with your "error reporting" argument that reads must still
> block until entire buffer is read. Writes can avoid that - apps can do
> fdatasync/whatever to make sync writes & error checks if they want).


fdatasync() is not acceptable either because it flushes the entire file. 
  This does not allow the application to control the ordering of various 
writes unless it limits itself to a single write/fdatasync pair at a 
time.  Further, fdatasync again blocks the application.

With aio, the application can keep several read/writes going in 
parallel, thus keeping the pipeline full.  Even if the io were not 
O_DIRECT, and the kernel played vmsplice games to avoid the copy, it 
would still have more overhead, complexity and I think, very little gain 
in most cases.


