Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbYDUOBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbYDUOBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYDUOBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:01:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54502 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbYDUOBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:01:15 -0400
Date: Mon, 21 Apr 2008 16:00:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb: fix optional arch functions and probe_kernel_*
Message-ID: <20080421140058.GO9554@elte.hu>
References: <200804181742.m3IHgsoG012669@hera.kernel.org> <20080418154800.82f814e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418154800.82f814e0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 18 Apr 2008 17:42:54 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > --- a/mm/maccess.c
> > +++ b/mm/maccess.c
> > @@ -17,11 +17,14 @@
> >  long probe_kernel_read(void *dst, void *src, size_t size)
> >  {
> >  	long ret;
> > +	mm_segment_t old_fs = get_fs();
> >  
> > +	set_fs(KERNEL_DS);
> >  	pagefault_disable();
> >  	ret = __copy_from_user_inatomic(dst,
> >  			(__force const void __user *)src, size);
> >  	pagefault_enable();
> > +	set_fs(old_fs);
> >  
> >  	return ret ? -EFAULT : 0;
> >  }
> 
> Oh.  Well that rather invalidates my earlier comments.  It looks like 
> this change could have been folded, but I understand that this 
> sometimes gets wearisome and isn't terribly important if
> 
> a) the fix doesn't repair build breakage and
> 
> b) the fix doesn't fix runtime breakage and
> 
> c) the fix fixes code which the git-bisect user won't have enabled in
>    config anyway.

yeah. I mentioned it in the pull request that i kept the fixes apart to 
demonstrate the overall fix dynamics of the KGDB tree over a full kernel 
cycle. I normally backmerge and create a clean queue - but that creates 
a false perception that the tree is 'too fresh' and trust is harder to 
be expressed.

> Still.  Do we need the set_fs() in there?  __copy_from_user_inatomic() 
> is a "__" uaccess function and hence shouldn't be running access_ok()?

yeah, i guess that's true. Jason?

	Ingo
