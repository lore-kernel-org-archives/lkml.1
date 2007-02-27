Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbXB0QBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbXB0QBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbXB0QBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:01:17 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2406 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062AbXB0QBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:01:16 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Feb 2007 08:01:05 -0800 (PST)
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
In-Reply-To: <20070227101332.GB23170@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702270751120.5315@alien.or.mcafeemobile.com>
References: <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu>
 <20070225180910.GA29821@2ka.mipt.ru> <20070225190414.GB6460@elte.hu>
 <20070225194250.GA1353@2ka.mipt.ru> <20070226123922.GA1370@elte.hu>
 <20070226140500.GA31629@2ka.mipt.ru> <20070226141518.GA24683@elte.hu>
 <20070226165513.GB22454@2ka.mipt.ru> <Pine.LNX.4.64.0702261811550.4949@alien.or.mcafeemobile.com>
 <20070227101332.GB23170@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007, Evgeniy Polyakov wrote:

> On Mon, Feb 26, 2007 at 06:18:51PM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> > On Mon, 26 Feb 2007, Evgeniy Polyakov wrote:
> > 
> > > 2. its notifications do not go through the second loop, i.e. it is O(1),
> > > not O(ready_num), and notifications happens directly from internals of
> > > the appropriate subsystem, which does not require special wakeup
> > > (although it can be done too).
> > 
> > Sorry if I do not read kevent code correctly, but in kevent_user_wait() 
> > there is a:
> > 
> >     while (num < max_nr && ((k = kevent_dequeue_ready(u)) != NULL)) {
> >         ...
> >     }
> > 
> > loop, that make it O(ready_num). From a mathematical standpoint, they're 
> > both O(ready_num), but epoll is doing three passes over the ready set.
> > I always though that if the number of ready events is so big that the more 
> > passes over the ready set becomes relevant, probably the "work" done by 
> > userspace for each fetched event would make the extra cost irrelevant.
> > But that can be fixed by a patch that will follow on lkml ...
>  
> No, kevent_dequeue_ready() copies data to userspace, that is it.
> So it looks roughly following:

In all the books where I studied, the algorithms below would be classified 
as O(num_ready) ones:

[sys_kevent_wait]
+	for (i=0; i<num; ++i) {
+		k = kevent_dequeue_ready_ring(u);
+		if (!k)
+			break;
+		kevent_complete_ready(k);
+
+		if (k->event.ret_flags & KEVENT_RET_COPY_FAILED)
+			break;
+		kevent_stat_ring(u);
+		copied++;
+	}

[kevent_user_wait]
+	while (num < max_nr && ((k = kevent_dequeue_ready(u)) != NULL)) {
+		if (copy_to_user(buf + num*sizeof(struct ukevent),
+					&k->event, sizeof(struct ukevent))) {
+			if (num == 0)
+				num = -EFAULT;
+			break;
+		}
+		kevent_complete_ready(k);
+		++num;
+		kevent_stat_wait(u);
+	}

It does not matter if inside the loop you invert a 20Kx20K matrix or you 
copy a byte, they both are O(num_ready).



- Davide


