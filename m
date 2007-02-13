Return-Path: <linux-kernel-owner+w=401wt.eu-S1750817AbXBMQ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750817AbXBMQ2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXBMQ2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:28:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43465 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbXBMQ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:28:29 -0500
Date: Tue, 13 Feb 2007 08:26:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Alan <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
In-Reply-To: <p73hctqggfz.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0702130817440.8424@woody.linux-foundation.org>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
 <20070213150019.4b4d4827@localhost.localdomain> <p73hctqggfz.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Feb 2007, Andi Kleen wrote:

> > 	sys_exec and other security boundaries must be synchronous only
> > and not allow async "spill over" (consider setuid async binary patching)
> 
> He probably would need some generalization of Andrea's seccomp work.
> Perhaps using bitmaps? For paranoia I would suggest to white list, not black list
> calls.

It's actually more likely a lot more efficient to let the system call 
itself do the sanity checking. That allows the common system calls (that 
*don't* need to even check) to just not do anything at all, instead of 
having some complex logic in the common system call execution trying to 
figure out for each system call whether it is ok or not.

Ie, we could just add to "do_fork()" (which is where all of the 
vfork/clone/fork cases end up) a simple case like

	err = wait_async_context();
	if (err)
		return err;

or

	if (in_async_context())
		return -EINVAL;

or similar. We need that "async_context()" function anyway for the other 
cases where we can't do other things concurrently, like changing the UID.

I would suggest that "wait_async_context()" would do:

 - if weare *in* an async context, return an error. We cannot wait for 
   ourselves!
 - if we are the "real thread", wait for all async contexts to go away 
   (and since we are the real thread, no new ones will be created, so this 
   is not going to be an infinite wait)

The new thing would be that wait_async_context() would possibly return 
-ERESTARTSYS (signal while an async context was executing), so any system 
call that does this would possibly return EINTR. Which "fork()" hasn't 
historically done. But if you have async events active, some operations 
likely cannot be done (setuid() and execve() comes to mind), so you really 
do need something like this.

And obviously it would only affect any program that actually would _use_ 
any of the suggested new interfaces, so it's not like a new error return 
would break anything old.

		Linus
