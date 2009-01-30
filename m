Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZA3JWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZA3JWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZA3JWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:22:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbZA3JWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:22:20 -0500
Date: Fri, 30 Jan 2009 01:21:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, kerolasa@iki.fi,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Dickins <hugh@veritas.com>, dri-devel@lists.sourceforge.net,
       kerolasa@gmail.com
Subject: Re: PROBLEM: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
Message-Id: <20090130012134.bb4fe0bf.akpm@linux-foundation.org>
In-Reply-To: <4982C4D3.4040704@shipmail.org>
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com>
	<20090129172010.f25fe0ad.akpm@linux-foundation.org>
	<21d7e9970901291743q4f0a9393yc5c24afb50013ff3@mail.gmail.com>
	<200901291950.18724.jbarnes@virtuousgeek.org>
	<20090129204403.5d9e4b38.akpm@linux-foundation.org>
	<4982C4D3.4040704@shipmail.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 10:13:55 +0100 Thomas Hellstr__m <thomas@shipmail.org> wrote:

> >> Sounds right to me.  The offsets are just handles, not real file objects or 
> >> backing store addresses.  We use them to take advantage of all the inode 
> >> address mapping helpers, since they track stuff for us.
> >>
> >> That said, unmap_mapping_range may not be the best way to do this; basically 
> >> we need a way to invalidate a given processes' mapping of a GTT range (which 
> >> in turn is backed by real RAM).  If there's some other way we should be doing 
> >> this I'm all ears.
> >>     
> >
> > Well, we'd need to call in the big guns on this one - I've already
> > stirred Hugh ;)
> >
> > unmap_mapping_range() is basically a truncate thing - it shoots down
> > all mappings of a range of a *file*.  Across all processes in the
> > machine which map that file.
> >
> > If that isn't what you want to do (and it sounds that way) then you'd
> > want to use something which is mm_struct (or vma) centric, rather than
> > file-centric.  zap_page_range(), methinks.
> >
> >   
> I guess I was the one starting to use this function, so some explanation:
> 
> When the drm device is used to provide address space for buffers, 
> user-space actually see it as a file with a distinct offset where 
> buffers are laid out in a linear fashion, To access a certain buffer you 
> need to lseek() to the correct offset and then read() write() or, the 
> more common use, mmap / munmap.
> 
> When looking through its implementation, unmap_mapping_range() seemed to 
> do exactly the thing I wanted, namely to kill all user-space mappings of 
> all vmas of all processes mapping a part of the device address space. 

That's different from what Jesse said.  That _is_ a more appropriate
use of unmap_mapping_range().  Although all the futzing that function
does with truncate_count is now looking inappropriately-placed.

> And it saves us from storing a list of all vmas mapping the device 
> within the drm device.
> 
> What makes usage of unmap_mapping_range() on a device node with a well 
> defined offset-to-data mapping different from using it on a file?

umm, nothing I guess, if the driver sufficiently imitates a regular
file.  It's unexpected (by me).  I don't think we wrote that code with
this application in mind ;)



