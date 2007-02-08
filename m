Return-Path: <linux-kernel-owner+w=401wt.eu-S1423145AbXBHJqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423145AbXBHJqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 04:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423154AbXBHJqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 04:46:15 -0500
Received: from mail.screens.ru ([213.234.233.54]:46259 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423145AbXBHJqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:46:14 -0500
Date: Thu, 8 Feb 2007 12:46:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Horms <horms@verge.net.au>, Daniel Drake <dsd@gentoo.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/6] workqueue: make cancel_rearming_delayed_workqueue() work on idle dwork
Message-ID: <20070208094601.GA128@tv-sign.ru>
References: <20070206233016.GA108@tv-sign.ru> <45C9E320.3070001@gentoo.org> <20070207151630.GA138@tv-sign.ru> <20070207174355.GA340@tv-sign.ru> <20070208022051.GC17585@verge.net.au> <20070208083539.GA85@tv-sign.ru> <20070208003927.d8f8cb78.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208003927.d8f8cb78.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Andrew Morton wrote:
>
> On Thu, 8 Feb 2007 11:35:39 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > Andrew, do you think it is worth to tweak delayed works so it would be
> > possible to use flush_work(dwork->work) ?
> > 
> 
> I've completely lost track of what you've been doing in there (this is a
> problem) but sure, if the patch isn't too horrid it's always better to be
> robust in the core than to have to work around inadequacies in the callers.

It is not so obvious to me what should be done. Note that this problem is not
connected to recent changes, there were (I hope) completely transparent for
the delayed works.

The comment for cancel_delayed_work() work says

	Note that the work callback function may still be running on return from
	cancel_delayed_work(). Run flush_scheduled_work() or flush_work() to wait
	on it.

The same is true for cancel_rearming_delayed_work(), but not documented. Note
also that the comment above is wrong, we can't use flush_work(dwork->work), it
was never supposed to do because queue_delayed_work() use work->data "wrongly".

Now,

	- We can change cancel_rearming_delayed_work() so it does a final
	  flush_workqueue(). But this means that 2 flavors of cancel delayed
	  work will have a subtle difference.

		OR

	- Document the fact that cancel_rearming_delayed_work() doesn't
	  garantee that ->func() is not running upon return, fix affected
	  callers.

Finally, we can also tweak delaed_works so it will actually be possible
to use flush_work(dwork->work) after cancel_{,rearming_}delayed_work().
Seems to make sense, but needs (hopefully not too horrid) changes.

And other problems. Currently cancel_rearming_delayed_work(dwork) will hang
if dwork was never scheduled, or cancel_rearming_delayed_work() was already
called before. The first problem is solved by this patch, the second is still
here. The fix is simple _unless_ we are going to implement "flush_work() works
on dwork->work" above.

Oh, I can't make a decision, please tell me...

Oleg.

