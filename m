Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXGAK3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXGAK3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 06:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbXGAK3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 06:29:35 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45663 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbXGAK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 06:29:34 -0400
To: schwidefsky@de.ibm.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com
In-reply-to: <20070629141528.511942868@de.ibm.com> (message from Martin
	Schwidefsky on Fri, 29 Jun 2007 15:55:35 +0200)
Subject: Re: [patch 5/5] Optimize page_mkclean_one
References: <20070629135530.912094590@de.ibm.com> <20070629141528.511942868@de.ibm.com>
Message-Id: <E1I4wgB-00071r-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 01 Jul 2007 12:29:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> page_mkclean_one is used to clear the dirty bit and to set the write
> protect bit of a pte. In additions it returns true if the pte either
> has been dirty or if it has been writable. As far as I can see the
> function should return true only if the pte has been dirty, or page
> writeback will needlessly write a clean page.

There are some weird cases, like for example get_user_pages(), when
the pte takes a write fault and the page is modified, but the pte
doesn't become dirty, because the page is written through the kernel
mapping.

In the get_user_pages() case the page itself is dirtied, so your patch
probably doesn't break that.  But I'm not sure if there aren't similar
cases like that that the pte_write() check is taking care of.

And anyway if the dirty page tracking works correctly, your patch
won't optimize anything, since the pte will _only_ become writable if
the page was dirtied.

So in fact normally pte_dirty() and pte_write() should be equivalent,
except for some weird cases.

Miklos
