Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbZAFBXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbZAFBXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZAFBW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:22:59 -0500
Received: from ozlabs.org ([203.10.76.45]:34566 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZAFBW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:22:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] module: clean up initialization of variable
Date: Tue, 6 Jan 2009 11:52:50 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090105181922.GA25622@uranus.ravnborg.org> <20090105195415.GA6204@uranus.ravnborg.org> <alpine.DEB.1.10.0901051523370.25066@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0901051523370.25066@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061152.51782.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009 07:00:25 Steven Rostedt wrote:
> This is sloppy initialization because it initializes, not only in an
> if condition, but also as the second part of a complex conditional.
> 
> This patch makes the code a bit easier to read.
...
>  	/* Suck in entire file: we'll want most of it. */
>  	/* vmalloc barfs on "unusual" numbers.  Check here */
> -	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
> +	if (len > 64 * 1024 * 1024)
> +		return ERR_PTR(-ENOMEM);
> +	hdr = vmalloc(len);
> +	if (hdr == NULL)
>  		return ERR_PTR(-ENOMEM);
>  	if (copy_from_user(hdr, umod, len) != 0) {
>  		err = -EFAULT;

This line is not accidental nor casually written: the two statements are deliberately entwined.  It is a succint complaint against the vagaries of vmalloc.

So this patch is a messup, not a cleanup.

But it's really upset me because it is lazy and timid: and too much kernel code is becoming mired in such scars.  Instead of "how do I kill this warning and get it in the merge window" you should be thinking "how do I make the kernel better", and "I wonder if vmalloc still has this problem"...

And I so look forward to the warm fuzzies I get when applying a real cleanup patch.

Thanks,
Rusty.
