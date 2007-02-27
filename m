Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbXB0TUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbXB0TUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXB0TUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:20:52 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3136 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXB0TUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:20:51 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Feb 2007 11:20:48 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
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
In-Reply-To: <20070227162109.GA22844@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702271107420.3692@alien.or.mcafeemobile.com>
References: <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu>
 <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu>
 <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu>
 <20070226165513.GB22454@2ka.mipt.ru> <Pine.LNX.4.64.0702261811550.4949@alien.or.mcafeemobile.com>
 <20070227101332.GB23170@2ka.mipt.ru> <Pine.LNX.4.64.0702270751120.5315@alien.or.mcafeemobile.com>
 <20070227162109.GA22844@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007, Evgeniy Polyakov wrote:

> I probably selected wrong words to desribe, here is in details how
> kevent differs from epoll.
> 
> Polling case need to perform additional check before event can be copied
> to userspace, that check must be done for each even being copied.
> Kevent does not need that (it needs it for poll emulation) - if event is
> ready, then it is ready.

That could be changed too. The "void *key" doesn't need to be NULL. Wake 
ups to f_op->poll() waiters can use that to send ready events directly, 
avoiding an extra f_op->poll() to fetch them.
Infrastructure is already there, just need a big patch to do it everywhere ;)



> Kevent works slightly different - it does not perform additional check
> for readiness (although it can, and it does in poll notifications), if
> event is marked as ready, parked in waiting syscal thread is awakened
> and event is copied to userspace.
> Also waiting syscall is awakened through one queue - event is added
> and wake_up() is called, while in epoll() there are two queues.

The really ancient version of epoll (called /dev/epoll at that time) was 
doing a very similar thing. Was adding custom plugs is all over the places 
where we wanted to get events from, and was collecting them w/out 
resorting to extra f_op->poll(). Event masks going straight through an 
event buffer.
The reason why the current design of epoll was chosen, was because:

o Was not requiring custom plus all over the places
o Was working with the current kernel abstractions as-is (though f_op->poll)




- Davide


