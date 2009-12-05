Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbZLEXYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbZLEXYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 18:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbZLEXYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 18:24:46 -0500
Received: from mail2.racsa.co.cr ([196.40.31.26]:38616 "EHLO
	barracuda7.racsa.co.cr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919AbZLEXYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 18:24:46 -0500
X-ASG-Debug-ID: 1260055502-4469020c0000-xx1T2L
X-Barracuda-URL: http://172.16.1.16:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: osobosque@racsa.co.cr
Date: Sat, 05 Dec 2009 17:24:46 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
Subject: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
In-reply-to: <alpine.LFD.2.00.0912012236120.24119@localhost.localdomain>
Message-id: <alpine.LNX.2.00.0912051509210.879@bruno>
References: <alpine.LNX.2.00.0911291057100.2912@bruno>
 <4B143AE8.5090608@us.ibm.com>
 <alpine.LFD.2.00.0911302307440.24119@localhost.localdomain>
 <alpine.LNX.2.00.0912011428350.855@bruno>
 <alpine.LFD.2.00.0912012236120.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Barracuda-Connect: UNKNOWN[172.16.7.12]
X-Barracuda-Start-Time: 1260055502
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at racsa.co.cr
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=4.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=6.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.16345
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello again:

Did some more testing and developed a bit more data, possibly relevant:

1.  Using gdb on /proc/kcore, 2.6.32 no longer allows access to 0xc0000000,
which could be accessed in 2.6.31.x, presumably showing the 16-bit real-mode
interrupt address table set up by the BIOS at physical address zero.  But
....  (see 3).

2.  Disabling the AMI BIOS corruption prevention in 2.6.32 had no effect on
the behavior described in 3 below.

3.  In 2.6.31.x the following inserted in futex_atomic_cmpxchg_inatomic() in
futex.h caused an oops.  It now works in 2.6.32.

   printk(KERN_INFO "*uaddr=%x, oldval=%x, newval=%x",
     *uaddr, oldval, newval);

Producing in dmesg:

   [    0.149408] *uaddr=f0006aa0, oldval=0, newval=0


The following also works in futex_init in futex.c:

   unsigned int testval, *nullptr=NULL;
   testval=*(unsigned int *)NULL;
   printk(KERN_INFO "curval=%x testval=%x", curval, testval);
   printk(KERN_INFO "An explicit null dereference=%x", *(unsigned int *)NULL);
   printk(KERN_INFO "An implicit null dereference=%x", *nullptr);

Producing in dmesg:

   [    0.149466] curval=f0006aa0 testval=f0006aa0
   [    0.149557] An explicit null dereference=f0006aa0
   [    0.149648] An implicit null dereference=f0006aa0


Thus it is completely clear that the virtual zero page is mapped, probably
to physical zero, during this phase of kernel initialization.

I have used 2.6.32 for only one day, but so far see no ill effects from this
other than the lack of those futex functions which rely on a null pointer
dereference fault to set futex_cmpxchg_enabled.  If zero-page mapping is now
"normal", the test in futex.c for cmpxchg functionality must be changed.


I have "fixed" this on our intel machines by simply commenting out the test
of curval in futex_init, thus causing futex_cmpxchg_enabled to be
unconditionally set.  Not suitable for prime-time obviously, but "it works
for us" until somebody with more savvy comes up with a real fix.


Yours,

Joseph
