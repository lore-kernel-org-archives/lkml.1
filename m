Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbZC0Anm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbZC0Anm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932648AbZC0AnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:43:25 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:52994 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762754AbZC0AnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:43:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=r6BMR9ONGEBGbtJSLI8YbW6w16Xb36pu84CJibxhJmUvMsO/etgJud0FJBUhnDhbv3T+/Z+Sce2mz5ykKWqitrXcmSs+Q4cxJw0Kcb2QiCgVelYjWmlBFf6hUaE6SG14;
Date: Thu, 26 Mar 2009 17:43:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 1/6] drm/i915: Fix lock order reversal in GTT pwrite
 path.
Message-ID: <20090326174320.4f16c822@hobbes>
In-Reply-To: <1238017510-26784-2-git-send-email-eric@anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	<1238017510-26784-2-git-send-email-eric@anholt.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 14:45:05 -0700
Eric Anholt <eric@anholt.net> wrote:

> Since the pagefault path determines that the lock order we use has to
> be mmap_sem -> struct_mutex, we can't allow page faults to occur
> while the struct_mutex is held.  To fix this in pwrite, we first try
> optimistically to see if we can copy from user without faulting.  If
> it fails, fall back to using get_user_pages to pin the user's memory,
> and map those pages atomically when copying it to the GPU.
> 
> Signed-off-by: Eric Anholt <eric@anholt.net>
> ---
> +	/* Pin the user pages containing the data.  We can't fault
> while
> +	 * holding the struct mutex, and all of the pwrite
> implementations
> +	 * want to hold it while dereferencing the user data.
> +	 */
> +	first_data_page = data_ptr / PAGE_SIZE;
> +	last_data_page = (data_ptr + args->size - 1) / PAGE_SIZE;
> +	num_pages = last_data_page - first_data_page + 1;
> +
> +	user_pages = kcalloc(num_pages, sizeof(struct page *),
> GFP_KERNEL);
> +	if (user_pages == NULL)
> +		return -ENOMEM;

If kmalloc limits us to a 128k allocation (and maybe less under
pressure), then we'll be limited to 128k/8 page pointers on 64 bit, or
64M per pwrite...  Is that ok?  Or do we need to handle multiple passes
here?

Looks good other than that.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
