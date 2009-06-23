Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZFWVYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZFWVYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZFWVY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:24:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbZFWVY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:24:29 -0400
Date: Tue, 23 Jun 2009 14:23:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix error handling in add_disk
Message-Id: <20090623142357.b2050c14.akpm@linux-foundation.org>
In-Reply-To: <200906171231.10438.knikanth@suse.de>
References: <200906171231.10438.knikanth@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 12:31:10 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> Fix error handling in add_disk. Also add WARN_ON()'s in case
> of error, which can be removed once the callers handle the error.
> 

I have a vague ancestral memory that some of the unchecked errors which
you're now checking for actually do happen in practice, and that this
"fix" will end up breaking currently-working setups.

Or maybe I'm thinking of a similar but different piece of code (maybe
it was the partition code?).

Still, I think it would be prudent to initially make this patch
continue to ignore the errors.  So add the warnings, but don't change
the response to errors.  Then we can get the change distributed for a
bit of testing and if that all looks good then we can add the control
flow changes later.

>  	retval = blk_alloc_devt(&disk->part0, &devt);
>  	if (retval) {
>  		WARN_ON(1);
> -		return;
> +		goto err_out;
>  	}
> ...
> +	if (retval) {
> +		WARN_ON(1);
> +		goto err_free_devt;
> +	}
> ...
> +	if (retval) {
> +		WARN_ON(1);
> +		goto err_free_region;
> +	}
> ...
> -	WARN_ON(retval);
> +	if (retval) {
> +		WARN_ON(1);
> +		goto err_free_queue;
> +	}

These all can be coded as

	if (WARN_ON(retval))
		goto foo;

