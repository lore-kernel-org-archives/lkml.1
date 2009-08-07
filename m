Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZHGU6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZHGU6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZHGU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:58:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:18208 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbZHGU6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:58:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=PwSHsg3pRzVKqlJbhNrMPk3fDA9rKbfSczm2OhFK/ZvSOmy+nmFsbbcjlKD2pwu5t
	C8EV7sNL9EkmOHdplz9rg==
Date: Fri, 7 Aug 2009 13:58:33 -0700
From: Mandeep Singh Baines <msb@google.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: Re: [PATCH 4/4] vfs: remove redundant checks in do_sendfile
Message-ID: <20090807205833.GA24668@google.com>
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com> <1249671461-9071-5-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249671461-9071-5-git-send-email-jlayton@redhat.com>
X-Operating-System: Linux/2.6.24-gg24-generic (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton (jlayton@redhat.com) wrote:
> As Johannes Weiner pointed out, a couple of the range checks in do_sendfile
> are redundant and are already checked in rw_verify_area.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/read_write.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6c8c55d..9c3d98b 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -792,7 +792,6 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
>  {
>  	struct file * in_file, * out_file;
>  	struct inode * in_inode, * out_inode;
> -	loff_t pos;
>  	ssize_t retval;
>  	int fput_needed_in, fput_needed_out, fl;
>  
> @@ -838,17 +837,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
>  	if (!max)
>  		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
>  
> -	pos = *ppos;
>  	retval = -EINVAL;
> -	if (unlikely(pos < 0))
> -		goto fput_out;

Agree. This check is redundant.

> -	if (unlikely(pos + count > max)) {

rw_verify_area does not check s_maxbytes so aren't the checks against
max still required?

> -		retval = -EOVERFLOW;
> -		if (pos >= max)
> -			goto fput_out;
> -		count = max - pos;
> -	}
> -
>  	fl = 0;
>  #if 0
>  	/*
> -- 
> 1.6.0.6
> 
