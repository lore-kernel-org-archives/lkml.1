Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYKFBtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYKFBtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYKFBtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:49:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbYKFBtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:49:41 -0500
Date: Wed, 5 Nov 2008 17:49:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Brian Kysela <bkysela@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       linux-usb@vger.kernel.org
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb =
 ffff88006a338480
Message-Id: <20081105174905.27194494.akpm@linux-foundation.org>
In-Reply-To: <20081030213557.GA6767@ezra.hsd1.tn.comcast.net>
References: <20081030213557.GA6767@ezra.hsd1.tn.comcast.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 17:35:57 -0400
Brian Kysela <bkysela@gmail.com> wrote:

> On kernels ranging from 2.6.26 - 2.6.28-rc2

So 2.6.25 was OK?

> on an Intel P4 3.2GHz HT x86-64
> cpu, I am seeing a bug that occurs about half the time when copying ~300MB
> data from a usb flash drive (FAT) to hard drive (XFS). There are three
> possible outcomes, so far, when I hit the bug:
> 
>     (1) The copy process hangs, cpu wait hits 100% and load avg climbs until
>         reboot;
>     (2) The copy process hangs and then recovers and then one of:
>         (a) the cpu wait & load avg both decline to normal; or
>         (b) cpu wait hovers at 100% and the load avg slowly climbs until reboot;
>     (3) Kernel bug reported and machine locks up.
> 
> Result (1) is the most frequent. Result (3) happened only twice out of about 40
> tests. I lose the full traces, but here are two relevant lines that I see on
> screen before the machine locks up:
> 
> kernel BUG at /home/brian/linux-2.6/block/elevator.c:841!
> invalid opcode: 0000 [#1] PREMPT SMP

It is unclear what kernel version produced that message, and that is
important information.  In 2.6.28-rc2, block/elevator.c:841 is

    void elv_dequeue_request(struct request_queue *q, struct request *rq)
    {
-->>	BUG_ON(list_empty(&rq->queuelist));
	BUG_ON(ELV_ON_HASH(rq));

please confirm that I have the correct line there.


I assume that you're hitting a bug in the USB storage code and this is
triggering consistency-checking code in the block layer.

> When (1) or (2b) occurs I pull the usb drive to see what happens. In two cases
> (3) occurred, but more often I get this in /var/log/syslog:

The other things you saw were most likely a consequence of the
BUG_ON().

