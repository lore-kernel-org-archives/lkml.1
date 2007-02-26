Return-Path: <linux-kernel-owner+w=401wt.eu-S1030525AbXBZV0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525AbXBZV0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030528AbXBZV0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:26:12 -0500
Received: from mail.screens.ru ([213.234.233.54]:36981 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030525AbXBZV0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:26:10 -0500
Date: Tue, 27 Feb 2007 00:25:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Message-ID: <20070226212554.GA93@tv-sign.ru>
References: <200702261139.59130.rjw@sisk.pl> <20070226151442.GA29869@in.ibm.com> <20070226161129.GA527@tv-sign.ru> <200702261928.19274.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702261928.19274.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Rafael J. Wysocki wrote:
>
> On Monday, 26 February 2007 17:11, Oleg Nesterov wrote:
> > On 02/26, Srivatsa Vaddagiri wrote:
> > >
> > > On Mon, Feb 26, 2007 at 03:00:43PM +0300, Oleg Nesterov wrote:
> > > > In that case we should also modify ____call_usermodehelper(), otherwise we have
> > > > the same "deadlock" if it is frozen. But this is not so easy to do as I thought
> > > > before.
> > > 
> > > Before ____call_usermodehelper can freeze, it should have entered userspace 
> > > right? By that time, its vfork parent should have definitely woken up,
> > > which should avoid the deadlock you point out?
> > 
> > Ah, yes, thanks for correcting me.
> > 
> > We are doing flush_old_exec() a way before entering userspace of course.
> 
> Well, does it mean the patch is acceptable or should I modify it somehow?

Oh, don't ask me, I don't have a time to study these patches currently :)

_Perhaps_ we can do something better than add explicit checks in freezer_...count,
but I can't suggest anything. Btw, we don't need task_lock() to test current->mm,
and I believe we don't need to check PF_BORROWED_MM there.

"[PATCH 2/3] Freezer: Take kernel_execve into consideration" looks a bit incomplete
to me... I agree, this is a good change for now. But, assuming that we can spawn
an "arbitrary" user-space process from kernel space, we may freeze some kernel
thread which is needed for that user-space task to proceed and notice a signal.

I am starting to suspect that call_usermodehelper() needs a special attention
from freezer, but again, I can't suggest anything, at least right now.

"[PATCH 3/3] Freezer: Prevent ___call_usermodehelper from missing freezing requests"
looks unneeded to me, we should imho drop flush_signals() instead. At least, please
don't call do_not_freeze() under sighand->siglock. This looks as if we have a subtle
reason for this lock, but we don't ? Oh, wait ...  ____call_usermodehelper() does
recalc_sigpending() after flush_signals()! This means we can't lost a "fake" signal
from freezer, so we don't need this patch. Agreed?

Apart from "[PATCH 3/3]", I have nothing against these patches, they fix real problems.

Oleg.

