Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbZAPXSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbZAPXSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbZAPXSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:18:33 -0500
Received: from kroah.org ([198.145.64.141]:37622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753049AbZAPXSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:18:32 -0500
Date: Fri, 16 Jan 2009 14:48:18 -0800
From: Greg KH <greg@kroah.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 68/85] fs: symlink write_begin allocation context fix
Message-ID: <20090116224818.GA26734@kroah.com>
References: <20090115215237.906089480@mini.kroah.org> <20090115220136.GQ17227@kroah.com> <20090115223117.GA30560@kroah.com> <20090116025310.GH17810@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116025310.GH17810@wotan.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 03:53:10AM +0100, Nick Piggin wrote:
> On Thu, Jan 15, 2009 at 02:31:17PM -0800, Greg KH wrote:
> > On Thu, Jan 15, 2009 at 02:01:36PM -0800, Greg KH wrote:
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > Hm, I think I got the backport of this patch wrong in two place:
> > 
> > > --- a/mm/filemap.c
> > > +++ b/mm/filemap.c
> > > @@ -2033,7 +2033,7 @@ int pagecache_write_begin(struct file *f
> > >  		struct inode *inode = mapping->host;
> > >  		struct page *page;
> > >  again:
> > > -		page = __grab_cache_page(mapping, index);
> > > +		page = grab_cache_page_write_begin(mapping, index, flags);
> > 
> > I think this shouldn't be "flags", but 0, right?
> 
> I think flags is right. That way, a caller of pagecache_write_begin (eg. page_symlink)
> can instruct it with AOP_FLAG_NOFS to prevent grab_cache_page from doing a GFP_KERNEL
> allocation.

Ok, I'll leave that one.

> > > @@ -2263,7 +2268,7 @@ static ssize_t generic_perform_write_2co
> > >  			break;
> > >  		}
> > >  
> > > -		page = __grab_cache_page(mapping, index);
> > > +		page = grab_cache_page_write_begin(mapping, index, GFP_KERNEL);
> > 
> > And this one?  Is GFP_KERNEL ok, or 0?
> > 
> > Nick, your thoughts?
> 
> This should be 0. grab_cache_page_write_begin takes write_begin aop flags rather
> than regular gfp flags (it's a bit confusing, sorry :P). 0 ~= GFP_KERNEL (wheras
> AOP_FLAG_NOFS ~= GFP_NOFS). So you have the right idea ;)

I'll go fix this up and release a -rc2 with the fix in it.

thanks,

greg k-h
