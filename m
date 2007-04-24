Return-Path: <linux-kernel-owner+w=401wt.eu-S1423101AbXDXUy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423101AbXDXUy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423102AbXDXUy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:54:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423101AbXDXUyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:54:25 -0400
Date: Tue, 24 Apr 2007 13:53:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070424135348.4e69ac23.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704241344100.13005@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
	<20070423142919.5809e03f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
	<20070423154224.15ebf8f7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
	<20070424101116.1cb7512e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241954050.28487@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241254420.12907@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0704242109290.11314@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241326410.13005@schroedinger.engr.sgi.com>
	<20070424134206.95bd6c92.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241344100.13005@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 13:44:50 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 24 Apr 2007, Andrew Morton wrote:
> 
> > > I would say that the filesystem is broke if it has such expectations 
> > > regardless of page migration.
> > 
> > Others disagree ;)
> > 
> > The filesystem has *told* the core kernel what its allocation constraints
> > are by setting up mapping_gfp_mask().  If the core kernel stops honouring
> > that request then it is core kernel which is broken.
> 
> Then I think we should disable page migration for allocations that do not 
> allow access to the policy zone. That would fix it.

Can't we use mapping_gfp_mask() when allocating the destination page?

It would be better to do so, really.  Who knows, mapping_gfp_mask() might
be extented in the future to say "I want GFP_NOIO" or something.  Or a
filesystem might specify GFP_KERNEL for regular pagecache pages or
whatever.

Generally, the interface is "address_space tells core kernel how to
allocate its pages", and to be nice we should honour that in all places
where we allocate a page for an address_space.

If we'd had any brains we would have implemented this function as an
address_space_operations callback, but we don't so we didn't.

