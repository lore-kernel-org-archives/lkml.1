Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbZFWX6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbZFWX6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZFWX6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:58:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbZFWX6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:58:24 -0400
Date: Tue, 23 Jun 2009 16:56:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, npiggin@suse.de, tj@kernel.org
Subject: Re: [PATCH 3/4] FUSE: implement fuse_req->prep()
Message-Id: <20090623165657.5e42cd71.akpm@linux-foundation.org>
In-Reply-To: <1245317073-24000-4-git-send-email-tj@kernel.org>
References: <1245317073-24000-1-git-send-email-tj@kernel.org>
	<1245317073-24000-4-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 18:24:32 +0900
Tejun Heo <tj@kernel.org> wrote:

> Implement ->prep() which is the opposite equivalent of ->end().

The opposite of "end" is "begin".  I'd expect to see a sequence like

	-> prep
	-> begin
	-> end

so the naming choice here is unexpected.

>  It's
> called right before the request is passed to userland server in the
> kernel context of the server.  ->prep() can fail the request without
> disrupting the whole channel.
> 
> This will be used by direct mmap implementation.

> ...
>
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -292,6 +292,12 @@ struct fuse_req {
>  	/** Link on fi->writepages */
>  	struct list_head writepages_entry;
>  
> +	/** Request preparation callback.  Called from the kernel
> +	    context of the FUSE server before passing the request to
> +	    the FUSE server.  Non-zero return from this function will
> +	    fail the request. */
> +	int (*prep)(struct fuse_conn *, struct fuse_req *);
> +
>  	/** Request completion callback.  This function is called from
>  	    the kernel context of the FUSE server if the request isn't
>  	    being aborted.  If the request is being aborted, it's

Why the strange comment layout?  Does kerneldoc actually recognise and
appropriately process this text?  if not, please do

	/*
	 * Request preparation callback.  Called from the kernel
	 * context of the FUSE server before passing the request to
	 * the FUSE server.  Non-zero return from this function will
	 * fail the request.
	 */

If that looks odd then, well, that wasn't your fault ;)
