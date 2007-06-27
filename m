Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbXF0L2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbXF0L2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXF0L2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:28:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:46788 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbXF0L2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:28:31 -0400
Date: Wed, 27 Jun 2007 15:29:08 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Chris Snook <csnook@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sys_time-speedup-small-cleanup
Message-ID: <20070627112908.GB108@tv-sign.ru>
References: <20070626123424.GA259@tv-sign.ru> <46813D1C.9080107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46813D1C.9080107@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Chris Snook wrote:
>
> Oleg Nesterov wrote:
> >on top of sys_time-speedup.patch
> >
> >Ingo Molnar wrote:
> >> asmlinkage long sys_time(time_t __user * tloc)
> >> {
> >>-	time_t i;
> >>-	struct timeval tv;
> >>+	/*
> >>+	 * We read xtime.tv_sec atomically - it's updated
> >>+	 * atomically by update_wall_time(), so no need to
> >>+	 * even read-lock the xtime seqlock:
> >>+	 */
> >>+	time_t i = xtime.tv_sec;
> >> 
> >>-	do_gettimeofday(&tv);
> >>-	i = tv.tv_sec;
> >>+	smp_rmb(); /* sys_time() results are coherent */
> >
> >Why do we need this barrier? My guess it is needed to prevent
> >the reading of xtime.tv_sec twice, yes? In that case a simple
> >barrier() should be enough.
> 
> Without the smp_rmb, you can potentially have a situation where one CPU is 
> still reading an old value from cache while another has the new value.  

I can't understand this.

Fisrt, smp_rmb() can't help in this case. It can't influence the preceeding
LOAD if it was from cache.

Even if it could, another CPU can alter the value just after the reading
completes, and we have the same situation.

Could you please clarify if I am wrong?

Oleg.

