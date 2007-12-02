Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbXLBQnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbXLBQnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbXLBQnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:43:11 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:2989 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbXLBQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:43:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HxJdvdjv2uCTdYzsp77XjS9A9QqV+2J6ENC9LcIEH71nL5TUMf2IKR2G2brYXL5wM5prMujj+MYHuNnSv6Xp00ITBFB2WsutT0botg2v3TYsLrJium303OR0DL0mKdgtv6vAp3DQO0YD7CVHW9HWnO122+LCIWT0CCBmrFaECA0=
Message-ID: <19f34abd0712020843m1dccfa3bu38388e1a53b05fc@mail.gmail.com>
Date: Sun, 2 Dec 2007 17:43:09 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [BUG 2.6.24-rc3-git6] SLUB's ksize() fails for size > 2048.
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0712020830y4825691atdfc9dac07ce4cb35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712021939.HHH18792.FLQSOOtFOFJVHM@I-love.SAKURA.ne.jp>
	 <19f34abd0712020830y4825691atdfc9dac07ce4cb35@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 2, 2007 5:30 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Dec 2, 2007 11:39 AM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > Hello.
> >
> > I can't pass memory allocated by kmalloc() to ksize()
> > if it is allocated by SLUB allocator and
> > size is larger than (I guess) PAGE_SIZE / 2.
> >
> > Regards.
> The error of ksize() seems to be that it does not check if the
> allocation was made by SLUB or the page allocator. Maybe something
> like this will fix it? (completely untested)

That didn't work. I guess that's what you get for no testing ;-) After
some more investigations, it seems that this is the correct way to fix
it (and tested!):

diff --git a/mm/slub.c b/mm/slub.c
index 9acb413..b9f37cb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2558,8 +2558,12 @@ size_t ksize(const void *object)
        if (unlikely(object == ZERO_SIZE_PTR))
                return 0;

-       page = get_object_page(object);
+       page = virt_to_head_page(object);
        BUG_ON(!page);
+
+       if (unlikely(!PageSlab(page)))
+               return PAGE_SIZE << compound_order(page);
+
        s = page->slab;
        BUG_ON(!s);


> It's going to round up, though, so you would get ksize(kmalloc(2049))
> = PAGE_SIZE.


Vegard
