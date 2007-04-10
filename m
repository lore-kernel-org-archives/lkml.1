Return-Path: <linux-kernel-owner+w=401wt.eu-S1030515AbXDJUKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030515AbXDJUKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030517AbXDJUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:10:47 -0400
Received: from mail.screens.ru ([213.234.233.54]:37553 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030515AbXDJUKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:10:46 -0400
Date: Wed, 11 Apr 2007 00:10:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: wli@holomorphy.com
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-ID: <20070410201036.GA205@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III <wli@holomorphy.com> wrote:
>
>  	switch (who) {
> +		case RUSAGE_THREAD:
> +			utime = p->utime;
> +			stime = p->stime;
> +			r->ru_nvcsw = p->nvcsw;
> +			r->ru_nivcsw = p->nivcsw;
> +			r->ru_minflt = p->min_flt;
> +			r->ru_majflt = p->maj_flt;
> +			r->ru_inblock = task_io_get_inblock(p);
> +			r->ru_oublock = task_io_get_oublock(p);
> +			break;

Minor nit. Perhaps it makes sense to introduce

	static void rusage_self(struct rusage *r, struct task_struct *p);

for that. Could be re-used by "do {} while ()" below. Of course, we need
s/=/+=/.

Or, if we think the kernel code is too much clean,

	--- kernel/sys.c~	2007-04-05 12:20:35.000000000 +0400
	+++ kernel/sys.c	2007-04-11 00:08:53.000000000 +0400
	@@ -2097,6 +2097,7 @@ static void k_getrusage(struct task_stru
				r->ru_majflt += p->signal->maj_flt;
				r->ru_inblock += p->signal->inblock;
				r->ru_oublock += p->signal->oublock;
	+		case RUSAGE_THREAD:
				t = p;
				do {
					utime = cputime_add(utime, t->utime);
	@@ -2107,7 +2108,9 @@ static void k_getrusage(struct task_stru
					r->ru_majflt += t->maj_flt;
					r->ru_inblock += task_io_get_inblock(t);
					r->ru_oublock += task_io_get_oublock(t);
	-				t = next_thread(t);
	+
	+				if (who != RUSAGE_THREAD)
	+					t = next_thread(t);
				} while (t != p);
				break;
	 

Oleg.

