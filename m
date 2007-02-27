Return-Path: <linux-kernel-owner+w=401wt.eu-S933073AbXB0QX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbXB0QX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXB0QX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:23:59 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49660 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXB0QX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:23:58 -0500
Date: Tue, 27 Feb 2007 19:21:09 +0300
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
Message-ID: <20070227162109.GA22844@2ka.mipt.ru>
References: <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu> <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu> <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu> <20070226165513.GB22454@2ka.mipt.ru> <Pine.LNX.4.64.0702261811550.4949@alien.or.mcafeemobile.com> <20070227101332.GB23170@2ka.mipt.ru> <Pine.LNX.4.64.0702270751120.5315@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702270751120.5315@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 19:22:15 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 08:01:05AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> It does not matter if inside the loop you invert a 20Kx20K matrix or you 
> copy a byte, they both are O(num_ready).

I probably selected wrong words to desribe, here is in details how
kevent differs from epoll.

Polling case need to perform additional check before event can be copied
to userspace, that check must be done for each even being copied.
Kevent does not need that (it needs it for poll emulation) - if event is
ready, then it is ready.

sys_poll() create a wait queue where different events (callbacks for
them) are stored, when driver calls wake_up() appropriate event is added 
to the ready list and calls wake_up() for that wait queue, which in turn 
calls ->poll for each event and transfer it to userspace if it is ready.

Kevent works slightly different - it does not perform additional check
for readiness (although it can, and it does in poll notifications), if
event is marked as ready, parked in waiting syscal thread is awakened
and event is copied to userspace.
Also waiting syscall is awakened through one queue - event is added
and wake_up() is called, while in epoll() there are two queues.

> - Davide
> 

-- 
	Evgeniy Polyakov
