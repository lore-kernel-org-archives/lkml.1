Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXDXUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXDXUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXDXUU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:20:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbXDXUU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:20:27 -0400
Date: Tue, 24 Apr 2007 13:20:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070424132018.f7ee0a2a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704241311390.13005@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
	<20070423142919.5809e03f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
	<20070423154224.15ebf8f7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0704241941421.28487@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241234341.12753@schroedinger.engr.sgi.com>
	<20070424124922.d406aac1.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241256470.12907@schroedinger.engr.sgi.com>
	<20070424131042.38c8cbff.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241311390.13005@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 13:12:42 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 24 Apr 2007, Andrew Morton wrote:
> 
> > > A highmem page can have buffers???
> > 
> > yep.  Take a 4k page which is stored in four discontiguous 1k disk blocks. The
> > data at page_buffers(page) is the sole way in which we track which parts of
> > the page belong to which blocks of the disk.
> 
> But I see no use of kmap for buffer access? The data is not accessible.
> 

The kernel rarely has a need to actually read or write the page's contents
with the CPU.  On those occasions where it does, it will use kmap.  Search
for zero_user_page() and kmap in rc7-mm1's fs/buffer.c

But that's file pagecache, which can be in highmem.  File metadata is accessed
within the filesystems without kmapping.  This:

box:/usr/src/linux-2.6.21-rc7> grep '[-]>b_data' fs/*/*.c | wc -l 
1017

explains why that never got fixed.
