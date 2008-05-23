Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYEWET7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYEWET7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbYEWETt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:19:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYEWETs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:19:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Luming Yu" <luming.yu@gmail.com>
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
In-Reply-To: Luming Yu's message of  Friday, 23 May 2008 11:42:35 +0800 <3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	<1211446045.5610.33.camel@elijah.suse.cz>
	<3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
	<20080522111826.BB90326FA24@magilla.localdomain>
	<3877989d0805220624i259a9d1j708795c65c636ca0@mail.gmail.com>
	<20080522203428.835D626FA24@magilla.localdomain>
	<3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
X-Zippy-Says: WHO sees a BEACH BUNNY sobbing on a SHAG RUG?!
Message-Id: <20080523041940.39E8726FA24@magilla.localdomain>
Date: Thu, 22 May 2008 21:19:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the code path mentioned above, I see only ia64 has chance to let
> ptraced thread deliver those pending signals before TASK_TRACED is

This is the key thing that makes no sense to me.  What do you mean by
"deliver" here?  The normal meaning of to "deliver" a signal means that
get_signal_to_deliver() dequeues and processes it.  This can never happen
inside any other kernel code path.  It certainly can never happen inside
ptrace_stop or ptrace_notify.

The difference between ia64 and others is that inside ptrace_stop(), it can
release the siglock and then can block (in page faults, or by preemption).
No signal delivery can happen.  

What perhaps can happen is that TIF_SIGPENDING being set can cause a
TASK_INTERRUPTIBLE wait in the page fault path to return early and
ia64_sync_user_rbs will bail out before doing all its work.  But you
haven't described any problem like that.

Please tell us the exact code path you think is happening in the error case
you can reproduce.  Describe the actual code path, not high-level notions
like "deliver those pending signals".


Thanks,
Roland
