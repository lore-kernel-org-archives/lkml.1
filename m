Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZGEIeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZGEIeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 04:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZGEIeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 04:34:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42740 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZGEIeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 04:34:13 -0400
Date: Sun, 5 Jul 2009 10:34:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 5/5] perf report: Support callchains with relative
	overhead rate
Message-ID: <20090705083400.GB12783@elte.hu>
References: <1246772361-9960-1-git-send-email-fweisbec@gmail.com> <1246772361-9960-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246772361-9960-5-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The current callchain displays the overhead rates as absolute:
> relative to the total overhead.
> 
> This patch provides relative overhead percentage, in which each
> branch of the callchain tree is a independant instrumentated object.
> 
> You can produce such output by using the "relative" mode
> that you can lower in r, re, rel, etc...
> 
> ./perf report -s sym -c relative
> 
> Example:
> 
>      8.46%  [k] copy_user_generic_string
>                 |
>                 |--52.01%-- generic_file_aio_read
>                 |          do_sync_read
>                 |          vfs_read
>                 |          |
>                 |          |--97.20%-- sys_pread64
>                 |          |          system_call_fastpath
>                 |          |          pread64
>                 |          |
>                 |           --2.81%-- sys_read
>                 |                     system_call_fastpath
>                 |                     __read
>                 |
>                 |--39.85%-- generic_file_buffered_write
>                 |          __generic_file_aio_write_nolock
>                 |          generic_file_aio_write
>                 |          do_sync_write
>                 |          reiserfs_file_write
>                 |          vfs_write
>                 |          |
>                 |          |--97.05%-- sys_pwrite64
>                 |          |          system_call_fastpath
>                 |          |          __pwrite64
>                 |          |
>                 |           --2.95%-- sys_write
>                 |                     system_call_fastpath
>                 |                     __write_nocancel
> [...]

Wow, this is extremely intuitive and powerful looking!

It's basically a fractal structure: each sub-graph looks like a 
full-blown profile in itself. Thus the overhead of individual 
components of the graph profile can be analyzed without having to 
think in small numbers.

The above example shows it particularly well - it shows that in 
regard to generic_file_buffered_write() overhead, the system is 
doing 97% sys_pwrite64() calls and 3% sys_write() calls.

Thus i took the liberty to change your last patch in two ways: i 
renamed 'relative' to 'fractal' (it was not a proper counterpart to 
'graph' anyway - we have no 'absolute' output mode name either), and 
i changed it to be the default output mode. This stuff rocks!

absolute-graph and flat mode can be displayed too, via the option, 
as usual.

	Ingo
