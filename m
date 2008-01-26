Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYAZAMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYAZAMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYAZAL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:11:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbYAZAL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:11:56 -0500
Date: Sat, 26 Jan 2008 01:11:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
Message-ID: <20080126001128.GB24559@elte.hu>
References: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk> <479A7463.7070801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A7463.7070801@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Is there any guide about the tradeoff of when to use invlpg vs 
> flushing the whole tlb?  1 page?  10?  90% of the tlb?

i made measurements some time ago and INVLPG was quite uniformly slow on 
all important CPU types - on the order of 100+ cycles. It's probably 
microcode. With a cr3 flush being on the order of 200-300 cycles (plus 
any add-on TLB miss costs - but those are amortized quite well as long 
as the pagetables are well cached - which they usually are on today's 
2MB-ish L2 caches), the high cost of INVLPG rarely makes it worthwile 
for anything more than a few pages.

so INVLPG makes sense for pagetable fault realated single-address 
flushes, but they rarely make sense for range flushes. (and that's how 
Linux uses it)

	Ingo
