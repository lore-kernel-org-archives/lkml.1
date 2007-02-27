Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXB0KTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXB0KTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXB0KTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:19:05 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52271 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbXB0KTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:19:03 -0500
Date: Tue, 27 Feb 2007 13:13:32 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070227101332.GB23170@2ka.mipt.ru>
References: <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu> <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu> <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu> <20070226165513.GB22454@2ka.mipt.ru> <Pine.LNX.4.64.0702261811550.4949@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702261811550.4949@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 13:14:28 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 06:18:51PM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> On Mon, 26 Feb 2007, Evgeniy Polyakov wrote:
> 
> > 2. its notifications do not go through the second loop, i.e. it is O(1),
> > not O(ready_num), and notifications happens directly from internals of
> > the appropriate subsystem, which does not require special wakeup
> > (although it can be done too).
> 
> Sorry if I do not read kevent code correctly, but in kevent_user_wait() 
> there is a:
> 
>     while (num < max_nr && ((k = kevent_dequeue_ready(u)) != NULL)) {
>         ...
>     }
> 
> loop, that make it O(ready_num). From a mathematical standpoint, they're 
> both O(ready_num), but epoll is doing three passes over the ready set.
> I always though that if the number of ready events is so big that the more 
> passes over the ready set becomes relevant, probably the "work" done by 
> userspace for each fetched event would make the extra cost irrelevant.
> But that can be fixed by a patch that will follow on lkml ...
 
No, kevent_dequeue_ready() copies data to userspace, that is it.
So it looks roughly following:

storage is ready: -> kevent_requee() - ends up in ading event to the end
of the queue (list add under spinlock)

kevent_wait() -> copy first, second, ...

Kevent poll (as long as epoll) model requires _additional_ check in 
userspace context before it is copied, so we endup with checking the 
full ready queue again - that what I pointed as O(ready_num), O() implies 
price for copying to userspace, list_add and so on.
 
> - Davide
> 

-- 
	Evgeniy Polyakov
