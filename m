Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbXGZO37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbXGZO37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762304AbXGZO3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:29:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:54272 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbXGZO3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:29:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d6qJIDHEO09WJAsLld0rnOuphH4Zwzvs5jsiRcvSDGEVA4vHp2tTxkEZstdv/PBCxX9XKTbUYM/jWC4Y+zpx1bRTGuA/oW7Y3VqfBnbQfGrdvyBjzgSynr7WHjDX9YMizpp6AGGH+hYQw1/fQyx5oVFKCOXFg4AFeLD8gRAzups=
Message-ID: <a4e6962a0707260729g4a451d13iaed2097428c7118a@mail.gmail.com>
Date: Thu, 26 Jul 2007 09:29:50 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: net/9p/mux.c: use-after-free
Cc: "Latchesar Ionkov" <lucho@ionkov.net>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070725202030.7ecf339c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070723012014.GV26212@stusta.de>
	 <a4e6962a0707251143ie0b0ce8s7d4a9078fed7eb26@mail.gmail.com>
	 <20070725202030.7ecf339c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 25 Jul 2007 13:43:16 -0500 "Eric Van Hensbergen" <ericvh@gmail.com> wrote:
>
> >                 mtmp = ERR_PTR(PTR_ERR(m->tagpool));
>
> odd.  What does ERR_PTR(PTR_ERR(...)) do?
>

I kind of assumed it was a necessry evil to get the casting right.  A
quick grep shows it in 42 other places within the kernel.  Unpacking
the macros it looks like:

   (void *)(long)(struct p9_idpool *)

So all that you would really need is (void *) or ERR_PTR -- but that
might look confusing in the code.  Of course, broadening the context a
bit:

        m->tagpool = p9_idpool_create();
        if (!m->tagpool) {
                mtmp = ERR_PTR(PTR_ERR(m->tagpool));
                kfree(m);
                return mtmp;
        }

m->tagpool must be zero to enter the code at all, so we are returning
a NULL pointer, not really an error -- which is probably wrong (I
don't think it will properly trigger IS_ERR_VALUE) -- so we should
probably be returning -ENOMEM.

Of course, we really should be seeing an ERR_PTR returned from
p9_idpool_create, not 0 -- checking that code, it either returns
-ENOMEM or the correct value, never 0, so the check is wrong as well.
It should be:

        m->tagpool = p9_idpool_create();
        if (IS_ERR(m->tagpool)) {
                mtmp = ERR_PTR(-ENOMEM);
                kfree(m);
                return mtmp;
        }

We could have done:
   ERR_PTR(m->tagpool);
or kept the long:
   ERR_PTR(PTR_ERR(m->tagpool));
but I think returning an explicit error code keeps the code more clear.

So, which is the correct approach?

                   -eric
