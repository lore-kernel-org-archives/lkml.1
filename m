Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbZAQKSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbZAQKSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 05:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZAQKSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 05:18:12 -0500
Received: from genesysrack.ru ([195.178.208.66]:49474 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbZAQKSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 05:18:11 -0500
Date: Sat, 17 Jan 2009 13:18:09 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Mike Waychison <mikew@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 3/8] Deferred batching of iput()
Message-ID: <20090117101809.GB2682@ioremap.net>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <20090117022952.20425.91639.stgit@crlf.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117022952.20425.91639.stgit@crlf.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 06:29:52PM -0800, Mike Waychison (mikew@google.com) wrote:
> +static void postpone_iput(struct inode *inode)
> +{
> +	struct postponed_inodes *ppi, *new_ppi;
> +
> +again:
> +	ppi = get_cpu_var(postponed_inodes);
> +	if (!pending_iput_full(ppi)) {
> +		add_pending_iput(ppi, inode);
> +		put_cpu_var(postponed_inodes);
> +		return;
> +	}
> +
> +	/* Need to flush out existing pending inodes */
> +	put_cpu_var(postponed_inodes);
> +	/* Allocate more space.. */
> +	new_ppi = new_postponed_inodes();
> +	if (!new_ppi) {
> +		struct postponed_inodes_onstack ppi_onstack;
> +
> +		ppi = init_ppi_onstack(&ppi_onstack);
> +		add_pending_iput(ppi, inode);
> +		process_postponed_inodes(ppi);
> +		return;
> +	}

The same here: what just not to call a real_iput() without on-stack
allocation and the line?

-- 
	Evgeniy Polyakov
