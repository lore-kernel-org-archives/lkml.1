Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZHCSKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZHCSKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZHCSKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:10:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55243 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbZHCSKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:10:31 -0400
Date: Mon, 3 Aug 2009 20:06:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: [PATCH 3/2] fcntl: F_[SG]ETOWN_TID
Message-ID: <20090803180602.GA19719@redhat.com>
References: <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins> <20090803171619.GA17876@redhat.com> <1249321637.7924.163.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249321637.7924.163.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Peter Zijlstra wrote:
>
> On Mon, 2009-08-03 at 19:16 +0200, Oleg Nesterov wrote:
>
> > Hmm, OK. so fcntl(F_SETOWN_TID, -666) <=> fcntl(F_SETOWN, +666).
> >
> > Not that I disagree, but I think this should be discussed. Perhaps
> > F_SETOWN_TID can just reject who < 0.
>
> Yeah, I considered that. Opinions?

Yes, please ;)

> > but the caller of F_GETOWN can't know what the returned value actually
> > means if F_GETOWN_TID was used.
>
> Ah, I made GETOWN_TID deal with !PID but forgot the TID case in GETOWN.
> Yeah, icky, esp since there is no room for errors in the return value :/
> I guess I could make it return 0.

Yes, this is confusing too, but probably better.

> > Perhaps we can just add
> >
> > 	#define F_PIDTYPE_THREAD	PIDTYPE_MAX
> >
> > into fcntl.c ? Then,
> >
> Right, I considered adding PIDTYPE_TID, but then I'd have to go through
> the kernel and make everything consistent, which is where I gave up ;-)

Note! we don't add the new PIDTYPE_TID actually. This F_PIDTYPE_THREAD
is not visible outsie of fcntl.c, we just re-use ->pid_type. Instead
we could add a bit, but using the impossible PIDTYPE_MAX is simpler.

> dunno if people will go for it though..

Yes, I am not sure people will like it.


As for F_XXXOWN/F_XXXWOWN_TID interaction. Another option, perhaps, is add
F_{SET,GET}OWN_EX which accepts a use-visible

	struct f_setown_struct {
		int pid;		// > 0
		int type;		// enumerates PIDTYPE_PID, PIDTYPE_PGID, F_PIDTYPE_THREAD
	}

pointer via arg. Instead of F_XXXOWN_TID + int who.

This way at least the users of new api can't be confused.

I dunno.

Oleg.

