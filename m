Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYKTUKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYKTUKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYKTUK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:10:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:36169 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYKTUK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HMfTibabDWcO/M8VhD2WpEPK6OTBT3nqiZrt8NZ6I53Fdtykv0k5Jd5zlftMx+QX0y
         u/3qpVxAJo8VmiDY0iKJC6zX9WhsXYpPC9k6sNO+TiYkzXHWeuFHgnR6fO9pv3ZpWZH0
         YedEYpTmr4PiSQuhBJ2TJdQNh0rRZ/j4hLCPg=
Date: Thu, 20 Nov 2008 23:10:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: slab - __cache_alloc NULL prefetch fix
Message-ID: <20081120201022.GA5611@localhost>
References: <20081120164400.GC7363@localhost> <28180.1227211108@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28180.1227211108@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Valdis.Kletnieks@vt.edu - Thu, Nov 20, 2008 at 02:58:28PM -0500]
| On Thu, 20 Nov 2008 19:44:00 +0300, Cyrill Gorcunov said:
| 
| > -	prefetchw(objp);
| >  
| > -	if (likely(objp))
| > +	if (likely(objp)) {
| > +		prefetchw(objp);
| >  		kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
| > +	}
| 
| Although it probably makes sense to not bother prefetching NULL, I also
| need to wonder how useful it is to prefetch something that we then
| turn around and dereference in the very next line of code.
| 
| Maybe we should just lose the prefetch entirely?

In case of obj == NULL it would not be a really penalty.
I heard there was a problem passing NULL to prefetch on
some PPC machines but PPC code already well protected
against it. So in most cases obj would not be null and
hint cpu that we will use this obj soon is good choise
I think. In case of kmemcheck it's true if only kmemcheck
was turned on, otherwise this if(obj) with empty kmemcheck_slab_alloc
body will be eliminated by compiler but in case of having there
(inside of 'if' block) prefetchw(objp) I'm not sure what gcc
will decide :-) Anyway -- it was a false alram from me since
having prefetch in original place is not problem. And maybe
modern cpus even have a special trap for NULL prefetch
target and eliminate it out on decoding stage without penalty
(just a guess).

		- Cyrill -
