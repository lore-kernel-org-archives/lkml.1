Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbZJLPYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbZJLPYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZJLPYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:24:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33567 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920AbZJLPYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:24:42 -0400
Date: Mon, 12 Oct 2009 17:23:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012152327.GD14004@elte.hu>
References: <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <1255349748.10605.13.camel@macbook.infradead.org> <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se> <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se> <20091012143017.GC4565@elte.hu> <20091012170139.147fbddc@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012170139.147fbddc@marrow.netinsight.se>
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


* Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> With my patch it instead works like this:
> 
> - mtdoops_console_write continuously writes messages to the buffer, but
>   never calls mtdoops_console_sync() itself.
> 
> - mtdoops_console_sync (i.e., the ->unblank() callback) will schedule
>   work if oops_in_progress is set.
> 
> - if we have a panic, it will call mtdoops_write directly (if
>   mtd->panic_write is set, otherwise we are out of luck). This is also
>   the code path on oopses in interrupt context.
> 
> So the workqueue only gets used on unblank() from oopses. I think the 
> second implementation is simpler, but it also changes the behavior of 
> mtdoops a bit to include messages before the oops/panic as well.

The main printk principle is simplicity:

- The simpler the printk codepath, the higher the chances that we still
  are within the window of opportunity to get anything out to the user.

- Furthermore, the simpler the printk codepath, the larger the window of
  opportunity is to begin with: we rely on less external state, so we
  have a smaller surface of interaction that might break printk.

In that sense, i think your modified workqueue use is less wrong than 
what is in current mainline, but i'm afraid it's still wrong.

Why use a workqueue on unblank()? Why use a workqueue _at all_? (If we 
piggyback to any kernel thread we could as well piggyback to syslog 
itself - and we all know how often syslog fails at capturing oopses.)

The mtdoops console driver only seems to act if there's an emergency - 
and in emergencies we really _never_ want to do complex things like 
using a workqueue thread.

( Sidenote: i proffer that we dont want to use a workqueue in the 
  'regular' printk case either - but that seems to be irrelevant here as 
  mtdoops does not seem to save / care about regular non-emergency 
  printks. )

	Ingo
