Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbZAQKPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbZAQKPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 05:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZAQKPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 05:15:06 -0500
Received: from tservice.net.ru ([195.178.208.66]:49452 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZAQKPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 05:15:04 -0500
Date: Sat, 17 Jan 2009 13:15:01 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Mike Waychison <mikew@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 1/8] Deferred batching of dput()
Message-ID: <20090117101501.GA2682@ioremap.net>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <20090117022942.20425.15217.stgit@crlf.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117022942.20425.15217.stgit@crlf.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike.

On Fri, Jan 16, 2009 at 06:29:42PM -0800, Mike Waychison (mikew@google.com) wrote:
> +static void postpone_dput(struct dentry *dentry)
> +{
> +	struct postponed_dentries *ppd, *new_ppd;
> +
> +again:
> +	ppd = get_cpu_var(postponed_dentries);
> +	if (!pending_dput_full(ppd)) {
> +		add_pending_dput(ppd, dentry);
> +		put_cpu_var(postponed_dentries);
> +		return;
> +	}
> +
> +	/* need to flush out existing pending dentries. */
> +	put_cpu_var(postponed_dentries);
> +	/* Allocate more space.. */
> +	new_ppd = new_postponed_dentries();
> +	if (!new_ppd) {
> +		/* Take the slow path, memory is low */
> +		struct postponed_dentries_onstack ppd_onstack;
> +		struct postponed_dentries *ppd;
> +
> +		ppd = init_ppd_onstack(&ppd_onstack);
> +		add_pending_dput(ppd, dentry);
> +		process_postponed_dentries(ppd);
> +		return;
> +	}

Why don't you want just to put the dentry in the lowmem condition?

-- 
	Evgeniy Polyakov
