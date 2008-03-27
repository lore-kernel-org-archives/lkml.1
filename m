Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbYC0Kh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbYC0Kh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYC0KhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:37:15 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbYC0KhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:37:13 -0400
Date: Thu, 27 Mar 2008 11:37:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com, tony.luck@intel.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and  smp_call_function_single()
Message-ID: <20080327103707.GH12346@kernel.dk>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <20080321095343.GA21409@elte.hu> <20080321131558.GA15355@kernel.dk> <20080327100802.GD15003@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327100802.GD15003@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > which is pretty much identical to io-cpu-affinity, except it uses 
> > kernel threads for completion.
> > 
> > The reason why I dropped the kthread approach is that it was slower. 
> > Time from signal to run was about 33% faster with IPI than with 
> > wake_up_process(). Doing benchmark runs, and the IPI approach won 
> > hands down in cache misses as well.
> 
> with irq threads we'll have all irq context run in kthread context 
> again. Could you show me how you measured the performance of the kthread 
> approach versus the raw-IPI approach?

There were 3 different indicators that the irq thread approach was
slower:

- Time from signal to actual run of the trigger was ~2usec vs ~3usec for
  IPI vs kthread. That was a microbenchmark.
- Cache misses were higher with the kthread approach.
- Actual performance in non-micro benchmarks was lower with the kthread
  approach.

I'll defer to Alan for the actual numbers, most of this was done in
private mails back and forth doing performance analysis. The initial
testing was done with the IPI hack, then we moved to the kthread
approach. Later the two were pitted against each other and the kthread
part was definitely slower. It ended up using more system time than the
IPI approach. So the kthread approach was than abandoned and all testing
has been on the smp_call_function_single() branch since then.

I very much wanted the kthread approach to work, since it's easier to
work with. It's not for lack of will or trying... I'll be happy to
supply you otherwise identical patches for this, the only difference
being kthread of IPI completions if you want to play with this.

> we can do a million kthread context switches per CPU per second, so 
> kthread context-switch cost cannot be a true performance limit, unless 
> you micro-benchmarked this.

At which point you wont be doing much else, so a cs microbenchmark is
not really that interesting.

-- 
Jens Axboe

