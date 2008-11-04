Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYKDDCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYKDDCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 22:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYKDDCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 22:02:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:46885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbYKDDCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 22:02:12 -0500
Message-ID: <490FBB26.9050902@kernel.org>
Date: Tue, 04 Nov 2008 12:01:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Mike Anderson <andmike@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with the block-layer timeouts
References: <Pine.LNX.4.44L0.0811031051210.2454-100000@iolanthe.rowland.org> <490F2953.30709@kernel.org> <20081103172700.GW31673@kernel.dk>
In-Reply-To: <20081103172700.GW31673@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Nov 2008 03:02:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Nov 04 2008, Tejun Heo wrote:
>> I'm trying to convert all drivers to use the same command issue model -
>> elv_next_request() -> blkdev_dequeue_request() on actual issue ->
>> blk_end_request().  I have first draft of the conversion patchset but
>> it's gonna take me a few more days to review and test what I can as
>> several drivers (mostly legacy ones) are a bit tricky.
> 
> Don't do that, please. What we need to do is ensure that the model
> fits with whatever the driver wants to do there, and for some
> drivers it's actually a lot easier to rely on elv_next_request()
> returning the same requests again instead of keeping track of it
> yourself.  So any patch that enforces the model that you must
> dequeue before starting the request, will get a big nak from me.

I audited every user of elv_next_request() and converting them to
follow a single model isn't that diffcult.  Most drivers which peek at
the top of the queue already have the current rq pointer and they are
not difficult to convert as it's guaranteed that they process one
request at any given time and nothings else till the current request
is finished.  Usually, the only thing that's required is to check
whether the previous request is completely done before fetching the
next one.

Model which fits to different driver's usage models is a good goal but
as with everything else it needs to be balanced with other goals, and
while enforcing single fetch/completion model to drivers doesn't cost
much to its users, it does hurt the block layer abstraction.  I think
preemptive NACK is a bit too hasty.  With sensible helper routines, I
think we can satisfy both block layer and the legacy users of it.

> What we need to do is add a 'peek' mode only, which doesn't start the
> request. Along with something to mark it started that the driver can
> use, or it can just use elv_next_request() of course.

I don't agree adding more interfaces is a good idea when the problem
is lack of uniformity.  There is no inherent convenience or advantage
of having two different operation modes but there are quite some
number of rough edges added thinking about only one model.
BLK_TA_ISSUE was one minor example.  Another one would be the prep
function and the DONTPREP flag and now the timer.  Elevator accounting
becomes different for the different drivers.  Padding adjustment
should be done right before low level driver issues the command and
undone on requeue but it can'be done that way now and so on.

Thanks.

-- 
tejun
