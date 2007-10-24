Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbXJXVAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbXJXVAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXJXVAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:00:04 -0400
Received: from smtpoutm.mac.com ([17.148.16.72]:53792 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbXJXVAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:00:03 -0400
In-Reply-To: <1193255992-14385-1-git-send-email-matthew@wil.cx>
References: <20071024195847.GE27248@parisc-linux.org> <1193255992-14385-1-git-send-email-matthew@wil.cx>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0533759C-81D0-45CB-A663-088A6D4E56A9@mac.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Wed, 24 Oct 2007 16:59:48 -0400
To: Matthew Wilcox <matthew@wil.cx>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 24, 2007, at 15:59:49, Matthew Wilcox wrote:
> +static void sb_vprintf(struct stringbuf *sb, gfp_t gfp, const char  
> *format, va_list args)
> +{

[...]

> +	s = sb->buf + sb->len;
> +	size = vsnprintf(s, sb->alloc - sb->len, format, args);

[...]

> +	/* Point to the end of the old string since we already updated - 
> >len */
> +	s += sb->len - size;
> +	vsprintf(s, format, args);

[...]

> +void sb_printf(struct stringbuf *sb, gfp_t gfp, const char  
> *format, ...)
> +{
> +	va_list args;
> +
> +	va_start(args, format);
> +	sb_vprintf(sb, gfp, format, args);
> +	va_end(args);
> +}

This seems unlikely to work reliably as the various "v*printf"  
functions modify the va_list argument they are passed.  It may happen  
to work on your particular architecture depending on how that  
argument data is passed and stored, but you probably actually want to  
make a copy of the varargs list for the first vsnprintf call.   
Example below:

> va_list argscopy;
> va_copy(argscopy, args);
>
> [...]
>
> size = vsnprintf(s, sb->alloc - sb->len, format, argscopy)
>
> [...]
>
> s += sb->len - size;
> vsprintf(s, format, args);
>
> [...]
>
> va_end(argscopy);

Cheers,
Kyle Moffett
