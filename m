Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbZD2LCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbZD2LCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZD2LBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:01:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759751AbZD2LBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:01:11 -0400
Date: Wed, 29 Apr 2009 12:59:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH/RFT 0/13] x86: unify vmlinux.lds
Message-ID: <20090429105945.GH2373@elte.hu>
References: <20090429073510.GA26386@uranus.ravnborg.org> <20090429075730.GD22129@elte.hu> <20090429100013.GA23717@elte.hu> <20090429105056.GA28720@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429105056.GA28720@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Apr 29, 2009 at 12:00:13PM +0200, Ingo Molnar wrote:
> > 
> > Ok, first problem hit in testing:
> > 
> > Freeing unused kernel memory: 1800k freed
> > BUG: Bad page state in process swapper  pfn:01c00
> > page:f666b000 flags:00840000 count:0 mapcount:0 mapping:(null) index:0
> > Pid: 1, comm: swapper Not tainted 2.6.30-rc3-tip-01696-g9b182a3-dirty #37518
> > Call Trace:
> >  [<c08730d0>] ? printk+0x15/0x1d
> >  [<c01aa0bb>] bad_page+0xdb/0x150
> >  [<c01abba7>] free_hot_cold_page+0x1b7/0x2f0
> >  [<c01abd4f>] free_hot_page+0xf/0x20
> >  [<c01abd97>] __free_pages+0x37/0x40
> >  [<c01abddf>] free_pages+0x3f/0x50
> >  [<c011b8c0>] free_init_pages+0xb0/0xd0
> >  [<c011b8fc>] free_initmem+0x1c/0x20
> >  [<c01011d2>] init_post+0x12/0x170
> >  [<c0c142f3>] kernel_init+0x14b/0x161
> >  [<c0c141a8>] ? kernel_init+0x0/0x161
> >  [<c0103be7>] kernel_thread_helper+0x7/0x10
> > Disabling lock debugging due to kernel taint
> > Write protecting the kernel text: 7660k
> > Testing CPA: Reverting c0100000-c087b000
> > 
> > more details attached. (sendig the System.map separately, it's too 
> > large) Commit used was v2.6.30-rc3-1696-g9b182a3.
> 
> OK - I think I know what is wrong.

that's good - because i tried to bisect it and it's not bisectable. 
(went away when i moved to a pure x86/kbuild tree - i.e. the bug is 
possibly dependent on specific symbol placement, size and alignment)

> You have:
> 
> CONFIG_RELOCATABLE=y
> 
> And I moved a few symbols out of an output section.
> But they were there for a purpose as the comment in the top of
> the file says.
> 
> I am on my way out of the door.
> Patch follows tonight.

hey this description is enough for me to fix it ;-) I suspect the 
main one that hit us here is:

        __init_begin = .; /* paired with __init_end */

	...

        __init_end = .;

Havent found any other absolute symbols.

	Ingo
