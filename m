Return-Path: <linux-kernel-owner+w=401wt.eu-S965927AbXEKXaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965927AbXEKXaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXEKX3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:29:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123AbXEKX3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:29:52 -0400
Date: Fri, 11 May 2007 16:29:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
In-Reply-To: <200705120122.07177.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0705111625300.3986@woody.linux-foundation.org>
References: <200705110035.32229.rjw@sisk.pl> <200705112240.54304.rjw@sisk.pl>
 <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
 <200705120122.07177.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Rafael J. Wysocki wrote:
>
> We use this function (ie. kernel/power/process.c:is_user_space()) to
> distinguish kernel threads from user space processes.  Therefore we make it
> always return true for user space processes and always return false for kernel
> threads.  In the latter case we need to use the task_lock() to ensure that the
> result is as desired (ie. false), because otherwise it might be racing with
> either fs/aio.c:use_mm() or fs/aio.c:unuse_mm().

But there is no race protection in the *caller*, so if it can ever return 
one or the other, what protects it from changing once the caller returns?

And if the value can change (because some thread uses "use_mm()"), then 
the caller cannot rely on the value that got returned.

So you migt as well not return any value at all, since the returned value 
is apparently meaningless once the lock has been released.

In other words: "The lock, it does nothing".

		Linus
