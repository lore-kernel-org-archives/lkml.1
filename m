Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXDPKVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXDPKVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXDPKVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:21:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41546 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXDPKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:21:22 -0400
Date: Mon, 16 Apr 2007 11:21:07 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Emelianov <xemul@sw.ru>
Cc: sct@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Check for error returned by kthread_create on creating journal thread
Message-ID: <20070416102107.GA12818@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Pavel Emelianov <xemul@sw.ru>, sct@redhat.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org
References: <4623289A.1000101@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4623289A.1000101@sw.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:41:14AM +0400, Pavel Emelianov wrote:
> If the thread failed to create the subsequent wait_event
> will hang forever.
> 
> This is likely to happen if kernel hits max_threads limit.
> 
> Will be critical for virtualization systems that limit the
> number of tasks and kernel memory usage within the container.

> --- ./fs/jbd/journal.c.jbdthreads	2007-04-16 11:17:36.000000000 +0400
> +++ ./fs/jbd/journal.c	2007-04-16 11:30:09.000000000 +0400
> @@ -211,10 +211,16 @@ end_loop:
>  	return 0;
>  }
>  
> -static void journal_start_thread(journal_t *journal)
> +static int journal_start_thread(journal_t *journal)
>  {
> -	kthread_run(kjournald, journal, "kjournald");
> +	struct task_struct *t;
> +
> +	t = kthread_run(kjournald, journal, "kjournald");
> +	if (IS_ERR(t))
> +		return PTR_ERR(t);
> +
>  	wait_event(journal->j_wait_done_commit, journal->j_task != 0);

Note that this wait_event should exist at all, and the return
value of kthread_run should be assigned to journal->j_task.  Also
the code doesn't use the kthread primitives in other places leading
to crufty code.

