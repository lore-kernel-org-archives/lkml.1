Return-Path: <linux-kernel-owner+w=401wt.eu-S964853AbXCOAPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853AbXCOAPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbXCOAPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:15:47 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34700 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964862AbXCOAPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:15:46 -0400
Date: Wed, 14 Mar 2007 17:15:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Benjamin LaHaise <bcrl@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 13/13] signalfd/timerfd/asyncfd v5 - KAIO asyncfd support
 (example/maybe-broken) ...
In-Reply-To: <Pine.LNX.4.64.0703141620340.4982@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703141711451.9690@woody.linux-foundation.org>
References: <send-serie.davidel@xmailserver.org.13805.1173910770.13>
 <20070314231920.GB1246@kvack.org> <Pine.LNX.4.64.0703141620340.4982@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Davide Libenzi wrote:
> >
> > That won't work.  aio_complete() is supposed to be irq safe.
> 
> Can you point me to a kernel path that ends up calling aio_complete() in a 
> do-not-sleep mode?

All of them.

It's called from dio_bio_end_aio(), which is the bi_end_io function for an 
AIO action. Which in turn is called at IO completion time. 

Which is basically _always_ interrupt context.

So you cannot sleep. It's not about holding spinlocks (which it might well 
do as well). It's about a much more fundamental issue: you can only sleep 
in process context, not from interrupts.

		Linus
