Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXB1W3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXB1W3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXB1W3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:29:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35292 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561AbXB1W3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:29:07 -0500
Date: Wed, 28 Feb 2007 23:22:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070228222210.GA4675@elte.hu>
References: <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com> <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com> <20070228202156.GA15846@elte.hu> <Pine.LNX.4.64.0702281259430.6806@alien.or.mcafeemobile.com> <20070228212306.GA27127@elte.hu> <Pine.LNX.4.64.0702281338510.6806@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702281338510.6806@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> On Wed, 28 Feb 2007, Ingo Molnar wrote:
> 
> > * Davide Libenzi <davidel@xmailserver.org> wrote:
> > 
> > > Did you hide all the complexity of the userspace atom decoding inside 
> > > another function? :)
> > 
> > no, i made the 64-bit and 32-bit structures layout-compatible. This 
> > makes the 32-bit structure as large as the 64-bit ones, but that's not a 
> > big issue, compared to the simplifications it brings.
> 
> Do you have a new version to review?

yep, i've just released -v5.

> How about this, with async_wait returning asynid's back to a userspace 
> ring buffer?
> 
> struct syslet_utaom {
>         long *result;
>         unsigned long asynid;
>         unsigned long nr_sysc;
>         unsigned long params[8];
> };

we talked about the parameters at length: if they are pointers the 
layout is significantly more flexible and more capable. It's a pretty 
similar argument to the return-pointer thing. For example take a look at 
how the IO syslet atoms in Jens' FIO engine share the same fd. Even if 
there's 20000 of them. And they are fully cacheable in constructed 
state. The same goes for the webserving examples i've got in the 
async-test userspace sample code. I can pick up a cached request and 
only update req->fd, i dont have to reinit the atoms at all. It stays 
nicely in the cache, is not re-dirtied, etc.

furthermore, having the parameters as pointers is also an optimization: 
look at the copy_uatom() x86 assembly code i did - it can do a simple 
jump out of the parameter fetching code. I actually tried /both/ of 
these variants in assembly (as i mentioned it in a previous reply, in 
the v1 thread) and the speed difference between a pointer and 
non-pointer variant was negligible. (even with 6 parameters filled in)

but yes ... another two more small changes and your layout will be 
awfully similar to the current uatom layout =B-)

> My problem with the syslets in their current form is, do we have a 
> real use for them that justify the extra complexity inside the kernel?

i call bullshit. really. I have just gone out and wasted some time 
cutting & pasting all the syslet engine code: it is 153 lines total, 
plus 51 lines of comments. The total patchset in comparison is:

 35 files changed, 1890 insertions(+), 71 deletions(-)

(and this over-estimates it because if this got removed then we'd still 
have to add an async execution syscall.) And the code is pretty compact 
and self-contained. Threadlets share much of the infrastructure with 
syslets: for example the completion ring code is _100%_ shared, the 
async execution code is 98% shared.

You are free to not like it though, and i'm willing to change any aspect 
of the API to make it more intuitive and more useful, but calling it 
'complexity' at this point is just handwaving. And believe it or not, a 
good number of people actually find syslets pretty cool.

> Or with a simple/parellel async submission, coupled with threadlets, 
> we can cover a pretty broad range of real life use cases?

sure, if we debate its virtualization driven market penetration via self 
promoting technologies that also drive customer satisfaction, then we'll 
be able to increase shareholder value by improving the user experience 
and we'll also succeed in turning this vision into a supply/demand 
marketplace. Or not?

	Ingo
