Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbZA3Duf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbZA3Duf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZA3DuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:50:25 -0500
Received: from outbound-mail-19.bluehost.com ([69.89.20.234]:52710 "HELO
	outbound-mail-19.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753360AbZA3DuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:50:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hzMqPguzWsqFZmJJv5e4I4fQKXs9K0rQkZG0Y/WZrMupFrrUuznW/U67k3y3GOgOLAXBG997REU7Y00zTCE5fo4x7zGZxlDvhUbgfrD6RraasM0nfWg7QM9yqjKXlH1b;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: PROBLEM: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
Date: Thu, 29 Jan 2009 19:50:17 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, kerolasa@gmail.com,
       kerolasa@iki.fi, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>,
       Laurent Pinchart <laurent.pinchart@skynet.be>
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com> <20090129172010.f25fe0ad.akpm@linux-foundation.org> <21d7e9970901291743q4f0a9393yc5c24afb50013ff3@mail.gmail.com>
In-Reply-To: <21d7e9970901291743q4f0a9393yc5c24afb50013ff3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291950.18724.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 29, 2009 5:43 pm Dave Airlie wrote:
> On Fri, Jan 30, 2009 at 11:20 AM, Andrew Morton
> > hm, I'm a bit surprised to see the drm code using `struct
> > address_space' and read_mapping_page() and unmap_mapping_range() and
> > such.  I thought those only worked with regular files and pagecache :)
> >
> > Is it possible to briefly explain what's going on there?
> >
> > What instance of address_space_operations does ->dev_mapping actually
> > point at?
>
> Okay a bit tired and headache coming on but I'll try, maybe jbarnes
> can help out,
>
> We need to provide mappings to userspace that are backed by memory
> that can move around behind the mappings.
>
> So userspace wants a mapping for a GEM object via the AGP/GTT aperture
> instead of directly to the backing pages.
> Now as the GEM object is backed by shmem we can't use the shmem file
> descriptor we have to tie the mapping to without
> hacking up the shmem mmap functionality which seemed like a bad plan.
>
> So GEM uses the device inode to setup the mappings on. We just use a
> simple linear allocator to split up the device inodes address space
> and assign chunks to handles for different objects. The userspace app
> then uses the handle via mmap to get access to the VMAs. Now when GEM
> wants to move that object out of the GTT or to another area of the GTT
> we need some way to invalidate it, so we use unmap_mapping_range
> which destroys all the mappings for the object in all the VMA for all
> the processes mapping it currently
>
> GEM's read_mapping_page is distinct from this and is to do with the
> shmem interfaceing.
>
> Not sure if this explains it or just make it worse.

Sounds right to me.  The offsets are just handles, not real file objects or 
backing store addresses.  We use them to take advantage of all the inode 
address mapping helpers, since they track stuff for us.

That said, unmap_mapping_range may not be the best way to do this; basically 
we need a way to invalidate a given processes' mapping of a GTT range (which 
in turn is backed by real RAM).  If there's some other way we should be doing 
this I'm all ears.

-- 
Jesse Barnes, Intel Open Source Technology Center
