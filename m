Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYJGQ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYJGQ5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYJGQ5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:57:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:11215 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYJGQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=f1rtTRm6FdgsN+aq8VCptTizubj1Ym+PzF4DXEo7Pxzip1jJBqRgIDH3vYKb46BijU
         v6hjj2FcoYpg9gDRF5Ek+cLQB8F0dSzlmfGJk2IKcp1hhejsbFXAI0UslSsJRA13JhFY
         HNVBXWQ4PKZLr18Y8FlgnOjBFVgSKXf1mgJTY=
Message-ID: <84144f020810070957y241a16d6y2d03f451aa3dd4a7@mail.gmail.com>
Date: Tue, 7 Oct 2008 19:57:31 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [BUG] SLOB's krealloc() seems bust
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
In-Reply-To: <1223397455.13453.385.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
	 <48EB6D2C.30806@linux-foundation.org>
	 <1223391655.13453.344.camel@calx>
	 <1223395846.26330.55.camel@lappy.programming.kicks-ass.net>
	 <1223397455.13453.385.camel@calx>
X-Google-Sender-Auth: 52a0e901a97c0a87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Tue, Oct 7, 2008 at 7:37 PM, Matt Mackall <mpm@selenic.com> wrote:
> SLOB: fix bogus ksize calculation
>
> SLOB's ksize calculation was braindamaged and generally harmlessly
> underreported the allocation size. But for very small buffers, it could
> in fact overreport them, leading code depending on krealloc to overrun
> the allocation and trample other data.
>
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> Tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> diff -r 5e32b09a1b2b mm/slob.c
> --- a/mm/slob.c Fri Oct 03 14:04:43 2008 -0500
> +++ b/mm/slob.c Tue Oct 07 11:27:47 2008 -0500
> @@ -515,7 +515,7 @@
>
>        sp = (struct slob_page *)virt_to_page(block);
>        if (slob_page(sp))
> -               return ((slob_t *)block - 1)->units + SLOB_UNIT;
> +               return (((slob_t *)block - 1)->units - 1) * SLOB_UNIT;

Hmm. I don't understand why we do the "minus one" thing here. Aren't
we underestimating the size now? Side note, why aren't we using
slob_units() here?

>        else
>                return sp->page.private;
>  }
>
>
>
>
>
> --
> Mathematics is the supreme nostalgia of our time.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
