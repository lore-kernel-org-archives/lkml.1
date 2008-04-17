Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbYDQKum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbYDQKum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbYDQKuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:50:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760248AbYDQKub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:50:31 -0400
Date: Thu, 17 Apr 2008 03:50:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417035015.1320350f.akpm@linux-foundation.org>
In-Reply-To: <87skxkepr0.fsf@saeurebad.de>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417011401.ea3e70f0.akpm@linux-foundation.org>
	<87skxkepr0.fsf@saeurebad.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 12:32:03 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:

> Hi,
> 
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > - extensive damage to the page-flags patches
> >
> >   Did you check that all architectures and configurations still have
> >   sufficient page flags for us to be able to consume another one for
> >   kmemcheck?  The MM developers have put much, much effort into avoiding
> >   running out of flags over numerous years and afaik none of them even know
> >   that this debug feature is using one of the few remaining ones.
> >
> >   What do we do when we run out?
> 
> Would it be feasible to add another unsigned long to struct page?  I
> mean, extending such a common structure always sucks, but for
> emergency...
> 
> #define PageFoobar(page)	test_bit(PG_foobar, &(page)->flags2)
> 
> Of course the essential core flags should always be in ->flags but
> perhaps we could have a symbol CONFIG_NEED_EXTRA_PAGE_FLAGS that gets
> selected by kmemcheck (and other candidates that are unlikely to be
> enabled most of the time) and then #ifndef ->flags2 out.
> 

Yes, but I think that only applies to PG_tracked.

We may be able to reclaim PG_buddy by putting various fields in the
pageframe to idiotic otherwise-cant-happen states.  Like

static inline bool PageBuddy(struct page *page)
{
	return page->mapping == (long)&page->private;
}

or something.  But these things are so overloaded it gets tricky.
