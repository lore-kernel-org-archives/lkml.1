Return-Path: <linux-kernel-owner+w=401wt.eu-S934320AbZIOCFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320AbZIOCFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbZIOCF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:05:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:45686 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963AbZIOCF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,386,1249282800"; 
   d="scan'208";a="187617935"
Date: Tue, 15 Sep 2009 10:05:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       WANG Cong <xiyou.wangcong@gmail.com>, Mike Smith <scgtrp@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] devmem: handle partial kmem write/read
Message-ID: <20090915020518.GB15159@localhost>
References: <20090914032901.GA16189@localhost> <20090914043444.GA18590@localhost> <20090915092448.d511df31.kamezawa.hiroyu@jp.fujitsu.com> <20090915105255.091451c6.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915105255.091451c6.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 09:52:55AM +0800, KAMEZAWA Hiroyuki wrote:
> On Tue, 15 Sep 2009 09:24:48 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Mon, 14 Sep 2009 12:34:44 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > Hi Kame,
> > > 
> > > This patch needs more work. I first intent to fix a bug:
> > > 
> > >                         sz = vwrite(kbuf, (char *)p, sz);
> > >                         p += sz;
> > >                 }
> > > 
> > > So if the returned len is 0, the kbuf/p pointers will mismatch. 
> > > 
> > > Then I realize it changed the write behavior. The current vwrite()
> > > behavior is strange, it returns 0 if _whole range_ is hole, otherwise
> > > ignores the hole silently. So holes can be treated differently even in
> > > the original code.
> > > 
> > Ah, ok...
> > 
> 
> I'd like to post a fix...but it seems you are woriking.
> Hmm, I'll post a patch including your fix (and your sign.)
> Is it ok ?

Sure OK. You can work based on my patches. Many of them are in -mm now
and there are three more. I'll show you in a series.

Thanks,
Fengguang

> > > I'm not really sure about the right behavior. KAME-san, do you have
> > > any suggestions?
> > > 
> > maybe following make sense.
> > =
> > written = vwrite(kbuf, (char *p), sz);
> > if (!written) // whole vmem was a hole
> > 	written = sz;
> > ==
> > needs fix.
> > 
> > Anyway, I wonder kmem is broken. It's should be totally rewritten.
> > 
> > For example, this doesn't check anything.
> > ==
> >         if (p < (unsigned long) high_memory) {
> > 
> > ==
> > 
> > But....are there users ?
> > If necessary, I'll write some...
> > 
> > Thanks,
> > -Kame
> > 
> > 
> > > Thanks,
> > > Fengguang
> > > 
> > > On Mon, Sep 14, 2009 at 11:29:01AM +0800, Wu Fengguang wrote:
> > > > Current vwrite silently ignores vwrite() to vmap holes.
> > > > Better behavior should be stop the write and return
> > > > on such holes.
> > > > 
> > > > Also return on partial read, which may happen in future
> > > > (eg. hit hwpoison pages).
> > > > 
> > > > CC: Andi Kleen <andi@firstfloor.org>
> > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > ---
> > > >  drivers/char/mem.c |   30 ++++++++++++++++++------------
> > > >  1 file changed, 18 insertions(+), 12 deletions(-)
> > > > 
> > > > --- linux-mm.orig/drivers/char/mem.c	2009-09-14 10:59:50.000000000 +0800
> > > > +++ linux-mm/drivers/char/mem.c	2009-09-14 11:06:25.000000000 +0800
> > > > @@ -444,18 +444,22 @@ static ssize_t read_kmem(struct file *fi
> > > >  		if (!kbuf)
> > > >  			return -ENOMEM;
> > > >  		while (count > 0) {
> > > > +			unsigned long n;
> > > > +
> > > >  			sz = size_inside_page(p, count);
> > > > -			sz = vread(kbuf, (char *)p, sz);
> > > > -			if (!sz)
> > > > +			n = vread(kbuf, (char *)p, sz);
> > > > +			if (!n)
> > > >  				break;
> > > > -			if (copy_to_user(buf, kbuf, sz)) {
> > > > +			if (copy_to_user(buf, kbuf, n)) {
> > > >  				free_page((unsigned long)kbuf);
> > > >  				return -EFAULT;
> > > >  			}
> > > > -			count -= sz;
> > > > -			buf += sz;
> > > > -			read += sz;
> > > > -			p += sz;
> > > > +			count -= n;
> > > > +			buf += n;
> > > > +			read += n;
> > > > +			p += n;
> > > > +			if (n < sz)
> > > > +				break;
> > > >  		}
> > > >  		free_page((unsigned long)kbuf);
> > > >  	}
> > > > @@ -551,11 +555,13 @@ static ssize_t write_kmem(struct file * 
> > > >  				free_page((unsigned long)kbuf);
> > > >  				return -EFAULT;
> > > >  			}
> > > > -			sz = vwrite(kbuf, (char *)p, sz);
> > > > -			count -= sz;
> > > > -			buf += sz;
> > > > -			virtr += sz;
> > > > -			p += sz;
> > > > +			n = vwrite(kbuf, (char *)p, sz);
> > > > +			count -= n;
> > > > +			buf += n;
> > > > +			virtr += n;
> > > > +			p += n;
> > > > +			if (n < sz)
> > > > +				break;
> > > >  		}
> > > >  		free_page((unsigned long)kbuf);
> > > >  	}
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
