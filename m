Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbYKGHmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbYKGHmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYKGHlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:41:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbYKGHlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:41:53 -0500
Date: Fri, 7 Nov 2008 08:41:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081107074147.GA26607@elte.hu>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107004824.GA28780@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Thu, Nov 06, 2008 at 04:30:23PM -0800, Ken Chen wrote:
> > On Thu, Nov 6, 2008 at 12:35 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >> +static int proc_pid_stack(struct task_struct *task, char *buffer)
> > >> +{
> > >> +     for (i = 0; i < trace.nr_entries; i++) {
> > >> +             len += sprintf(buffer + len, "[<%p>] %pS\n",
> > >> +                             (void *)entries[i], (void
> > >> *)entries[i]);
> > >
> > > hm, this looks like a potential buffer overflow - isnt 'buffer' here
> > > only valid up to the next PAGE_SIZE boundary?
> 
> So, make trace depth low enough, or even better use seqfiles, if 
> you're scared by buffer overflows.

it's not about being scared, it's about doing the math: kernel symbols 
can be up to 128 bytes long, so the per line max becomes 
2+2+16+2+1+2+16+128+1 == 170. 4096/170 ~== 24. So without checking 
we've got guaranteed space for only 24 lines - that's too low.

_In practice_, we'd need a really long trace to trigger it, but i've 
seen really long traces in the past and this is debug infrastructure, 
so we cannot take chances here.

> >  /*
> > + * buffer size used for proc read.  See proc_info_read().
> > + * 4K page size but our output routines use some slack for overruns
> > + */
> > +#define PROC_BLOCK_SIZE	(3*1024)

That sounds like a proper limit - the hard limit for this particular 
printout function is 4096-170, so we are well within the 
PROC_BLOCK_SIZE range.

	Ingo
