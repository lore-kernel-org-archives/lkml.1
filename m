Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbZGCJyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbZGCJyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZGCJyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:54:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZGCJyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:54:45 -0400
Date: Fri, 3 Jul 2009 11:54:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703095432.GC21141@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk> <20090703064518.GA30674@elte.hu> <20090703100834.6cb241b6@lxorguk.ukuu.org.uk> <20090703091655.GB3902@elte.hu> <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Well i noticed such details in your final commits that go upstream 
> > as well - you dont appear to be making full use of the patch quality 
> > tools we have.
> 
> Quite often deliberately. A lot of the tty patches keep whatever 
> style they are patching. You'll then see a single big patch to 
> clean the style of the entire file up instead of creating the 
> horrible mishmashes of styles found in some of the code.

That's a really broken method IMO, as you basically allow crap (and 
get used to allowing crap) instead of just saying: "no crap from me 
from today on, ever".

Your method leads to stuff like this in a recent commit:

| commit a6614999e800cf3a134ce93ea46ef837e3c0e76e
| Author: Alan Cox <alan@redhat.com>
| Date:   Fri Jan 2 13:46:50 2009 +0000
|
|     tty: Introduce some close helpers for ports

+       if( tty->count == 1 && port->count != 1) {
+               printk(KERN_WARNING
+                   "tty_port_close_start: tty->count = 1 port count = %d.\n",
+                                                               port->count);
+               port->count = 1;
+       }
+       if (--port->count < 0) {
+               printk(KERN_WARNING "tty_port_close_start: count = %d\n",
+                                                               port->count);
+               port->count = 0;
+       }

Look at how the first branch does 'if( ' while the second one does 
the proper 'if ('. It literally hurts the eye - and if it does not 
hurt yours it better should ;-)

There is absolutely no justification for stuff like that. It is not 
about 'preserving the existing style' - it's inconsistent style in 
the same hunk.

Also note the inconsistent printk-ing lines, mutiliated by line 
warps. The use of pr_warning() would solve it:

+       if (tty->count == 1 && port->count != 1) {
+               pr_warning("tty_port_close_start: tty->count = 1 port count = %d.\n", port->count);
+               port->count = 1;
+       }
+       if (--port->count < 0) {
+               pr_warning("tty_port_close_start: count = %d\n", port->count);
+               port->count = 0;
+       }

'Allow crap now, we'll fix it later' is a bad policy IMHO. New code 
(or old code moved into a new spot) added should always be nice. 

Note, there are occasional bogus checkpatch warnings and borderline 
cases (as with any tool - for example it will emit a col-80 warning 
about my pr_warning() example above and that warning should be 
ignored), where checkpatch should be ignored - but this is not one 
of them.

	Ingo
