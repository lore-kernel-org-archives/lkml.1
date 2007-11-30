Return-Path: <linux-kernel-owner+w=401wt.eu-S934731AbXK3Nq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731AbXK3Nq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbXK3Nqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:46:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60916 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbXK3Nqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:46:48 -0500
Subject: Re: [PATCH 9/9] MN10300: Fix MTD JEDEC probe so that the ASB2303
	bootprom can be detected [2.6.24-rc3-mm2]
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>, tharbaugh@lnxi.com
Cc: akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071129225301.21536.91506.stgit@warthog.procyon.org.uk>
References: <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
	 <20071129225301.21536.91506.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 13:46:40 +0000
Message-Id: <1196430400.13978.26.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 22:53 +0000, David Howells wrote:
> 
> +       /* the MN10300 ASB2303 board doesn't detect its bootprom if this test
> +        * is allowed to take place, presumably because the flash is
> +        * write-protected and so cannot be commanded for the purposes of
> +        * probing
> +        */
> +#ifndef CONFIG_MN10300_UNIT_ASB2303
>         if (uaddr != MTD_UADDR_NOT_SUPPORTED ) {
>                 /* ASSERT("The unlock addresses for non-8-bit mode
>                    are bollocks. We don't really need an array."); */
>                 uaddr = finfo->uaddr[0];
>         }
> +#endif
>  
>   uaddr_done:
>         return uaddr;

I don't like this -- it shouldn't be necessary.

The 'uaddr' field represents the magic 'unlock address'; the address to
which you have to send a sequence of write cycles before you're allowed
to send certain commands.

Although we can use 16-bit chips in 8-bit mode, the unlock address
doesn't change when we do that -- it's still the same levels on the same
pins of the address bus. Having an array of uaddr[] in the chip
definition was a mistake, and that 'assert' you've just removed for your
board was added within a few months of Thayne doing the array thing. I
really should have followed up by _removing_ the array again, by now. 

We _used_ to mangle (shift) the unlock address based on the mode, but
now we don't (I turned that off at the same time I added the above
assert. I think the definition in the table for the LV800TA is wrong,
and it should be 
                        [0] = MTD_UADDR_0x0555_0x02AA,

-- 
dwmw2

