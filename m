Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZJAFy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZJAFy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 01:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZJAFy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 01:54:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50406 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZJAFy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 01:54:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 8/9] Add explicit bound checks in mm/migrate.c
Cc: kosaki.motohiro@jp.fujitsu.com, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mingo@elte.hu, Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090930152011.18c2cf82.akpm@linux-foundation.org>
References: <20090926205406.30d55b08@infradead.org> <20090930152011.18c2cf82.akpm@linux-foundation.org>
Message-Id: <20091001144858.5F31.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Oct 2009 14:54:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Sat, 26 Sep 2009 20:54:06 +0200
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: [PATCH 8/9] Add explicit bound checks in mm/migrate.c
> > CC: akpm@linux-foundation.org
> > 
> > The memory migration code has some curious copy_from_user bounds,
> > that are likely ok, but are not immediately obvious to me or to GCC.
> > 
> > This patch adds a simple explicit bound check; this allows GCC
> > and me to be more assured that the copy_from_user will never overwrite
> > its destination buffer.
> 
> I don't really see what's being fixed here.  The original code seems
> straightforward and safe enough?

I think original code is safe too.

> The identifier `chunk_nr' is a bit ambiguous.  Is it "number of chunks" or
> is it "index of this chunk"?

chunk_nr is batch size. (ie it's number of chunks)


Plus, I have a review comment.

> 
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 1a4bf48..5b9ebc5 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -1044,11 +1044,15 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
> >  	int err;
> >  
> >  	for (i = 0; i < nr_pages; i += chunk_nr) {
> > +		unsigned int copy;
> >  		if (chunk_nr + i > nr_pages)
> >  			chunk_nr = nr_pages - i;
> 
> A newline after end-of-locals is conventional.
> 
> `i' and `chunk_nr' have type `unsigned long' and you're mixing that up
> with `unsigned int'.
> 
> > -		err = copy_from_user(chunk_pages, &pages[i],
> > -				     chunk_nr * sizeof(*chunk_pages));
> 
> And we mix it up with size_t as well.
> 
> The type choices are a bit confused and sloppy.  Converting it all to
> `unsigned int' should be OK.
> 
> > +		copy = chunk_nr * sizeof(*chunk_pages);
> > +		if (copy > DO_PAGES_STAT_CHUNK_NR)
> > +			return -EFAULT;

this seems a bit strange. 
the unit of copy is byte. but the unit of DO_PAGES_STAT_CHUNK_NR is
not byte.



> > +
> > +		err = copy_from_user(chunk_pages, &pages[i], copy);
> >  		if (err) {
> >  			err = -EFAULT;
> >  			goto out;
> 
> 



