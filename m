Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYLSWTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYLSWTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYLSWTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:19:22 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:32827 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYLSWTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:19:21 -0500
Message-ID: <494C1DE5.4040901@us.ibm.com>
Date: Fri, 19 Dec 2008 14:19:17 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@au1.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: futex.c and fault handling
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working in linux-tip core/futexes lately and have a need to be able to properly handle faults for r/w access to a uaddr.  I was planning on modeling this on the fault handling in futex_lock_pi which used both get_user() and futex_handle_fault() to get the pages.  However, that used to be based on whether or not we held the mmap_sem.  Now that we're using fast_gup throughout futex.c, and the mmap_sem locking has been pushed in tighter in get_futex_key(), I'm not sure if the fault handling is still correct - the comments are certainly incorrect since we no longer hold the mmap_sem when we hit uaddr_faulted: inside futex_lock_pi (and a few other places have similar comment vs. code dicrepancies):

uaddr_faulted:
	/*
	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
	 * atomically.  Therefore, if we continue to fault after get_user()
	 * below, we need to handle the fault ourselves, while still holding
	 * the mmap_sem.  This can occur if the uaddr is under contention as
	 * we have to drop the mmap_sem in order to call get_user().
	 */
	queue_unlock(&q, hb);

	if (attempt++) {
		ret = futex_handle_fault((unsigned long)uaddr, attempt);
		if (ret)
			goto out_put_key;
		goto retry_unlocked;
	}

---> previous versions dropped the mmap_sem here in preparation for get_user()

	ret = get_user(uval, uaddr);
	if (!ret)
		goto retry;


So is the code still correct without the holding of mmap_sem?  I suppose get_user() is still the more efficient path, and perhaps even more so now that we don't have to release mmap_sem and reacquire it later in order to call it.  If so, then I guess all that is needed is a comments patch, which I'd be happy to write up.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
