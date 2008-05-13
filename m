Return-Path: <linux-kernel-owner+w=401wt.eu-S1764606AbYEMU1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764606AbYEMU1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762624AbYEMUTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:19:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55298 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762050AbYEMUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=E5HAU/psFnjKwXNqvYs91v6IjhCynHNQ0sbevUeKfHO8R5vjsN69ib4YL6ytOmjVhHyc8hGTItOeKu8z2CNN7cx/Tb9u8DSG1Tx8aMOkoXMmuZwDrKFohuDBxOiPf8qfgjVhtN085/0WCnxXenccsF2ioulUhYO1QMq+dcBcC5k=
Date: Tue, 13 May 2008 22:18:30 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] let ERR_PTR BUILD_BUG_ON when we know its argument is
	not a valid errno
Message-ID: <20080513201813.GA5869@joi>
References: <20080511201209.GO19058@joi> <20080512163830.04ef13fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512163830.04ef13fd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 04:38:30PM -0700, Andrew Morton wrote:
> On Sun, 11 May 2008 22:12:14 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Andrew Morton <akpm@osdl.org>
> > ---
> > allmodconfig compile tested (on x86_64)
> > 
> > should be applied after:
> > net/sunrpc/xprtrdma: fix svc_rdma_create out of memory error path
> > jfs: 0 is not valid errno value
> > ---
> >  include/linux/err.h |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/err.h b/include/linux/err.h
> > --- a/include/linux/err.h
> > +++ b/include/linux/err.h
> > @@ -19,11 +19,13 @@
> >  
> >  #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
> >  
> > -static inline void *ERR_PTR(long error)
> > +static inline void *__ERR_PTR(long error)
> >  {
> >  	return (void *) error;
> >  }
> >  
> > +#define ERR_PTR(error) (BUILD_BUG_ON(!IS_ERR_VALUE(error)), __ERR_PTR(error))
> > +
> >  static inline long PTR_ERR(const void *ptr)
> >  {
> >  	return (long) ptr;
> 
> Not sure about this one.  BUILD_BUG_ON only makes sense if the value is
> a compile-time constant.  I think the code as you have it will take this:
> 
> 	int e = foo();
> 
> 	p = ERR_PTR(e);
> 
> and will attempt to evaluate sizeof() on a negative-sized array at
> runtime.  The conmpile will laugh and throw that all away, but it's a
> bit weird.
> 
> Plus I'd have thought that the amount of code which does ERR_PTR(-EFOO)
> is fairly small, but perhaps that's wrong.

$ git grep 'ERR_PTR(-E[A-Z]*)' | wc -l
1431

> If I _am_ wrong then I do think it'd be saner to only do the
> BUILD_BUG_ON() if __builtin_constant_p(error) evaluates true.  And even

I thought BUILD_BUG_ON uses __builtin_constant_p internally and it was
a big mistake (see below).

> then I do think we'd like to see a more lengthy justification of why
> the kernel needs this check.

Well, I think it's better to find more errors at compile time,
than on rare runtime situation (error handling).
This patch found 2 errors on current sources (but one of them was harmless).

>  More lengthy than zero, anyway...
> 
> (If a compile-time check is needed then why not a runtime one also?)
I'm not sure - it would make kernel slightly bigger. I'll check that.

Today I discovered, that this patch causes funny runtime errors (/proc is mounted,
but many applications think it's not), so ignore this patch for now.
I'll prepare second version.

Marcin
