Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbXE3IoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbXE3IoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbXE3IoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:44:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbXE3IoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:44:01 -0400
Date: Wed, 30 May 2007 10:42:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530084252.GA15708@elte.hu>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465D286E.2080807@redhat.com>
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


* Ulrich Drepper <drepper@redhat.com> wrote:

> Ingo Molnar wrote:
> > 3 months ago i verified the published kevent vs. epoll benchmark and 
> > found that benchmark to be fatally flawed. When i redid it properly 
> > kevent showed no significant advantage over epoll.
> 
> I'm not going to judge your tests but saying there are no significant 
> advantages is too one-sided.  There is one huge advantage: the 
> interface.  A memory-based interface is simply the best form.  File 
> descriptors are a resource the runtime cannot transparently consume.

yeah - this is a fundamental design question for Linus i guess :-) glibc 
(and other infrastructure libraries) have a fundamental problem: they 
cannot (and do not) presently use persistent file descriptors to make 
use of kernel functionality, due to ABI side-effects. [applications can 
dup into an fd used by glibc, applications can close it - shells close 
fds blindly for example, etc.] Today glibc simply cannot open a file 
descriptor and keep it open while application code is running due to 
these problems.

we should perhaps enable glibc to have its separate fd namespace (or 
'hidden' file descriptors at the upper end of the fd space) so that it 
can transparently listen to netlink events (or do epoll), without 
impacting the application fd namespace - instead of ducking to a memory 
based API as a workaround.

it is a serious flexibility issue that should not be ignored. The 
unified fd space is a blessing on one hand because it's simple and 
powerful, but it's also a curse because nested use of the fd space for 
libraries is currently not possible. But it should be detached from any
fundamental question of kevent vs. epoll. (By improving library use of
file descriptors we'll improve the utility of all syscalls - by ducking
to a memory based API we only solve that particular event based usage.)

	Ingo
