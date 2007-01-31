Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbXAaBLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbXAaBLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXAaBLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:11:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60583 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbXAaBLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:11:49 -0500
Date: Tue, 30 Jan 2007 17:11:32 -0800
From: Andrew Morton <akpm@osdl.org>
To: David Chinner <dgc@sgi.com>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-Id: <20070130171132.7be3b054.akpm@osdl.org>
In-Reply-To: <20070131004436.GS44411608@melbourne.sgi.com>
References: <1169993494.10987.23.camel@lappy>
	<20070128142925.df2f4dce.akpm@osdl.org>
	<1170063848.6189.121.camel@twins>
	<45BE9FE8.4080603@mbligh.org>
	<20070129174118.0e922ab3.akpm@osdl.org>
	<45BEA41A.6020209@mbligh.org>
	<20070129181557.d4d17dd0.akpm@osdl.org>
	<20070131004436.GS44411608@melbourne.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 11:44:36 +1100
David Chinner <dgc@sgi.com> wrote:

> On Mon, Jan 29, 2007 at 06:15:57PM -0800, Andrew Morton wrote:
> > We still don't know what is the source of kmap() activity which
> > necessitated this patch btw.  AFAIK the busiest source is ext2 directories,
> > but perhaps NFS under certain conditions?
> > 
> > <looks at xfs_iozero>
> > 
> > ->prepare_write no longer requires that the caller kmap the page.
> 
> Agreed, but don't we (xfs_iozero) have to map it first to zero it?
> 
> I think what you are saying here, Andrew, is that we can
> do something like:
> 
> 	page = grab_cache_page
> 	->prepare_write(page)
> 	kaddr = kmap_atomic(page, KM_USER0)
> 	memset(kaddr+offset, 0, bytes)
> 	flush_dcache_page(page)
> 	kunmap_atomic(kaddr, KM_USER0)
> 	->commit_write(page)
> 
> to avoid using kmap() altogether?
> 

Yup.  Even better, use clear_highpage().
