Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXEJP0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXEJP0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXEJP0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:26:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:52568 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746AbXEJP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HIUJuWMF7loSIlUo1NmJyNefH+sICSmMYCqJQGDRbkE+6JDqgfXX5egL6qRwdCyAXHK1Sl1PgFQH0iUAlD0EO1UJPTKfGdPK1OxdT0W+pC3Rb+mfAL7KMzMkD4EDKDPn7tWuGdA7k8/LT3Sg9P24E0X6lLv764L8ouiXuTmOOYg=
Message-ID: <a781481a0705100826i262f5d1bh236d5188ca5f7c64@mail.gmail.com>
Date: Thu, 10 May 2007 20:56:20 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: mikukkon@iki.fi
Subject: Re: [PATCH] Fix bug in mm/thrash.c function grab_swap_token()
Cc: akpm@google.com, ashwin.chaugule@celunite.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070510125832.GA16461@srv1-m700-lanp.koti>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510125832.GA16461@srv1-m700-lanp.koti>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Mika Kukkonen <mikukkon@miku.homelinux.net> wrote:
> Following bug was uncovered by compiling with '-W' flag:
>
>   CC      mm/thrash.o
> mm/thrash.c: In function 'grab_swap_token':
> mm/thrash.c:52: warning: comparison of unsigned expression < 0 is always false
>
> Field token_priority is unsigned, so decrementing first and the checking
> is not a good plan. Attached patch (compile tested) reverses the order.

Heh, yeah. Actually, decrementing first and then checking < 0 to clamp
to zero is _never_ a good plan. If the original author thought he was
optimizing speed that way, he was clearly mistaken.

> Btw, I'm not sure if likely() makes any sense in this new situation.

Right, if(likely(...)) without an else wouldn't make much sense ...

> Signed-off-by: Mika Kukkonen <mikukkon@iki.fi>
>
> diff --git a/mm/thrash.c b/mm/thrash.c
> index 9ef9071..c4c5205 100644
> --- a/mm/thrash.c
> +++ b/mm/thrash.c
> @@ -48,9 +48,8 @@ void grab_swap_token(void)
>                 if (current_interval < current->mm->last_interval)
>                         current->mm->token_priority++;
>                 else {
> -                       current->mm->token_priority--;
> -                       if (unlikely(current->mm->token_priority < 0))
> -                               current->mm->token_priority = 0;
> +                       if (likely(current->mm->token_priority > 0))
> +                               current->mm->token_priority--;
>                 }
>                 /* Check if we deserve the token */
>                 if (current->mm->token_priority >
>
