Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXDBF6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXDBF6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932684AbXDBF6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:58:39 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36794 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXDBF6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:58:38 -0400
Date: Sun, 1 Apr 2007 22:58:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/16] show-pipesize-in-stat.diff
Message-Id: <20070401225833.ffb9fbd5.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704012010040.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012010040.12316@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:17:24 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> Show the fill status of a pipe (in bytes) when stat'ing one.
> 

Is this useful?  It seems rather an obscure thing, and we generally need a
good reason to go adding Linux-specific goodies to standard system calls
like this.  What do "other operating systems" do here?

> -	stat->size = i_size_read(inode);
> +	stat->size = 0;
> +	if (S_ISFIFO(inode->i_mode)) {
> +		const struct pipe_inode_info *info = inode->i_pipe;
> +		int i;
> +		stat->size = 0;
> +		if (info != NULL) {
> +			for (i = 0; i < PIPE_BUFFERS; ++i) {
> +				const struct pipe_buffer *buf = &info->bufs[i];
> +				if (buf != NULL && buf->page != NULL)
> +					stat->size += buf->len;
> +			}
> +		}
> +	} else if (S_ISSOCK(inode->i_mode)) {
> +#ifdef CONFIG_UNIX_MODULE
> +		loff_t (*uxsize)(struct inode *) = __symbol_get("unixsock_size");
> +		if (uxsize != NULL) {
> +			stat->size = uxsize(inode);
> +			symbol_put("unixsock_size");
> +		}
> +#endif
> +#if defined(CONFIG_UNIX) && !defined(CONFIG_UNIX_MODULE)
> +		stat->size = unixsock_size(inode);
> +#endif
> +	} else {
> +		stat->size = i_size_read(inode);
> +	}

That's a bit fugly.

> +loff_t unixsock_size(struct inode *inode) {
> +    struct sock *sk = unix_find_socket_byinode(inode);
> +    loff_t eax;
> +
> +    if(sk == NULL) { return 0; }
> +    eax = sk->sk_rcvbuf;
> +    sock_put(sk);
> +    return eax;
> +}
> +EXPORT_SYMBOL(unixsock_size);

That's wildly incorrect coding style, and it doesn't use tabs.
