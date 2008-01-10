Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYAJFln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYAJFln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 00:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYAJFle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 00:41:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53100 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYAJFld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 00:41:33 -0500
Message-ID: <4785AFFA.30906@garzik.org>
Date: Thu, 10 Jan 2008 00:41:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
References: <1196983219534-git-send-email-zach.brown@oracle.com> <200801091303.58920.rusty@rustcorp.com.au> <478438B4.6010101@oracle.com> <200801091448.46241.rusty@rustcorp.com.au> <47850F99.5020001@oracle.com>
In-Reply-To: <47850F99.5020001@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So my radical ultra tired rant o the week...

Rather than adding sys_indirect and syslets as is,

* admit that this is beginning to look like a new ABI.  explore the 
freedoms that that avenue opens...

* (even more radical)  I wonder what a tiny, SANE register-based 
bytecode interface might look like.  Have a single page shared between 
kernel and userland, for each thread.  Userland fills that page with 
bytecode, for a virtual machines with 256 registers -- where 
instructions roughly equate to syscalls.

The common case -- a single syscall like open(2) -- would be a single 
byte bytecode, plus a couple VM register stores.  The result is stored 
in another VM register.

But this format enables more complex cases, where userland programs can 
pass strings of syscalls into the kernel, and let them execute until 
some exceptional condition occurs.  Results would be stored in VM 
registers (or userland addresses stored in VM registers...).

This sort of interface would be
* fast

* equate to the current syscall regime (easy to get existing APIs 
going... hopefully equivalent to glibc switching to a strange new 
SYSENTER variant)

* be flexible enough to support a simple implementation today

* be flexible enough to enable experiments into syscall parallelism (aka 
VM instruction parallelism <grin>)

* be flexible enough to enable experiments into syscall batching

One would probably want to add some simple logic opcodes in addition to 
opcodes for syscalls and such -- but this should not turn into Forth or 
Parrot or Java :)

Thus, this new ABI can easily and immediately support all existing 
syscalls, while enabling

Now to come up with a good programming API and model(s) to match this 
parallel, batched kernel<->userland interface...

	Jeff,	very tired and delirious, so feel free to laugh at this,
		but I've been pondering this for a while




