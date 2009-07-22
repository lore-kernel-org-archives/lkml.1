Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZGVVle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZGVVle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZGVVle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:41:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbZGVVld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:41:33 -0400
Date: Wed, 22 Jul 2009 23:38:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, roland@redhat.com
Subject: Re: +
	task_struct-cleanup-make-binfmt-module-get-and-put-per-signal_struct
	.patch added to -mm tree
Message-ID: <20090722213807.GA4583@redhat.com>
References: <200907222023.n6MKNcgH026779@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907222023.n6MKNcgH026779@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Andrew Morton wrote:
>
> Subject: task_struct cleanup: make binfmt module get and put per signal_struct
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> The binfmt is a member of signal_struct, so it can be handled per
> signal_struct instead of task_struct.

Both patches look good to me. But perhaps the changelog for this patch
should document the user-visible change,

> @@ -888,6 +892,8 @@ void __cleanup_signal(struct signal_stru
>  {
>  	thread_group_cputime_free(sig);
>  	tty_kref_put(sig->tty);
> +	if (sig->binfmt)
> +		module_put(sig->binfmt->module);
>  	kmem_cache_free(signal_cachep, sig);
>  }

This means that a zombie task still holds a reference to ->binfmt, until
it is reaped.


Or. we can do module_put() earlier, in do_exit() under "if (group_dead)".
(in that case we should also modify copy_process() path).

Oleg.

