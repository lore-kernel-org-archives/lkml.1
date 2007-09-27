Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbXI0Szt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbXI0Szt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbXI0Szl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:55:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60961 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbXI0Szk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:55:40 -0400
Date: Thu, 27 Sep 2007 19:55:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org
Subject: Re: [RFC][PATCH 5/5] make open_namei() return a filp
Message-ID: <20070927185537.GA521@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
	miklos@szeredi.hu
References: <20070927185210.FD980C90@kernel> <20070927185215.8ADB5392@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927185215.8ADB5392@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:52:15AM -0700, Dave Hansen wrote:
> If open_namei() succeeds, there is potentially a mnt_want_write()
> that needs to get balanced.  If the caller doesn't create a
> 'struct file' and eventually __fput() it, or manually drop the
> write count on an error, we have a bug.
> 
> Forcing open_namei() to return a filp fixes this.  Any caller
> getting a 'struct file' back must consider that filp instantiated
> and fput() it normally.  The callers no longer have to worry about
> ever manually releasing a mnt write count.

> diff -puN fs/open.c~make-open_namei-return-a-filp fs/open.c
> --- lxc/fs/open.c~make-open_namei-return-a-filp	2007-09-27 11:51:34.000000000 -0700
> +++ lxc-dave/fs/open.c	2007-09-27 11:51:34.000000000 -0700
> @@ -846,11 +846,7 @@ static struct file *do_filp_open(int dfd
>  	int error;
>  	struct nameidata nd;
>  
> -	error = open_namei(dfd, filename, flags, mode, &nd);
> -	if (!error)
> -		return nameidata_to_filp(&nd, flags);
> -
> -	return ERR_PTR(error);
> +	return open_namei(dfd, filename, flags, mode, &nd);

Error is unused now, and it's also rather silly to allocate the
nd here when it's only used inside open_namei.  So I'd suggest
killing do_filp_open, and maybe filp_open aswell while you're at
it.
