Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZLNRJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZLNRJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbZLNRJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:09:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758007AbZLNRJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:09:31 -0500
Date: Mon, 14 Dec 2009 18:03:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091214170327.GA7666@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop> <20091214002533.3052519@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214002533.3052519@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Roland McGrath wrote:
>
> > Its not entirely clear why we can check pending_attach outside of the
> > utrace->lock and not be racy.
>
> I think it can be racy sometimes but that does not matter.
> Maybe Oleg can verify my logic here.  If it's right, he can
> add some comments to make it more clear.
>
> There is only a very limited sort of "timeliness" guarantee about
> getting your callbacks after utrace_attach_task()+utrace_set_events().
> If you know somehow that the task was definitely still in TASK_STOPPED
> or TASK_TRACED after utrace_attach_task() returned, then your engine
> gets all possible callbacks starting from when it resumes.  Otherwise,
> you can use utrace_control() with UTRACE_REPORT to ask to get some
> callback "pretty soon".  The only callback events you are ever 100%
> guaranteed about (after success return from utrace_set_events()) are for
> DEATH and REAP, which have an unconditional lock-and-check before making
> engine callbacks.

Yes, I think this is correct. It is fine to miss ->pending_attach == T,
and in any case the new attacher can come right after the check, even
if it was checked under utrace->lock.

It is important that the tracee can't miss, say, UTRACE_REPORT request
(as you already explained), and every time the tracee clears ->resume
it calls splice_attaching().

> In the stopped cases, there are lots of locks and barriers and things
> after resuming.  (Oleg?)

Every time the tracee resumes after TASK_TRACED it uses utrace->lock
to synchronize with utrace_control/etc, it must see any changes.

Oleg.

