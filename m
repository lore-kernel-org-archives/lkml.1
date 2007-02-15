Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXBOSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXBOSDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030410AbXBOSDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:03:18 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42912 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030405AbXBOSDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:03:17 -0500
Date: Thu, 15 Feb 2007 21:01:18 +0300
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
Message-ID: <20070215180117.GB20997@2ka.mipt.ru>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <Pine.LNX.4.64.0702150847420.10697@alien.or.mcafeemobile.com> <20070215171721.GA1664@2ka.mipt.ru> <Pine.LNX.4.64.0702150926470.10697@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702150926470.10697@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 15 Feb 2007 21:01:23 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 09:39:33AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> On Thu, 15 Feb 2007, Evgeniy Polyakov wrote:
> 
> > On Thu, Feb 15, 2007 at 09:05:13AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> > > 
> > > I actually think that building chains of syscalls bring you back to a 
> > > multithreaded solution. Why? Because suddendly the service thread become 
> > > from servicing a syscall (with possible cachehit optimization), to 
> > > servicing a whole session. So the number of service threads needed (locked 
> > > down by a chain) becomes big because requests goes from being short-lived 
> > > syscalls to long-lived chains of them. Think about the trivial web server, 
> > > and think about a chain that does open->fstat->sendhdrs->sendfile after an 
> > > accept. What's the difference with a multithreaded solution that does 
> > > accept->clone and execute the above code in the new thread? Nada, NIL.
> > 
> > That is more ideological question about micro-thread design at all.
> > If syslet will be able to perform only one syscall, one will have 4
> > threads for above case, not one, so it is even more broken.
> 
> Nope, just one thread. Well, two, if you consider the "main" dispatch 
> thread, and the syscall service thread.
 
Argh, if they are supposed to run synchronously, for example stat can be
done in parallel with sendfile in above example, but generally yes, one
execution thread.
 
> > So, if Linux moves that way of doing AIO (IMO incorrect, I think that
> > the correct state machine made not of syscalls, but specially crafted
> > entries - like populate pages into VFS, send chunk, recv chunk without
> > blocking and continue on completion and the like), syslets with attached 
> > state machines are the (smallest evil) best choice.
> 
> But at that point you don't need to have complex atom interfaces, with 
> chains, whips and leather pants :) Just code it in C and submit that to 
> the async engine. The longer is the chain though, the closer you get to a 
> fully multithreaded solution, in terms of service thread consuption. And 
> what do you save WRT a multithreaded solution? Not thread 
> creation/destroy, because that cost is fully amortized inside the chain 
> execution cost (plus a pool would even save that).
> IMO the plus of a generic async engine is mostly from a kernel code 
> maintainance POV. You don't need anymore to have AIO-aware code paths, 
> that automatically transalte to smaller and more maintainable code.
 
It is completely possible to not wire up several syscalls and just use
only one per async call, but _if_ such a requirement rises, the whole
infrastructure is there. 
 
> - Davide
> 

-- 
	Evgeniy Polyakov
