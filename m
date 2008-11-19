Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbYKSBxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbYKSBxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 20:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYKSBxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 20:53:46 -0500
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:37707 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbYKSBxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 20:53:45 -0500
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Fabio Checconi <fchecconi@gmail.com>
Date: Wed, 19 Nov 2008 12:52:42 +1100
Message-ID: <4923716A.5090104@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.17 (X11/20081027)
MIME-Version: 1.0
CC: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       Nauman Rafique <nauman@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Divyesh Shah <dpshah@google.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, taka@valinux.co.jp,
       righi.andrea@gmail.com, s-uchida@ap.jp.nec.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, menage@google.com,
       ngupta@google.com, riel@redhat.com, jmoyer@redhat.com,
       peterz@infradead.org, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
References: <af41c7c40811131457w472e4a86tb5344cc1d3d366fb@mail.gmail.com> <20081114160525.GE24624@redhat.com> <e98e18940811141444u5947b806v27fac453ed1e8a5@mail.gmail.com> <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com> <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com> <20081118120508.GD15268@gandalf.sssup.it> <20081118140751.GA4283@redhat.com> <20081118144139.GE15268@gandalf.sssup.it> <20081118191208.GJ26308@kernel.dk> <20081118211442.GG15268@gandalf.sssup.it>
In-Reply-To: <20081118211442.GG15268@gandalf.sssup.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Checconi wrote:
>   - To detect hw tagging in BFQ we consider a sample valid iff the
>     number of requests that the scheduler could have dispatched (given
>     by cfqd->rb_queued + cfqd->rq_in_driver, i.e., the ones still into
>     the scheduler plus the ones into the driver) is higher than the
>     CFQ_HW_QUEUE_MIN threshold.  This obviously caused no problems
>     during testing, but the way CFQ uses now seems a little bit
>     strange.

BFQ's tag detection logic is broken in the same way that CFQ's used to
be.  Explanation is in this patch:

============================x8============================
commit 45333d5a31296d0af886d94f1d08f128231cab8e
Author: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Date:   Tue Aug 26 15:52:36 2008 +0200

    cfq-iosched: fix queue depth detection
    
    CFQ's detection of queueing devices assumes a non-queuing device and detects
    if the queue depth reaches a certain threshold.  Under some workloads (e.g.
    synchronous reads), CFQ effectively forces a unit queue depth, thus defeating
    the detection logic.  This leads to poor performance on queuing hardware,
    since the idle window remains enabled.
    
    This patch inverts the sense of the logic: assume a queuing-capable device,
    and detect if the depth does not exceed the threshold.
============================x8=============================


BFQ seems better than CFQ at avoiding this problem though.  Using the following fio
job, I can routinely trigger it for 10s or so before BFQ detects queuing.


============================x8=============================
[global]
direct=1
ioengine=sync
norandommap
randrepeat=0
filename=/dev/sdb
bs=16k
runtime=200
time_based

[reader]
rw=randread
numjobs=128
============================x8=============================



