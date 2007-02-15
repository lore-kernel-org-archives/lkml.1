Return-Path: <linux-kernel-owner+w=401wt.eu-S1030343AbXBORjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030343AbXBORjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030353AbXBORjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:39:39 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4712 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030343AbXBORjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:39:39 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 15 Feb 2007 09:39:33 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <20070215171721.GA1664@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702150926470.10697@alien.or.mcafeemobile.com>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702150847420.10697@alien.or.mcafeemobile.com>
 <20070215171721.GA1664@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Evgeniy Polyakov wrote:

> On Thu, Feb 15, 2007 at 09:05:13AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> > 
> > I actually think that building chains of syscalls bring you back to a 
> > multithreaded solution. Why? Because suddendly the service thread become 
> > from servicing a syscall (with possible cachehit optimization), to 
> > servicing a whole session. So the number of service threads needed (locked 
> > down by a chain) becomes big because requests goes from being short-lived 
> > syscalls to long-lived chains of them. Think about the trivial web server, 
> > and think about a chain that does open->fstat->sendhdrs->sendfile after an 
> > accept. What's the difference with a multithreaded solution that does 
> > accept->clone and execute the above code in the new thread? Nada, NIL.
> 
> That is more ideological question about micro-thread design at all.
> If syslet will be able to perform only one syscall, one will have 4
> threads for above case, not one, so it is even more broken.

Nope, just one thread. Well, two, if you consider the "main" dispatch 
thread, and the syscall service thread.



> So, if Linux moves that way of doing AIO (IMO incorrect, I think that
> the correct state machine made not of syscalls, but specially crafted
> entries - like populate pages into VFS, send chunk, recv chunk without
> blocking and continue on completion and the like), syslets with attached 
> state machines are the (smallest evil) best choice.

But at that point you don't need to have complex atom interfaces, with 
chains, whips and leather pants :) Just code it in C and submit that to 
the async engine. The longer is the chain though, the closer you get to a 
fully multithreaded solution, in terms of service thread consuption. And 
what do you save WRT a multithreaded solution? Not thread 
creation/destroy, because that cost is fully amortized inside the chain 
execution cost (plus a pool would even save that).
IMO the plus of a generic async engine is mostly from a kernel code 
maintainance POV. You don't need anymore to have AIO-aware code paths, 
that automatically transalte to smaller and more maintainable code.



- Davide


