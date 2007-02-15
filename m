Return-Path: <linux-kernel-owner+w=401wt.eu-S1161337AbXBOVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161337AbXBOVRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161341AbXBOVRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:17:18 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1175 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161337AbXBOVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:17:17 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 15 Feb 2007 13:17:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <Pine.LNX.4.64.0702151159410.20368@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702151257090.11064@alien.or.mcafeemobile.com>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
 <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
 <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
 <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702151159410.20368@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Linus Torvalds wrote:

> 
> 
> On Thu, 15 Feb 2007, Linus Torvalds wrote:
> > 
> > So I think that a good implementation just does everything up-front, and 
> > doesn't _need_ a user buffer that is live over longer periods, except for 
> > the actual results. Exactly because the whole alloc/teardown is nasty.
> 
> Btw, this doesn't necessarily mean "not supporting multiple atoms at all".
> 
> I think the batching of async things is potentially a great idea. I think 
> it's quite workable for "open+fstat" kind of things, and I agree that it 
> can solve other things too (the "socket+bind+connect+sendmsg+rcv" kind of 
> complex setup things).

If you *really* want to allow chains (note that the above could be 
prolly be hosted on a real thread, once chains becomes that long), then 
try to build that chain with the current API, and compare it with:

long my_clet(ctx *c) {
	int fd, error = -1;

	if ((fd = socket(...)) == -1 ||
	    bind(fd, &c->laddr, sizeof(c->laddr)) ||
	    connect(fd, &c->saddr, sizeof(c->saddr)) ||
	    sendmsg(fd, ...) == -1 ||
	    recv(fd, ...) <= 0)
		goto
	error = 0;
erxit:
	close(fd);
	return error;
}

Points:

- Keep the submission API to submit one or an array of parallel async 
  syscalls/clets

- Keep arguments of the syscall being longs (no need for extra pointer 
  indirection compat code, and special copy_atoms functions)

- No need for the "next" atom pointer chaining (nice for compat too)

- No need to create special conditions/jump interpreters into the kernel 
  (nice for compat and emulators). C->machine-code that that for us

- Easier to code. Try to build a chain like that with the current API and 
  you will see what I saying

- Did I say faster? Machine code is faster than sudo-VM interpretation of 
  jumps/conditions done inside the kernel




- Davide


