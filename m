Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYLBESt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYLBESt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYLBESj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:18:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:59669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYLBESi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:18:38 -0500
Message-ID: <4934B71C.4030907@kernel.org>
Date: Tue, 02 Dec 2008 13:18:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Anderson <andmike@linux.vnet.ibm.com>,
       Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@osdl.org>, Alan Stern <stern@rowland.harvard.edu>,
       Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Subject: Re: Changes to Linux/SCSI target mode infrastructure for v2.6.28
References: <1228182727.13241.160.camel@haakon2.linux-iscsi.org>	 <1228183480.13241.163.camel@haakon2.linux-iscsi.org> <1228187439.13241.176.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1228187439.13241.176.camel@haakon2.linux-iscsi.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Dec 2008 04:18:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger wrote:
>>> So far during my initial testing, I am running into a two different
>>> exceptions.  One NULL pointer deference OOPS after half dozen Open/iSCSI
>>> login/logouts in block/elevator.c:elv_dequeue_request().   Here is the
>>> trace from SCSI softirq context:
>>>
>>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-0.png
>>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-1.png

Can you build with debug info and find out which line is the offending
one?

>>> The other one is a BUG_ON in blk/blk-timeout.c:177 in blk_add_timeout()
>>> that happens after a few hundred MB of READ_10 traffic, which also
>>> appears to pass through elv_dequeue_request() at some point:
>>>
>>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-2.png
>>> http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-4.png

Hmmm... this means blk_add_timer() is being called after the request
is already completed.  All the problem discovered till now have to do
with timeout going off without the low level driver knowing about the
request.  I don't have much idea and it'll probably be best to trace
what's going on using blktrace or printks.  Maybe this is caused by
list corruption as with the first issue or request completion races
with requeueing?

-- 
tejun
