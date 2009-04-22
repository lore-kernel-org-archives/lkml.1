Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZDVPM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZDVPM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZDVPMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:12:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45817 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbZDVPMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:12:16 -0400
Date: Wed, 22 Apr 2009 17:07:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Trond.Myklebust@netapp.com,
       serue@us.ibm.com, steved@redhat.com, viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a
	full memory barrier
Message-ID: <20090422150718.GA3583@redhat.com>
References: <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <20090422135134.GA5249@elte.hu> <20090422143930.GA1212@redhat.com> <20090422145658.GA15088@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422145658.GA15088@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > So, I think that try_to_wake_up() implies that the LOADS after it
> > can't be reordered with STOREs before it (and wmb() of course).
>
> Note that the patch David sent says "full memory barrier", not "full
> memory barrier wrt. task->state":
>
> + (*) wake_up(), try_to_wake_up() and co. imply a full memory barrier.
> +
> + (*) complete() and co. imply a full memory barrier.
>
> These statements are not true in that form, as this code does not
> imply a full memory barrier. It does imply one on task->state
> _alone_ (and a couple of other wq-internal variables it happens to
> read for sure).
>
> But even that one isnt entirely true in the two sub-cases i noted:
> the !wq case (which can happen in object state teardown) and the
> special ->func handler (which can happen in custom wakeup code a'la
> eventpoll).
>
> So adding a comment that says "this is a full memory barrier" is
> simply not true to that extent, and is easily misunderstood. Adding
> "this is a fully memory barrier for task->state dependent data flow"
> would be more correct. (with a 'as long as wq is not NULL, and as
> long as the code using this isnt overriding ->func)
>
> Agreed?

Yes sure.

Except... not that it really matters, but the reading of ->state is
not "special". I mean,

	STORE;
	try_to_wake_up();
	LOAD;

in this case try_to_wake_up() acts as a barrier for STORE/LOAD. But
probably we should not rely on this. So personally I agree with
"for task->state dependent data flow" above.

Oleg.

