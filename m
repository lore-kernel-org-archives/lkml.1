Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbXH0F7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbXH0F7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 01:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXH0F7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 01:59:24 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36933 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbXH0F7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 01:59:23 -0400
Date: Mon, 27 Aug 2007 09:57:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: taoyue <yue.tao@windriver.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Mark Zhan <rongkai.zhan@windriver.com>,
       "Ashfield, Bruce" <Bruce.Ashfield@windriver.com>
Subject: Re: [PATCH] sigqueue_free: fix the race with collect_signal()
Message-ID: <20070827055731.GA91@tv-sign.ru>
References: <20070823134538.GA1358@tv-sign.ru> <46CEEA94.2070902@windriver.com> <20070824074558.GA86@tv-sign.ru> <46CF4DCB.6030304@windriver.com> <20070824110836.GA74@tv-sign.ru> <46CF3988.1020408@us.ibm.com> <20070824202305.GA274@tv-sign.ru> <46D2D57E.4070406@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D2D57E.4070406@windriver.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, taoyue wrote:
>
> Oleg Nesterov wrote:
> >On 08/24, Sukadev Bhattiprolu wrote:
> >>>>>          
> >>>>I know, using current->sighand->siglock to prevent one sigqueue
> >>>>is free twice. I want to know whether it is possible that the two
> >>>>function is called in different thread. If that, the spin_lock is 
> >>>>useless.
> >>>>   
> >>>>        
> >>>Not sure I understand. Yes, it is possible they are called by 2 different
> >>>threads, that is why we had a race. But all threads in the same thread
> >>>group have the same ->sighand, and thus the same ->sighand->siglock.
> >>>      
> I has applied the new patch, and start test program last Friday.
> So far, the test program has run for three days.

Great, thanks.

> In my test program, all threads is created in one process, so they
> are in the same thread group. If two thread is not in the same thread
> group, they have the different ->sighand->siglock. In this case, the
> lock can't prevent the sigqueue object from race condition.

If two thread are not in the same thread, they can't access the same
SIGQUEUE_PREALLOC sigqueue. That is why sigqueue_free() uses current->sighand.
Otherwise, this lock doesn't make any sense, and can't protect list_del(q->list).

Oleg.

