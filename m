Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbXBNLMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbXBNLMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 06:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXBNLMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 06:12:37 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34871 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXBNLMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 06:12:36 -0500
Date: Wed, 14 Feb 2007 14:10:35 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070214111035.GB32612@2ka.mipt.ru>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org> <20070213165642.GB16394@elte.hu> <20070213185636.GA23987@2ka.mipt.ru> <20070213221810.GF22104@elte.hu> <20070214085939.GA4665@2ka.mipt.ru> <20070214103731.GB6801@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070214103731.GB6801@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Wed, 14 Feb 2007 14:10:49 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:37:31AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > Let me clarify what I meant. There is only limited number of threads, 
> > which are supposed to execute blocking context, so when all they are 
> > used, main one will block too - I asked about possibility to reuse the 
> > same thread to execute queue of requests attached to it, each request 
> > can block, but if blocking issue is removed, it would be possible to 
> > return.
> 
> ah, ok, i understand your point. This is not quite possible: the 
> cachemisses are driven from schedule(), which can be arbitraily deep 
> inside arbitrary system calls. It can be in a mutex_lock() deep inside a 
> driver. It can be due to a alloc_pages() call done by a kmalloc() call 
> done from within ext3, which was called from the loopback block driver, 
> which was called from XFS, which was called from a VFS syscall.

That's only because of schedule() is a main point where
'rescheduling'/requeuing (task switch in other words) happens - but if
it will be possible to bypass schedule()'s decision and not reschedule
there, but 'on demand', will it be possible to reuse the same syslet?

Let me show an example:
consider aio_sendfile() on a big file, so it is not possible to fully
get it into VFS, but having spinning on per-page basis (like right now)
is no optial solution too. For kevent AIO I created new address space
operation aio_getpages() which is essentially mpage_readpages() - it
populates several pages into VFS in one BIO (if possible, otherwise in
the smallest possible number of chunks) and then in bio destruction
callback (actually in bio_endio callback, but for that case it can be
considered as the same) I reschedule the same request to some other (not
exactly the same as started) thread. When processed data is being sent
and next chunk of the file is populated to the VFS using aio_getpages(),
which in BIO callback will reschedule the same request again.

So it is possible with essentially one thread (or limited number of
them) to fill the whole IO pipe.

With syslet approach it seems to be impossible due to the fact, that
request is a whole sendfile. Even if one uses proper readahed (fadvise)
advise, there is no possibility to split sendfile and form it as a set
of essentially the same requests with different start/offset/whatever
parameters (well, exactly for senfile() it is possible - just setup
several calls in one syslet from different offsets and with different
lengths and form a proper state machine of them, but for example TCP 
recv() will not match that scenario).

So my main question was about possibility to reuse syslet state machine
in kevent AIO instead of own (althtough own one lacks only one good 
feature of syslets threads currently - its set of threads is global, 
but not per-task, which does not allow to scale good with number of 
different processes doing IO) so to not duplicate the code if kevent is
ever be possible to get into.

-- 
	Evgeniy Polyakov
