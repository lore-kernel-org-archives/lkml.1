Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYKDQhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYKDQhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYKDQhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:37:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbYKDQhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:37:00 -0500
Date: Tue, 4 Nov 2008 17:36:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104163636.GA20534@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <1225813659.22738.1282932197@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225813659.22738.1282932197@webmail.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> I wonder how the time needed for reading the GDT segments balances 
> against the time needed due to the extra redirection due to running 
> the stubs. I'ld be interested if the difference can be measured with 
> the current implementation. (I really need to highjack a machine to 
> do some measurements; I hoped someone would do it before I got to it 
> ;) )
> 
> Even if some CPU's have some internal optimization for the case 
> where the gate segment is the same as the current one, I wonder if 
> it is really important... Interrupts that occur while the processor 
> is running userspace already cause changing segments. They are more 
> likely to be in cache, maybe.

there are three main factors:

- Same-value segment loads are optimized on most modern CPUs and can
  give a few cycles (2-3) advantage. That might or might not apply to 
  the microcode that does IRQ entry processing. (A cache miss will 
  increase the cost much more but that is true in general as well)

- A second effect is that the changed data structure layout: a more
  compressed GDT entry (6 bytes) against a more spread out (~7 bytes,
  not aligned) interrupt trampoline. Note that the first one is data 
  cache the second one is instruction cache - the two have different 
  sizes, different implementations and different hit/miss pressures. 
  Generally the instruction-cache is the more precious resource and we 
  optimize for that first, for data cache second.

- A third effect is branch prediction: currently we are fanning 
  out all the vectors into ~240 branches just to recover a single 
  constant in essence. That is quite wasteful of instruction cache 
  resources, because from the logic side it's a data constant, not a 
  control flow difference. (we demultiplex that number into an 
  interrupt handler later on, but the CPU has no knowledge of that 
  relationship)

... all in one, the situation is complex enough on the CPU 
architecture side for it to really necessiate a measurement in 
practice, and that's why i have asked you to do them: the numbers need 
to go hand in hand with the patch submission.

My estimation is that if we do it right, your approach will behave 
better on modern CPUs (which is what matters most for such things), 
especially on real workloads where there's a considerable 
instruction-cache pressure. But it should be measured in any case.

	Ingo
