Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYKFJQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYKFJQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYKFJQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:16:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbYKFJQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:16:20 -0500
Date: Thu, 6 Nov 2008 10:15:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081106091548.GE4890@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104210643.GH29626@one.firstfloor.org> <4910EBF5.7070506@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4910EBF5.7070506@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Why are the accesses locked?  Is it because it does an update of the 
> accessed bit in the descriptor?  (We should be pre-setting them all 
> anyway.)

yes, the accessed bit in the segment descriptor has to be updated in 
an atomic transaction: the CPU has to do a MESI coherent 
read+compare+write transaction, without damaging other updates to the 
6 bytes segment descriptor.

Old OSs implemented paging to disk by swapping out segments based on 
the accessed bit, and clearing the present and accessed bit when the 
segment is swapped out.

But given that all our GDT entries have the accessed bit set on Linux, 
there's no physical reason why the CPU should be using a locked cycle 
here - only to stay compatible with ancient stuff.

So ... that notion just survived in the backwards-compatibility stream 
of CPU enhancements, over the past 10 years.

On 64-bit Linux there's no reason to maintain that principle, so i'd 
expect future CPUs to relax this even more, were it ever to show up on 
the performance radar. Note that SYSCALL/SYSRET already optimize that 
away.

	Ingo
