Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbYCGVdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbYCGVdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbYCGVdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:33:10 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34427 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760999AbYCGVdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:33:09 -0500
Date: Sat, 8 Mar 2008 00:32:17 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: do_tkill: don't use tasklist_lock
Message-ID: <20080307213217.GA2584@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru> <20080307193159.1AFF127010F@magilla.localdomain> <20080307201346.GA107@tv-sign.ru> <20080307211955.A876226F990@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307211955.A876226F990@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07, Roland McGrath wrote:
>
> > Btw, a question: we are buggy or just "not perfect" ? After all, the
> > main thread actually exits although this is just linux's implementation
> > detail.
> 
> I think it's buggy.  The SIGKILL should kill the whole process.

OK.

> > Suppose that the main thread is already dead (dequeued SIGKILL), but
> > not yet released. This window is not that small. In that window (before
> > de_thread() switches pids) any private signal (even SIGKILL) sent to the
> > main thread will be silently lost.
> 
> This is the big problem with exec that I've cited before.  It can even
> happen with group-wide signals that should be fatal, but avoided the
> __group_complete_signal special fatal case.  (e.g. the thread racing with
> the exec thread just now unblocked the signal and dequeued it.)  IIRC it
> was the biggest reason we wanted to revisit the whole MT exec plan.

Oh. Could you clarify? Afaics, currently exec() can't miss the fatal group
signal?

> > We can change __group_complete_signal/zap_other_threads so that they won't
> > do sigaddset(), just signal_wake_up(). But in that case dequeue_signal()
> > and recalc_signal() should take signal_group_exit into account...
> 
> I'd like to revisit the use of "fake" SIGKILL for group exits.  That goes
> well with a rethink of MT exec.  But let's not get into all of that right now.

Yes.

Oleg.

