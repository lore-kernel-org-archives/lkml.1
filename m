Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760186AbYLQHuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYLQHuh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbYLQHuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:50:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760026AbYLQHuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:50:13 -0500
Date: Tue, 16 Dec 2008 23:49:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/15] don't reallocate buffer in every audit_sockaddr()
Message-Id: <20081216234927.9cb8a077.akpm@linux-foundation.org>
In-Reply-To: <E1LCogg-00008b-SH@ZenIV.linux.org.uk>
References: <E1LCogg-00008b-SH@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 05:11:10 +0000 Al Viro <viro@ftp.linux.org.uk> wrote:

>  int audit_sockaddr(int len, void *a)
>  {
> -	struct audit_aux_data_sockaddr *ax;
>  	struct audit_context *context = current->audit_context;
>  
>  	if (likely(!context || context->dummy))
>  		return 0;
>  
> -	ax = kmalloc(sizeof(*ax) + len, GFP_KERNEL);
> -	if (!ax)
> -		return -ENOMEM;
> -
> -	ax->len = len;
> -	memcpy(ax->a, a, len);
> +	if (!context->sockaddr) {
> +		void *p = kmalloc(sizeof(struct sockaddr_storage), GFP_KERNEL);

argh, I really hate having to run all around the code verifying that
the type passed to sizeof matches the type that we'll be storing there :(


> +		if (!p)
> +			return -ENOMEM;
> +		context->sockaddr = p;
> +	}
>  
> -	ax->d.type = AUDIT_SOCKADDR;
> -	ax->d.next = context->aux;
> -	context->aux = (void *)ax;
> +	context->sockaddr_len = len;
> +	memcpy(context->sockaddr, a, len);
>  	return 0;
>  }

stoopid question: can an audit_contect be shared between
threads/processes?  If so, is locking needed around the read/test/write
of context->sockaddr and friends?  
