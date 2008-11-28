Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbYK1Ndm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbYK1Ndm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYK1Ndc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:33:32 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:38987 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751254AbYK1Ndb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:33:31 -0500
Date: Fri, 28 Nov 2008 22:33:30 +0900 (JST)
Message-Id: <20081128.223330.623571555980968757.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       fchecconi@gmail.com, paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20081126160805.GE27826@redhat.com>
References: <20081125162720.GH341@redhat.com>
	<20081126.214707.653026525707335397.ryov@valinux.co.jp>
	<20081126160805.GE27826@redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

> > Thanks for your explanation. 
> > I think that the same thing occurs without the higher level scheduler,
> > because all the tasks issuing I/Os are blocked while the underlying
> > device's request queue is full before those I/Os are sent to the I/O
> > scheduler.
> > 
> 
> True and this issue was pointed out by Divyesh. I think we shall have to
> fix this by allocating the request descriptors in proportion to their
> share. One possible way is to make use of elv_may_queue() to determine
> if we can allocate furhter request descriptors or not. 

At the fist glance, elv_may_queue() seemed to be useful for the purpose
as you mentioned. But I've noticed there are some problems after I
investigated the code more.

 1. Every I/O controller must have its own decision algorithm that
    which I/O requests should be block or not, whose algorithm will be
    similar to that of dm-ioband. It would be a hassle to implement it
    in all the I/O controllers.

 2. When an I/O is completed, one of the slots in the request queue
    become available, then one of the processes being blocked get awakened
    in fifo manner. This won't be the best one in most cases and
    you have to make this process sleep again and you may want to
    wake up another one. It's inefficient.

 3. In elv_may_queue(), we can't determine which process issues an I/O.
    You have no choice but to make any kind of process sleep even if
    it's a kernel thread such as kswapd or pdflush. What do you think
    is going to happen after that?
    It may be possible to modify the code not to block kernel threads,
    but I don't think you can control delayed-write I/Os.

If you want to solve these problems, I think you are going to implement
the algorithm there whose code is very similar to that of dm-ioband.

Thanks,
Ryo Tsuruta
