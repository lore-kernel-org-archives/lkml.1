Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbXC1XOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbXC1XOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933813AbXC1XOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:14:31 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXC1XOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:14:30 -0400
Date: Wed, 28 Mar 2007 16:14:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Message-Id: <20070328161420.3c8f9688.akpm@linux-foundation.org>
In-Reply-To: <3D4D126C-0B26-4B00-A2E4-68BD84555B51@oracle.com>
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
	<20070322170122.ee2589a1.akpm@linux-foundation.org>
	<b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com>
	<20070326201552.b8ad7dda.akpm@linux-foundation.org>
	<b040c32a0703271047vba81938q538d182c9c984f42@mail.gmail.com>
	<3D4D126C-0B26-4B00-A2E4-68BD84555B51@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 15:57:53 -0700
Zach Brown <zach.brown@oracle.com> wrote:

> > +#define pipe_kmap_atomic(page, type)	pipe_kmap(page)
> > +#define pipe_kunmap(page)		do { } while (0)
> > +#define pipe_kunmap_atomic(page, type)	do { } while (0)
> 
> Please don't drop arguments in stubs.  It can let completely broken  
> code compile, like:
> 
> 	pipe_kunmap(SOME_COMPLETE_NONSENSE);
> 
> Static inlines with empty bodies are the gold standard.
> 

yup.

<fiddle, fiddle>

Does this look OK?

#ifdef CONFIG_HIGHMEM
static inline void *pipe_kmap(struct page *page)
{
	return kmap(page);
}

static inline void pipe_kunmap(struct page *page)
{
	kunmap(page);
}

static inline void *pipe_kmap_atomic(struct page *page, enum km_type type)
{
	return kmap_atomic(page, type);
}

static inline void pipe_kunmap_atomic(void *addr, enum km_type type)
{
	kunmap_atomic(addr, type);
}
#else	/* CONFIG_HIGHMEM */
static inline void *pipe_kmap(struct page *page)
{
	return (void *)page->private;
}

static inline void pipe_kunmap(struct page *page)
{
}

static inline void *pipe_kmap_atomic(struct page *page, enum km_type type)
{
	return (void *)page->private;
}

static inline void pipe_kunmap_atomic(struct page *page, enum km_type type)
{
}
#endif

