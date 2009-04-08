Return-Path: <linux-kernel-owner+w=401wt.eu-S1765482AbZDHN1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765482AbZDHN1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbZDHN1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:27:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbZDHN13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:27:29 -0400
Date: Wed, 8 Apr 2009 09:27:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Separate out common fstatat code
Message-ID: <20090408132727.GB5957@infradead.org>
References: <20090408055411.GA1615245@fiona.linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408055411.GA1615245@fiona.linuxhacker.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 09:54:11AM +0400, Oleg Drokin wrote:
> Hello!
> 
>    It seems we have way too many copy&pasted fstatat code elsewhere which
>    might not have been a problem until now, but with all the changes
>    with "stat light" now and who knows what other additions in there in
>    the future, it really helps if we have only one copy of the code.
> 
>    Hence this patch adds fstatat_common() that fills struct kstat with
>    proper values and does all the AT flags parsing that's needed and
>    then calls all the proper underlying functions, what's left to the
>    caller now is to only copy filled out kstat buffer to the final
>    destination.

Looks good and like a merge candidate even without any statlite-like
syscall.

But I would call it vfs_fstatat, not fstatat_common.

> --- linux-2.6.29.orig/arch/arm/kernel/sys_oabi-compat.c	2009-04-08 01:31:41.000000000 -0400
> +++ linux-2.6.29/arch/arm/kernel/sys_oabi-compat.c	2009-04-08 01:41:59.000000000 -0400
> @@ -176,20 +176,12 @@
>  				   int flag)
>  {
>  	struct kstat stat;
> +	int error;
>  
> +	error = fstatat_common(dfd, filename, &stat, flag);
>  	if (!error)
> +		error = cp_oldabi_stat64(&stat, statbuf);
>  
>  	return error;

Also a 

	error = vfs_fstatat(dfd, filename, &stat, flag);
	if (error)
		return error;
	return cp_oldabi_stat64(&stat, statbuf);

would looks slightly cleaner than that.

(Same for the various other duplicates)

