Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbZLETWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbZLETWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 14:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbZLETW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 14:22:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757935AbZLETW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 14:22:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/utrace
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
In-Reply-To: Oleg Nesterov's message of  Wednesday, 2 December 2009 19:49:38 +0100 <20091202184938.GB14799@redhat.com>
References: <20091124200220.GA5828@redhat.com>
	<1259697242.1697.1075.camel@laptop>
	<20091202184938.GB14799@redhat.com>
X-Zippy-Says: I pretend I'm living in a styrofoam packing crate, high in th'
    SWISS ALPS, still unable to accept th' idea of TOUCH-TONE
    DIALING!!
Message-Id: <20091205191432.5FD8F39C46@pipsqueak.sf.frob.com>
Date: Sat,  5 Dec 2009 11:14:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	 * Some machines get here with interrupts disabled.  The same arch
> > > +	 * code path leads to calling into get_signal_to_deliver(), which
> > > +	 * implicitly reenables them by virtue of spin_unlock_irq.
> > > +	 */
> > > +	local_irq_enable();
> >
> > Hrmm, I would much prefer to fix up the calling conventions of
> > tracehook_notify_resume() than to bury something like this in the guts
> > of a tracehook user.

The reason I did it this way was mainly just not to make the requirement
for arch maintainers' too subtle.  As it is, we just say that you call
tracehook_notify_resume() after clearing TIF_NOTIFY_RESUME, when it was
set.  That keeps the specification quite simple.  Of course, that is not
really much of a reason.  If arch folks don't mind the requirement to
replace e.g.:

	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
		clear_thread_flag(TIF_NOTIFY_RESUME);
		tracehook_notify_resume(regs);
	}

with:


	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
		local_irq_enable();
		clear_thread_flag(TIF_NOTIFY_RESUME);
		tracehook_notify_resume(regs);
	}

then that is certainly fine by me.  But we do now have almost all the
arch's calling tracehook_notify_resume() and I don't know how many of
them do it in irqs-disabled context so they would need this change.

> But in any case, imho it would be better to do this after we merge utrace,
> otherwise we need more subtle arch-dependent changes before.

I tend to agree.


Thanks,
Roland
