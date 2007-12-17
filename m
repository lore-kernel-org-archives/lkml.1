Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXLQSYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXLQSYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXLQSYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:24:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35424 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbXLQSYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:24:03 -0500
Date: Mon, 17 Dec 2007 18:23:12 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       John Reiser <jreiser@BitWagon.com>,
       Andrew Morton <akpm@linux-foundation.org>, security@kernel.org,
       tytso@mit.edu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mpm@selenic.com, linux-sparse@vger.kernel.org
Subject: Re: Signed divides vs shifts (Re: [Security] /dev/urandom uses uninit bytes, leaks user data)
Message-ID: <20071217182312.GD8181@ftp.linux.org.uk>
References: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au> <alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org> <20071217185557.0b501e23.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217185557.0b501e23.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 06:55:57PM +0100, Eric Dumazet wrote:

> long *mid(long *a, long *b)
> {
> 	return ((a - b) / 2 + a);
> }

... is not actually a middle (you'd want b-a, not a-b there), but anyway

> It gave :
> mid:
>         movq    %rdi, %rdx
>         subq    %rsi, %rdx
>         sarq    $3, %rdx
>         movq    %rdx, %rax
>         shrq    $63, %rax
>         addq    %rdx, %rax
>         sarq    %rax
>         leaq    (%rdi,%rax,8), %rax
>         ret
> 
> while 
> 
> long *mid(long *a, long *b)
> {
> 	return ((a - b) / 2u + a);
> }

... undefined behaviour if a < b

> and while :
> 
> long *mid(long *a, long *b)
> {
> 	return (((unsigned long)(a - b)) / 2 + a);
> }

undefined behaviour, again.
