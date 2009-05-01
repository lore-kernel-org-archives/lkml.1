Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZEAHJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZEAHJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 03:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZEAHJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 03:09:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZEAHJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 03:09:19 -0400
Date: Fri, 1 May 2009 09:09:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/6] kill-the-BKL/reiserfs: release the write lock
	before rescheduling on do_journal_end()
Message-ID: <20090501070911.GG5983@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <1241145862-21700-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241145862-21700-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

> When do_journal_end() copies data to the journal blocks buffers in memory,
> it reschedules if needed between each block copied and dirtyfied.
> 
> We can also release the write lock at this rescheduling stage,
> like did the bkl implicitly.
> 
> [ Impact: release the reiserfs write lock when it is not needed ]
> 
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  fs/reiserfs/journal.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
> index 7976d7d..373d080 100644
> --- a/fs/reiserfs/journal.c
> +++ b/fs/reiserfs/journal.c
> @@ -4232,7 +4232,9 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
>  		next = cn->next;
>  		free_cnode(sb, cn);
>  		cn = next;
> +		reiserfs_write_unlock(sb);
>  		cond_resched();
> +		reiserfs_write_lock(sb);

There's 8 cond_resched()'s in the code - i'd suggest to introduce a 
helper for this - reiserfs_write_cond_resched(sb) or so?

	Ingo
