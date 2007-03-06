Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbXCFACU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbXCFACU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbXCFACU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:02:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42151 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933267AbXCFACU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:02:20 -0500
Date: Mon, 5 Mar 2007 16:00:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Mar 2007, Davide Libenzi wrote:
> @@ -763,15 +767,17 @@
>  	 * using the inode number.
>  	 */
>  	error = -ENOMEM;
> -	sprintf(name, "[%lu]", inode->i_ino);
>  	this.name = name;
> -	this.len = strlen(name);
> -	this.hash = inode->i_ino;
> +	this.len = sprintf(name, "[%p]", ep);
> +	this.hash = 0;

Please don't expose kernel pointers to user space.

It's much better to do something like

	static unsigned int epoll_inode;

	this.len = sprintf(name, "[%u]", ++epoll_inode);

if you just need some pseudo-unique name to distinguish two epoll things 
from each other (vs from a dup'ed fd).

		Linus
