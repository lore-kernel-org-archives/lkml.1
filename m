Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYGYK55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYGYK55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYGYK5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:57:46 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:45974 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYGYK5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:57:45 -0400
Subject: Re: [PATCH 30/30] nfs: fix various memory recursions possible with
	swap over NFS.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>
In-Reply-To: <20080725194517.86BB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080724140042.408642539@chello.nl>
	 <20080724141531.486682621@chello.nl>
	 <20080725194517.86BB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 12:57:52 +0200
Message-Id: <1216983472.7257.365.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 19:46 +0900, KOSAKI Motohiro wrote:
> > GFP_NOFS is not enough, since swap traffic is IO, hence fall back to GFP_NOIO.
> 
> this comment imply turn on GFP_NOIO, but the code is s/NOFS/NOIO/. why?

Does the misunderstanding stem from the use of 'enough'?

GFP_NOFS is _more_ permissive than GFP_NOIO in that it will initiate IO,
just not of any filesystem data.

The problem is that previuosly NOFS was correct because that avoids
recursion into the NFS code, it now is not, because also IO (swap) can
lead to this recursion.

Therefore we must tighten the restriction and use NOIO.

> >  struct nfs_write_data *nfs_commitdata_alloc(void)
> >  {
> > -	struct nfs_write_data *p = kmem_cache_alloc(nfs_wdata_cachep, GFP_NOFS);
> > +	struct nfs_write_data *p = kmem_cache_alloc(nfs_wdata_cachep, GFP_NOIO);
> 
> 
> 
> 

