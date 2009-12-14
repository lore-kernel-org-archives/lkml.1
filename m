Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbZLNUav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbZLNUav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbZLNUar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:30:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbZLNUaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:30:46 -0500
Date: Mon, 14 Dec 2009 21:24:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091214202454.GA16124@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop> <20091214002533.3052519@magilla.sf.frob.com> <20091214170327.GA7666@redhat.com> <20091214194441.4D6BFE24E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214194441.4D6BFE24E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Roland McGrath wrote:
>
> > > In the stopped cases, there are lots of locks and barriers and things
> > > after resuming.  (Oleg?)
> >
> > Every time the tracee resumes after TASK_TRACED it uses utrace->lock
> > to synchronize with utrace_control/etc, it must see any changes.
>
> And TASK_STOPPED?

SIGCONT can wake up the TASK_STOPPED tracee. I don't think the tracer
should ever rely on TASK_STOPPED (utrace never does). If the tracer
needs the "really stopped" tracee we have UTRACE_STOP, and this means
TASK_TRACED.

But I am not sure I understand this part of discussion... In any case
the tracee should see any changes which were done before the wakeup.
But TASK_STOPPED can't guarantee the tracee won't be resumed until
the tracer wakes it up. Of course, TASK_TRACED can't prevent SIGKILL,
but in this case we should only care about "the tracee can't resume
until we drop utrace->lock" case.

Oleg.

