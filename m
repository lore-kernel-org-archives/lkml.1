Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbXKUP7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbXKUP7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbXKUP7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:59:06 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42208 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbXKUP7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:59:04 -0500
Date: Wed, 21 Nov 2007 18:58:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Message-ID: <20071121155842.GA864@tv-sign.ru>
References: <20071120234605.GG23667@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120234605.GG23667@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alasdair G Kergon wrote:
>
>   - But what happens if kcryptd_crypt_write_convert_loop() calls
> INIT_WORK/queue_work twice?

Can't find this function. But "INIT_WORK + queue_work" twice is very
wrong of course.

Milan Broz wrote:
>
> Ok, then I have question: Is the following pseudocode correct
> (and problem is in lock validation which checks something
> already initialized for another queue) or reusing work_struct
> is not permitted from inside called work function ?
>
> (Note comment in code "It is permissible to free the struct
> work_struct from inside the function that is called from it".)
>
> struct work_struct work;
> struct workqueue_struct *a, *b;
>
> do_b(*work)
> {
>         /* do something else */
> }
>
> do_a(*work)
> {
>         /* do something */
>         INIT_WORK(&work, do_b);
>         queue_work(b, &work);
> }
>
>
> INIT_WORK(&work, do_a);
> queue_work(a, &work);

(just in case, in that particular case PREPARE_WORK() should be used)

INIT_WORK(w) can be used if we know that "w" is not pending, and nobody
else can write to this work (say, queue_work(w) or cancel_work_sync(w)).
So currently the code above should work correctly.

However, I'd say it is not correct, INIT_WORK() can throw out some debug
info for example, or the implementation could be changed.

I'm not sure about CONFIG_LOCKDEP (Johannes cc'ed). INIT_WORK() does
lockdep_init_map(->lockdep_map) but run_workqueue() has a local copy,
looks ok.

Oleg.

