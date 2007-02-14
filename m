Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbXBNRR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbXBNRR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXBNRR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:17:59 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1361 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbXBNRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:17:58 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 09:17:50 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Benjamin LaHaise <bcrl@kvack.org>,
       Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
In-Reply-To: <20070214103731.GB6801@elte.hu>
Message-ID: <Pine.LNX.4.64.0702140909320.7480@alien.or.mcafeemobile.com>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
 <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org>
 <20070213165642.GB16394@elte.hu> <20070213185636.GA23987@2ka.mipt.ru>
 <20070213221810.GF22104@elte.hu> <20070214085939.GA4665@2ka.mipt.ru>
 <20070214103731.GB6801@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Ingo Molnar wrote:

> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
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
> 
> Even if it were possible to backtrack i'm quite sure we dont want to do 
> this, for three main reasons:

IMO it'd be quite simple. We detect the service-thread full condition, 
*before* entering exec_atom and we queue the atom in an async_head request 
list. Yes, there is the chance that from the test time in sys_async_exec, 
to the time we'll end up entering exec_atom and down to schedule, one 
of the threads would become free, but IMO better that blocking 
sys_async_exec.



- Davide


