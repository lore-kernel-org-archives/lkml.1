Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbXEGM2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbXEGM2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbXEGM2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:28:09 -0400
Received: from mail.screens.ru ([213.234.233.54]:53764 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622AbXEGM2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:28:08 -0400
Date: Mon, 7 May 2007 15:33:51 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make-cancel_rearming_delayed_work-reliable-fix
Message-ID: <20070507113351.GA821@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <20070503181513.0b0aa4fb.akpm@linux-foundation.org> <20070505213213.GA1013@tv-sign.ru> <20070507103107.GD1754@ff.dom.local> <20070507103420.GA74@tv-sign.ru> <20070507115511.GA10367@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507115511.GA10367@zarina>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07, Anton Vorontsov wrote:
>
> I guess pseudo code below is not that strange, but real usecase:
> 
> probe()
> {
> 	INIT_DELAYED_WORK(...);
> 	/* we're not issuing queue_delayed_work() in probe(), work will
> 	 * be started by interrupt */
> 	return;
> }
> 
> remove()
> {
> 	/* hang will happen here if there was no queue_delyed_work()
> 	 * call (like there was no interrupts, which starts rearming
> 	 * work */
> 	cancel_rearming_delayed_work();
> }
> 
> 
> Your patch will fix it, right?

Yes, the new implemantation should work correctly.

However, this particular case was already fixed earlier,

	workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
	http://marc.info/?l=linux-mm-commits&m=117081275901499

Note that INIT_DELAYED_WORK() sets work->data = 0, and
cancel_rearming_delayed_work() does "Was it ever queued"
check.

Still, before this patch, cancel_rearming_delayed_work() hangs
if this work was used before, but not active + re-arming now.

Oleg.	

