Return-Path: <linux-kernel-owner+w=401wt.eu-S1030231AbXBOQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231AbXBOQ70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030219AbXBOQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:58:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201AbXBOQ6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:58:17 -0500
Date: Thu, 15 Feb 2007 17:51:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 00/14] Syslets, generic asynchronous system call support, v2
Message-ID: <20070215165151.GA4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3044]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


this is the v2 release of the syslet subsystem. This is an interim 
release, not all known and pending items are fixed/changed yet - the 
tree is still work in progress:

   http://redhat.com/~mingo/syslet-patches/

The biggest conceptual change in v2 is the ability of cachemiss threads 
to be turned into user threads. This fixes signal handling, makes them 
ptrace-eable, etc. (I've updated the sample userspace code at the URL 
above to also do user-space cachemiss processing - just Ctrl-Z the 
async-test.c run to trigger it action.)

Things not yet done in v2 and planned for v3:

 - multiple completion rings support

 - share the 'spare thread' between multiple rings, to further reduce 
   startup costs.

 - remove mlock() reliance

Changes since v1:

 - FPU support fixed: detach FPU state from kernel thread state 
   (implemented by Arjan van de Ven)

 - remove superfluous CLONE_VM from create_async_thread()
   (noticed by Jens Axboe)

 - sys_umem_add() does not ignore -EFAULT of __put_user()
   (noticed by Andrew Morton)

 - use VERIFY_READ instead of VERIFY_WRITE in copy_uatom()
   (noticed by Andrew Morton)

 - move schedule() to tail of loop in cachemiss_loop()
   (noticed by Andrew Morton)

 - added move_user_context() arch op

 - added async_syscall() and recursion protection against re-entry of 
   sys_async_exec(), sys_fork()/sys_clone(), etc.

 - added sys_async_thread() call - a user-space thread can thus call 
   back into the syslet subsystem and continue cachemiss work.

 - further cleanups in the include files

 - race fixes to sys_async_wait()

 - optimized out the kmalloc()/kfree() of the async_head

 - async_thread structure not on the kernel stack anymore, to allow 
   async contexts to run user-space.

 - added support for head_stack and head_eip to enable the initial 
   thread/task to run a cachemiss user context too, if it gets turned 
   into a cachemiss thread.

As always, comments, suggestions, reports are welcome.

	Ingo
