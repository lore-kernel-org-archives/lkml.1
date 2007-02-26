Return-Path: <linux-kernel-owner+w=401wt.eu-S1030321AbXBZUC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321AbXBZUC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030510AbXBZUC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:02:57 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1026 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030321AbXBZUC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:02:57 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Feb 2007 12:02:51 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070226103117.GA16101@elte.hu>
Message-ID: <Pine.LNX.4.64.0702261149140.1881@alien.or.mcafeemobile.com>
References: <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu>
 <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu>
 <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu>
 <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com>
 <20070226081655.GA25280@elte.hu> <20070226092545.GA4110@2ka.mipt.ru>
 <20070226095547.GA9485@elte.hu> <20070226103117.GA16101@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > please also try evserver_epoll_threadlet.c that i've attached below - 
> > it uses epoll as the main event mechanism but does threadlets for 
> > request handling.
> 
> find updated code below - your evserver_epoll.c spuriously missed event 
> edges - so i changed it back to level-triggered. While that is not as 
> fast as edge-triggered, it does not result in spurious hangs and 
> workflow 'hickups' during the test.
> 
> Could this be the reason why in your testing kevents outperformed epoll?

This is how I handle a read (write/accept/connect, same thing) inside 
coronet (coroutine+epoll async library - http://www.xmailserver.org/coronet-lib.html ).


static int conet_read_ll(struct sk_conn *conn, char *buf, int nbyte) {
        int n;
        
        while ((n = read(conn->sfd, buf, nbyte)) < 0) {
                if (errno == EINTR)
                        continue;
                if (errno != EAGAIN && errno != EWOULDBLOCK)
                        return -1;
                if (!(conn->events & EPOLLIN)) {
                        conn->events = EPOLLIN;
                        if (conet_mod_conn(conn, conn->events) < 0)
                                return -1;
                }
                if (conet_yield(conn) < 0)
                        return -1;
        }
                        
        return n;
}

I use EPOLLET and, you don't change the interest set until you actually 
get an EAGAIN. *Many* read/write mode changes in the usage will simply 
happen w/out an epoll_ctl() needed. The conet_mod_conn() function does the 
actual epoll_ctl() and add EPOLLET to the specified event set. The 
conet_yield() function end up calling the libpcl's co_resume(), that is 
basically a switch-to-next-coroutine-until-fd-becomes-ready (maps 
directly to a swapcontext).
That cuts 50+% of the epoll_ctl(EPOLL_CTL_MOD).




- Davide


