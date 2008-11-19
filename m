Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbYKSIxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbYKSIxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYKSIx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:53:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40214 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbYKSIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:53:27 -0500
Date: Wed, 19 Nov 2008 09:52:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Julia Lawall <julia@diku.dk>, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] kernel/trace/trace.c: introduce missing kfree
Message-ID: <20081119085245.GA22309@elte.hu>
References: <Pine.LNX.4.64.0811141904580.10023@pc-004.diku.dk> <20081118144217.34ffa4e1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118144217.34ffa4e1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 14 Nov 2008 19:05:31 +0100 (CET)
> Julia Lawall <julia@diku.dk> wrote:
> 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Error handling code following a kzalloc should free the allocated data.
> > 
> > The semantic match that finds the problem is as follows:
> > (http://www.emn.fr/x-info/coccinelle/)
> > 
> > // <smpl>
> > @r exists@
> > local idexpression x;
> > statement S;
> > expression E;
> > identifier f,l;
> > position p1,p2;
> > expression *ptr != NULL;
> > @@
> > 
> > (
> > if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
> > |
> > x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> > ...
> > if (x == NULL) S
> > )
> > <... when != x
> >      when != if (...) { <+...x...+> }
> > x->f = E
> > ...>
> > (
> >  return \(0\|<+...x...+>\|ptr\);
> > |
> >  return@p2 ...;
> > )
> > 
> > @script:python@
> > p1 << r.p1;
> > p2 << r.p2;
> > @@
> > 
> > print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > ---
> >  kernel/trace/trace.c          |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 697eda3..d86e325 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -1936,6 +1936,7 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
> >  			ring_buffer_read_finish(iter->buffer_iter[cpu]);
> >  	}
> >  	mutex_unlock(&trace_types_lock);
> > +	kfree(iter);
> >  
> >  	return ERR_PTR(-ENOMEM);
> >  }
> 
> Nobody seems to have applied this to anything yet?

it's in tip/tracing/urgent:

  0bb943c: tracing: kernel/trace/trace.c: introduce missing kfree()

> That function really needs help.  Sometimes it will return NULL and 
> will set *ret.  Other times it will return ERR_PTR(-ENOMEM) and will 
> fail to write anything to *ret.  One caller (tracing_open) ignores 
> the return value.  Another caller (tracing_lt_open) tests the 
> possibly-uninitialised `ret' and then blindly dereferences the 
> possibly-IS_ERR return value.
> 
> Or something like that.  I looked at it long enough to convince 
> myself that it needs fixing ;)

agreed, it's messy. At minimum the ordering is wrong: it should not 
return the iterator but 'ret' - the _iterator_ value can then be a 
side-effect (dependent on the return value being fine).

the usage site clearly shows the problem:

static int tracing_open(struct inode *inode, struct file *file)
{
        int ret;

        __tracing_open(inode, file, &ret);

        return ret;
}

that could then be a simple:

static int tracing_open(struct inode *inode, struct file *file)
{
        return __tracing_open(inode, file, NULL);
}

and we wouldnt allocate an iterator if the iter ptr is NULL. (which we 
seem to leak in tracing_open() right now!)

	Ingo
