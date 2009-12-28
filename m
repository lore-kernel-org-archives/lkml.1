Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZL1Jxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZL1Jxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZL1Jxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:53:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47814 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZL1Jxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:53:32 -0500
Date: Mon, 28 Dec 2009 10:53:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
Subject: Re: On "ratelimit: Use per ratelimit context locking"
Message-ID: <20091228095314.GI24690@elte.hu>
References: <4B2E0CFB.30806@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2E0CFB.30806@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Hi Ingo,
> 
> in pre 2.6.33-rc1 commit 979f693d you wrote: "I'd like to use
> printk_ratelimit() in atomic context, but that's not possible right now
> due to the spinlock usage this commit introduced more than a year ago:
> 717115e: printk ratelimiting rewrite".?,?
> 
> By not possible, do you mean it would be an outright bug to call
> printk_ratelimit in atomic context prior to 979f693d, or merely a
> performance issue?  If the former, under which circumstances would the
> bug hit?
> 
> I'm asking because one of my commits actually introduced a
> printk_ratelimit use in an interrupt handler shortly before 2.6.32 was
> released.  In my testing, it didn't occur to me that there might be a
> problem.
> 
> ?http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=979f693def9084a452846365dfde5dcb28366333
> ?http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=717115e1a5856b57af0f71e1df7149108294fc10

There used to be a global lock:

  static DEFINE_SPINLOCK(ratelimit_lock);

which is now per ratelimit context. The case i was after was to use the 
ratelimit state from NMI context. With NMIs we can lock up if an NMI hits when 
some other code uses the ratelimit code. It's a small but existing race 
window.

OTOH, IRQ context use of printk ratelimit was safe before (and after) this 
commit - so i think your code should be safe too.

Hope that helps,

	Ingo
