Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbYEWUml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbYEWUml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYEWUme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:42:34 -0400
Received: from 1wt.eu ([62.212.114.60]:4961 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426AbYEWUme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:42:34 -0400
Date: Fri, 23 May 2008 22:42:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steve French <smfrench@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080523204228.GC6749@1wt.eu>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 02:11:43PM -0500, Steve French wrote:
> A question splitting "else" and "if" on distinct lines vs. using an
> extra line and extra #else came up as I was reviewing a proposed cifs
> patch.   Which is the preferred style?
>
> #ifdef CONFIG_SOMETHING
>    if (foo)
>       something ...
>    else
> #endif
>    if ((mode & S_IWUGO) == 0)
> 
> or alternatively
> 
> #ifdef CONFIG_SOMETHING
>    if (foo)
>       something ...
>    else if ((mode & S_IWUGO) == 0)
> #else
>    if ((mode & S_IWUGO) == 0)
> #endif

The second one is dangerous because if code evolves, chances are that
only one of the two identical lines will be updated.

At least the first one is clearly readable. But if you have tons of
places with the same construct, it's better to create a macro which
will inhibit the if branch, which gcc will happily optimize away.
For instance :

#ifdef CONFIG_FOO
#define FOO_ENABLED 1
#else
#define FOO_ENABLED 0
#endif

if (FOO_ENABLED && foo)
    something
else if ((mode & S_IWUGO) == 0)
   ...

One variant includes :

#ifdef CONFIG_FOO
#define FOO_COND(x) (x)
#else
#define FOO_COND(x) 0
#endif

if (FOO_COND(foo))
    something
else if ((mode & S_IWUGO) == 0)
   ...

Regards,
Willy

