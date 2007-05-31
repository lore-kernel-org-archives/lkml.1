Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbXEaGOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbXEaGOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbXEaGOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:14:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbXEaGOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:14:10 -0400
Date: Thu, 31 May 2007 08:13:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070531061303.GA4436@elte.hu>
References: <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org> <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301457350.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705301457350.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > I agree. What would be a good interface to allocate fds in such 
> > area? We don't want to replicate syscalls, so maybe a special new 
> > dup function?
> 
> I'd do it with something like "newfd = dup2(fd, NONLINEAR_FD)" or 
> similar, and just have NONLINEAR_FD be some magic value (for example, 
> make it be 0x40000000 - the bit that says "private, nonlinear" in the 
> first place).
> 
> But what's gotten lost in the current discussion is that we probably 
> don't actually _need_ such a private space. I'm just saying that if 
> the *choice* is between memory-mapped interfaces and a private 
> fd-space, we should probably go for the latter. "Everything is a file" 
> is the UNIX way, after all. But there's little reason to introduce 
> private fd's otherwise.

it's both a flexibility and a speedup thing as well:

flexibility: for libraries to be able to open files and keep them open 
comes up regularly. For example currently glibc is quite wasteful in a 
number of common networking related functions (Ulrich, please correct me 
if i'm wrong), which could be optimized if glibc could just keep a 
netlink channel fd open and could poll() it for changes and cache the 
results if there are no changes (or something like that).

speedup: i suggested O_ANY 6 years ago as a speedup to Apache - 
non-linear fds are cheaper to allocate/map:

  http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg23820.html

(i definitely remember having written code for that too, but i cannot 
find that in the archives. hm.) In theory we could avoid _all_ fd-bitmap 
overhead as well and use a per-process list/pool of struct file buffers 
plus a maximum-fd field as the 'non-linear fd allocator' (at the price 
of only deallocating them at process exit time).

	Ingo
