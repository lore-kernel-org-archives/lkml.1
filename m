Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbXJOXUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbXJOXUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXJOXU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:20:27 -0400
Received: from gw.goop.org ([64.81.55.164]:59028 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbXJOXU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:20:26 -0400
Message-ID: <4713F5B8.9000206@goop.org>
Date: Mon, 15 Oct 2007 16:20:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       "ADAM G. LITKE [imap]" <agl@us.ibm.com>
Subject: Re: [PATCH 4/11] maps3: introduce a generic page walker
References: <5.290135367@selenic.com>  <4713EC5B.7050000@goop.org> <1192489513.6118.111.camel@localhost>
In-Reply-To: <1192489513.6118.111.camel@localhost>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> For now, we should probably document that these functions assume that
> the appropriate locks are held, and that there are no changes being made
> to the pagetables as we walk.
>
> However, I can see that people might want to use these in the future for
> establishing ptes.  Perhaps a special code coming back from the
> ->pte_hole() function could indicate changes were made to the
> pagetables.  I guess we could at least retry part of the loop where the
> hole call was made, like:
>   

Yes.  We already have apply_to_page_range(), which has the side effect
of creating the page range in order to apply a function to it.  It would
be nice to be able to replicate its functionality with this page waker
so we can have just one.

> +int walk_page_range(struct mm_struct *mm,...
> +{
> ...
> +       pgd = pgd_offset(mm, addr);
> +       do {
> +               next = pgd_addr_end(addr, end);
> +               if (pgd_none_or_clear_bad(pgd)) {
> +                       if (walk->pte_hole)
> +                               err = walk->pte_hole(addr, next, private);
> 			if (err == -EAGAIN) { // or whatever we want
> 				pgd--;
> 				err = 0;
> 			}
> +                       if (err)
> +                               break;
> +                       continue;
> +               }
>
> That wouldn't allow changes behind the walker, but it should allow them
> in the range that was walked by the ->pte_hole() function.
>   

Yep.

    J
