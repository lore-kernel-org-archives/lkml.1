Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbXB0Q61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbXB0Q61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbXB0Q60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:58:26 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:49130 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXB0Q60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:58:26 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Tue, 27 Feb 2007 17:58:14 +0100
User-Agent: KMail/1.9.5
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070225180910.GA29821@2ka.mipt.ru> <Pine.LNX.4.64.0702270751120.5315@alien.or.mcafeemobile.com> <20070227162109.GA22844@2ka.mipt.ru>
In-Reply-To: <20070227162109.GA22844@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702271758.15004.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 February 2007 17:21, Evgeniy Polyakov wrote:
> I probably selected wrong words to desribe, here is in details how
> kevent differs from epoll.
>
> Polling case need to perform additional check before event can be copied
> to userspace, that check must be done for each even being copied.
> Kevent does not need that (it needs it for poll emulation) - if event is
> ready, then it is ready.
>
> sys_poll() create a wait queue where different events (callbacks for
> them) are stored, when driver calls wake_up() appropriate event is added
> to the ready list and calls wake_up() for that wait queue, which in turn
> calls ->poll for each event and transfer it to userspace if it is ready.
>
> Kevent works slightly different - it does not perform additional check
> for readiness (although it can, and it does in poll notifications), if
> event is marked as ready, parked in waiting syscal thread is awakened
> and event is copied to userspace.
> Also waiting syscall is awakened through one queue - event is added
> and wake_up() is called, while in epoll() there are two queues.

Thank you Evgeniy for this comparison. poll()/select()/epoll() are tricky 
indeed.

I believe one advantage of epoll is it uses standard mechanism (mandated for 
poll()/select() ), while kevent adds some glue and kevent_storage in some 
structures (struct inode, struct file, ...), thus adding some extra code and 
extra storage in hot paths. Yes there might be a gain IF most users of these 
path want kevent. But other users pay the price (larger kernel code and 
data), that you cannot easily bench.

Using or not epoll has nearly zero cost over standard kernel (only struct file 
has some extra storage)

