Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbXINKrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbXINKrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXINKrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:47:22 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34352 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbXINKrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:47:20 -0400
Message-ID: <46EA66B0.1000900@bull.net>
Date: Fri, 14 Sep 2007 12:47:12 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: __down() fails to provide with acquisition semantics
References: <20070807172458.59931ef2.kamezawa.hiroyu@jp.fujitsu.com> <20070807172648.4590c3dd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070807172648.4590c3dd.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 14/09/2007 12:53:06,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 14/09/2007 12:53:07,
	Serialize complete at 14/09/2007 12:53:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have got a concern about "__down()".
Can someone explain me, please, how it is assumed to work?

Apparently, "__down()" fails to provide with acquisition semantics
in certain situations.

Let's assume the semaphore is unavailable and there is nobody
waiting for it.

The next requester enters the slow path.

Let's assume the owner of the semaphore releases it just before
the requester would execute the line:

   if (!atomic_add_negative(sleepers - 1, &sem->count)) {

Therefore the loop gets broken, the requester returns without
going to sleep.

   atomic_add_negative():
	atomic_add_return():
		ia64_fetch_and_add():
			ia64_fetchadd(i, v, rel)

At least on ia64, "atomic_add_negative()" provides with release
semantics.

"remove_wait_queue_locked()" does not care for acquisition semantics.
"wake_up_locked()" finds an empty list, it does nothing.
"spin_unlock_irqrestore()" does release semantics.

The requester is granted the semaphore and s/he enters the critical
section without making sure that the memory accesses s/he wants to
issue in the critical section cannot be made globally visible before
"atomic_add_negative()" is.

We need an acquisition semantics (at least) before entering any
critical section. Should not we have something like:

   if (atomic_add_acq(sleepers - 1, &sem->count) /* ret: new val */ >= 0){

"atomic_add_acq()" would provide with acquisition semantics in
an architecture dependent way.
I think it should be made more explicit that this routine should
provide with the architecture dependent memory fencing.


What is the use of the "wake_up_locked(&sem->wait)"?
The other requester woke up, will find the semaphore unavailable...


Another question: is there any reason keeping an ia64 version when
lib/semaphore-sleepers.c and arch/ia64/kernel/semaphore.c do not
really differ?


Thanks,

Zoltan Menyhart
