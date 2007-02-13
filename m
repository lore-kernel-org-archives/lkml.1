Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXBMWvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXBMWvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXBMWvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:51:01 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:3857 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXBMWvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:51:00 -0500
Date: Tue, 13 Feb 2007 23:50:56 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213225056.GC68966@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Ingo Molnar <mingo@elte.hu>,
	Davide Libenzi <davidel@xmailserver.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@zip.com.au>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ulrich Drepper <drepper@redhat.com>,
	Zach Brown <zach.brown@oracle.com>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20070213142010.GA638@elte.hu> <Pine.LNX.4.64.0702131219240.32055@alien.or.mcafeemobile.com> <20070213215724.GD22104@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213215724.GD22104@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 10:57:24PM +0100, Ingo Molnar wrote:
> 
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > > Open issues:
> 
> > If this is going to be a generic AIO subsystem:
> > 
> > - Cancellation of pending request
> 
> How about implementing aio_cancel() as a NOP. Can anyone prove that the 
> kernel didnt actually attempt to cancel that IO? [but unfortunately 
> failed at doing so, because the platters were being written already.]
> 
> really, what's the point behind aio_cancel()?

Lemme give you a real-world scenario: Question Answering in a Dialog
System.  Your locked-in-memory index ranks documents in a several
million files corpus depending of the chances they have to have what
you're looking for.  You have a tenth of a second to read as many of
them as you can, and each seek is 5ms.  So you aio-read them,
requesting them in order of ranking up to 200 or so, and see what you
have at the 0.1s deadline.  If you're lucky, a combination of cache
(especially if you stat() the whole dir tree on a regular basis to
keep the metadata fresh in cache) and of good io reorganisation by the
scheduler will allow you to get a good number of them and do the
information extraction, scoring and clustering of answers, which is
pure CPU at that point.  You *have* to cancel the remaining i/o
because you do not want the disk saturated when the next request
comes, especially if it's 10ms later because the dialog manager found
out it needed a complementary request.

Incidentally, that's something I'm currently implementing for work,
making these aio discussions more interesting that usual :-)

  OG.
