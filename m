Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbZHOVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbZHOVqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 17:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZHOVqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 17:46:51 -0400
Received: from www.tglx.de ([62.245.132.106]:56907 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZHOVqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 17:46:50 -0400
Date: Sat, 15 Aug 2009 23:41:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guillaume Knispel <gknispel@proformatique.com>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] poll/select: initialize triggered field of struct
 poll_wqueues
In-Reply-To: <20090815193024.121926e6@xilun.lan.proformatique.com>
Message-ID: <alpine.LFD.2.00.0908152338290.1283@localhost.localdomain>
References: <20090815193024.121926e6@xilun.lan.proformatique.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume,

On Sat, 15 Aug 2009, Guillaume Knispel wrote:
> poll/select: initialize triggered field of struct poll_wqueues
> 
> The triggered field of struct poll_wqueues introduced in commit
> 5f820f648c92a5ecc771a96b3c29aa6e90013bba "poll: allow f_op->poll to
> sleep" was set to 1 in pollwake() (now __pollwake() ), tested and
> later set to 0 in poll_schedule_timeout(), but not initialized before.
> As a result when the process needs to sleep, triggered was likely to be
> non-zero even if pollwake() is not called before the first
> poll_schedule_timeout(), meaning schedule_hrtimeout_range() would not
> be called and an extra loop calling all ->poll() would be done.
> 
> This patch initialize triggered to 0 in poll_initwait() so the ->poll()
> are not called twice before the process goes to sleep when it needs to.

Indeed, triggered is random stack content, so it needs to be initialized.
 
> Signed-off-by: Guillaume Knispel <gknispel@proformatique.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  fs/select.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index d870237..8084834 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -110,6 +110,7 @@ void poll_initwait(struct poll_wqueues *pwq)
>  {
>         init_poll_funcptr(&pwq->pt, __pollwait);
>         pwq->polling_task = current;
> +       pwq->triggered = 0;
>         pwq->error = 0;
>         pwq->table = NULL;
>         pwq->inline_index = 0;
> 
