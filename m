Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZESRbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZESRbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZESRbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:31:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZESRbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:31:44 -0400
Date: Tue, 19 May 2009 13:30:38 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 21/32] union-mount: Make lookup work for union-mounted file systems
Message-ID: <20090519173038.GC722@shell>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-22-git-send-email-jblunck@suse.de> <E1M6Ryq-0001RP-Oe@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M6Ryq-0001RP-Oe@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 06:15:52PM +0200, Miklos Szeredi wrote:
> On Mon, 18 May 2009, Jan Blunck wrote:
> > On union-mounted file systems the lookup function must also visit lower layers
> > of the union-stack when doing a lookup. This patches add support for
> > union-mounts to cached lookups and real lookups.
> > 
> > We have 3 different styles of lookup functions now:
> > - multiple pathname components, follow mounts, follow union, follow symlinks
> > - single pathname component, doesn't follow mounts, follow union, doesn't
> >   follow symlinks
> > - single pathname component doesn't follow mounts, doesn't follow unions,
> >   doesn't follow symlinks
> 
> Ugh...  I do wonder if this could be done in a less complicated way,
> there does seem to be a fair amount of duplication between these
> functions.

Yeah, I agree.  My best idea so far is not very good - have one
skeleton function and pass in function pointers for the
lookup_topmost() and build_union() functions.  Do you have any ideas?

> Worse, it looks like there are still i_mutex lock ordering issues
> (__hash_lookup_topmost()/__hash_lookup_build_union()).  What happens
> if two separate unions of two filesystems are built where the order of
> branches is reversed?

We have a similar problem in union_copyup_dir().  Hm, thinking about
this, only one of the file systems can actually change while we are
doing work.  That might help us get out of the lock ordering problems.
Thoughts?

-VAL
