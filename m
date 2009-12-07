Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbZLGNAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbZLGNAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbZLGNAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:00:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbZLGNAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:00:40 -0500
Date: Mon, 7 Dec 2009 13:54:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Miloslav Trmac <mitr@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Veaceslav Falico <vfalico@redhat.com>
Subject: Re: [PATCH v2 4/4] copy_signal cleanup: clean tty_audit_fork()
Message-ID: <20091207125427.GA4843@redhat.com>
References: <1536386836.1223191260112270565.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <2003788136.1223211260112670844.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2003788136.1223211260112670844.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Miloslav Trmac wrote:
>
> ----- "Oleg Nesterov" <oleg@redhat.com> wrote:
> > On 12/05, Miloslav Trmac wrote:
> > > > Off-topic question to this who understands this code.
> > > >
> > > > But afaics we can also remove ->siglock from this helper and make
> > > > it really trivial for being inline. ->siglock buys nothing, we just
> > > > read a boolean. In fact, after the quick grep I do not understand
> > > > how ->siglock is connected to ->audit_tty. OK, it protects
> > > > tty_audit_buf,
> > > > but why we always take ->siglock to access ->audit_tty ?
> > > AFAIK there is no explicit documentation of the atomicity semantics
> > > expected by the Linux kernel (both from the hardware and from the compiler),
> > > so every access to the boolean is protected by a lock, to be on the safe side.
> >
> > Not sure I understand, but the kernel relies on fact it is always safe
> > to load/store a word.
> And is "word" an "unsigned", "unsigned long" or "intptr_t"?  Must it be
> suitably aligned, and if so, what is "suitably"?

Sure, it must be aligned.

> Where is this documented?

Perhaps nowhere, I do not know. If this is not documented, probably
it would be nice to add a note.

> > What atomicity semantics do you mean and how ->siglock can help?
> At the very least, "any access will read the last value stored and not result
> in undefined behavior, even if other threads attempt to access the value".
> In user-space, per POSIX, the only way to guarantee this is using explicit
> synchronization primitives.

We have numerous examples in kernel code which rely on this fact.

If we are talking about copy_process() pathes, please look at, say,
sched_fork(). Say, we read current->normal_prio lockless, while another
thread could change ->normal_prio in parallel.

Oleg.

