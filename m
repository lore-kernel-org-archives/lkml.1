Return-Path: <linux-kernel-owner+w=401wt.eu-S1030293AbXBORXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbXBORXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030294AbXBORXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:23:30 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42551 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030293AbXBORX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:23:29 -0500
Date: Thu, 15 Feb 2007 20:17:21 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20070215171721.GA1664@2ka.mipt.ru>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <Pine.LNX.4.64.0702150847420.10697@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702150847420.10697@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 15 Feb 2007 20:17:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 09:05:13AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> On Thu, 15 Feb 2007, Linus Torvalds wrote:
> 
> > I don't think the "atom" approach is bad per se. I think it could be fine 
> > to have some state information in user space. It's just that I think 
> > complex interfaces that people largely won't even use is a big mistake. We 
> > should concentrate on usability first, and some excessive cleverness 
> > really isn't a big advantage.
> > 
> > Being able to do a "open + stat" looks like a fine thing. But I doubt 
> > you'll see a lot of other combinations.
> 
> I actually think that building chains of syscalls bring you back to a 
> multithreaded solution. Why? Because suddendly the service thread become 
> from servicing a syscall (with possible cachehit optimization), to 
> servicing a whole session. So the number of service threads needed (locked 
> down by a chain) becomes big because requests goes from being short-lived 
> syscalls to long-lived chains of them. Think about the trivial web server, 
> and think about a chain that does open->fstat->sendhdrs->sendfile after an 
> accept. What's the difference with a multithreaded solution that does 
> accept->clone and execute the above code in the new thread? Nada, NIL.

That is more ideological question about micro-thread design at all.
If syslet will be able to perform only one syscall, one will have 4
threads for above case, not one, so it is even more broken.

So, if Linux moves that way of doing AIO (IMO incorrect, I think that
the correct state machine made not of syscalls, but specially crafted
entries - like populate pages into VFS, send chunk, recv chunk without
blocking and continue on completion and the like), syslets with attached 
state machines are the (smallest evil) best choice.

> Actually, there is a difference. The standard multithreaded function is 
> easier to code in C than with the complex atoms chains. The number of 
> service thread becomes suddendly proportional to the number of active 
> sessions.
> The more I look at this, the more I think that async_submit should submit 
> simple syscalls, or an array of them (unrelated/parallel).
 
That is the case - atom items (I do hope that this subsystem would be
able to perform not only syscalls, but any kernel interfaces suitable
prototypes, v2 seems to move that direction) are called asynchronously 
from main userspace thread to achieve the maximum performance.
 
> - Davide
> 

-- 
	Evgeniy Polyakov
