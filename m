Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYAIXQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYAIXQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbYAIXPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:15:53 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46360 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbYAIXPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:15:52 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 9 Jan 2008 15:15:49 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
In-Reply-To: <200801100904.46842.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0801091503270.13306@alien.or.mcafeemobile.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
 <200801091448.46241.rusty@rustcorp.com.au> <47850F99.5020001@oracle.com>
 <200801100904.46842.rusty@rustcorp.com.au>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Rusty Russell wrote:

> On Thursday 10 January 2008 05:16:57 Zach Brown wrote:
> > > The latter.  A ring is optimal for processing a huge number of requests,
> > > but if you're really going to be firing off syslet threads all over the
> > > place you're not going to be optimal anyway.  And being able to point the
> > > return value to the stack or into some datastructure is way nicer to code
> > > (zero setup == easy to understand and easy to convert).
> >
> > One of Linus' rhetorical requirements for the syslets work is that we be
> > able to wait for the result without spending overhead building up state
> > in some completion context.  The userland rings in the current syslet
> > patches achieve that and don't seem outrageously complicated.
> 
> I'd have to read his original statement, but eventfd doesn't build up state, 
> so I think it qualifies.

I think you and Zach are talking about different issues ;)
Eventfd born for two different reasons. First, to be able to have 
userspace to signal to a poll/select/epoll based listener an event. This 
can elso be done with pipes, but eventfd has a few advantages over pipes 
(3-4 times faster and *a lot* less memory footprint). Second, as a generic 
way for kernel subsystems to signal completions to a poll/select/epoll 
userspace listener. And this is what is used in the new KAIO eventfd 
feature (patch was like 5 lines IIRC).
This allow for KAIO events to be signaled to poll/select/epoll in a pretty 
easy way, using a simple extension of the AIO API.
What we talked originally with Ingo, when the first syslet code came up, 
was the ability to do the reverse thing. That is, host an epoll_wait() 
inside a syslet, and gather the completion using whatever the syslet code 
was/is going to use for it.
Given that 1) the eventfd completion patch was trivial and immediately 
available 2) the future of the whole syslet concept was/is still unclear, 
I believe it makes/made sense. If the syslets will become mainline, it'll 
mean that userspace will then be able to select the event-completion 
"hosting" method that better suits their needs. That are, either AIO 
completion hosted inside an epoll_wait() via an eventfd, or an 
epoll_wait() hosted inside a syslet.




- Davide


