Return-Path: <linux-kernel-owner+w=401wt.eu-S2993140AbXDSHFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993140AbXDSHFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993137AbXDSHFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:05:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993140AbXDSHEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:04:54 -0400
Date: Thu, 19 Apr 2007 09:04:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy
Message-ID: <20070419070437.GA25211@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176947576.5906.21.camel@nigel.suspend2.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nigel Cunningham <nigel@nigel.suspend2.net> wrote:

> From subsequent emails, I think you already got your answer, but just 
> in case...
> 
> Yes, if you enabled "Replace swsusp by default" and you already had it 
> set up for getting swsusp to resume. If not, and you're using an 
> initrd/ramfs, you'll need to modify it to echo
> > /sys/power/suspend2/do_resume after /sys and /proc are mounted but
> prior to mounting / and so on.

yeah, went with the default suggested by your patch:

   CONFIG_SUSPEND2_REPLACE_SWSUSP=y

and it was pretty easy to set things up. I used "echo disk > 
/sys/power/state" to trigger it.

In hindsight it was all pretty straightforward and suspend2 worked 
beautifully on an UP and on an SMP system i tried. So in exchange for 
suspend2 folks debugging a bug in CFS here's some suspend2 review 
feedback ;) Any plans about moving suspend2 to the upstream kernel? It 
should be pretty easy for it to co-exist with the current swsuspend 
code.

The patch has quite some size:

 89 files changed, 16452 insertions(+), 69 deletions(-)

that should obviously be split up into more than a dozen sub-patches, 
and fed to lkml with the small ones first. (unless it already is split 
up?)

i cannot comment on the kernel/power/ bits (they are way too large 
anyway), other than that they look pretty clean visually, but the 
lowlevel arch and generic kernel bits look sane in detail too, sans a 
few mostly trivial cleanliness issues:

+int suspend2_faulted = 0;
+EXPORT_SYMBOL(suspend2_faulted);

should be done via the pagefault notifier chain mechanism. Also, all the 
exports you added should be EXPORT_SYMBOL_GPL().

this:

-               ClearPageReserved(virt_to_page(addr));
-               init_page_count(virt_to_page(addr));
+               //ClearPageReserved(virt_to_page(addr));
+               //init_page_count(virt_to_page(addr));

looks like there's a buglet in there still somewhere?

+       if(PageHighMem(page))
+               return 0;

coding style.

+       BUG_ON( test_suspend_state(SUSPEND_RUNNING) &&  /* Suspend2, that is */

make this a WARN_ON() or a WARN_ON_ONCE() - that way you have a chance 
to even get feedback from users, instead of a 'uhm, X froze' report.

+#define FREEZER_OFF 0
+#define FREEZER_USERSPACE_FROZEN 1
+#define FREEZER_FULLY_ON 2

should be:

+#define FREEZER_OFF			0
+#define FREEZER_USERSPACE_FROZEN	1
+#define FREEZER_FULLY_ON		2

(you want your reviewers have an pleasant time reading your code :)

+#define NETLINK_SUSPEND2_USERUI        20      /* For suspend2's userui */

IIRC userui was at the center of suspend2 merge flames, right? So you 
might want to layer it ontop a less flashy suspend2-core and thus get 
90% of your patch upstream?

+++ linux/mm/vmscan.c

the MM impact looks quite nontrivial. But i suspect this is unavoidable, 
because you zap portions of the pagecache on the way to disk, so when it 
comes back it results in a different pagecache (new lru lists, etc.), 
right?

+++ linux/lib/dyn_pageflags.c

shouldnt this be in mm/dyn_pageflags.c? Plus it would be nice to use 
some other core kernel user for this infrastructure. (but it's not a 
necessity i guess)

but ... again, the patch looks sane all around.

	Ingo
