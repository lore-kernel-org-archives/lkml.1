Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613Ab0A1WPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0A1WPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305Ab0A1WPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:15:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab0A1WPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:15:10 -0500
Date: Fri, 29 Jan 2010 09:14:57 +1100
From: Neil Brown <neilb@suse.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Ing. Daniel =?UTF-8?B?Um96c255w7M=?=" <daniel@rozsnyo.com>,
       Milan Broz <mbroz@redhat.com>, Marti Raudsepp <marti@juffo.org>,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: bio too big - in nested raid setup
Message-ID: <20100129091457.0088c4af@notabene>
In-Reply-To: <4B617E03.1050403@panasas.com>
References: <4B5C963D.8040802@rozsnyo.com>
	<5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>
	<4B5DE2A9.4030500@redhat.com>
	<20100128132812.2d01f211@notabene>
	<4B6157DB.6080502@rozsnyo.com>
	<20100128215015.0e0ed3a8@notabene>
	<4B617E03.1050403@panasas.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 14:07:31 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 01/28/2010 12:50 PM, Neil Brown wrote:
> > 
> > Both raid0 and linear register a 'bvec_mergeable' function (or whatever it is
> > called today).
> > This allows for the fact that these devices have restrictions that cannot be
> > expressed simply with request sizes.  In particular they only handle requests
> > that don't cross a chunk boundary.
> > 
> > As raid1 never calls the bvec_mergeable function of it's components (it would
> > be very hard to get that to work reliably, maybe impossible), it treats any
> > device with a bvec_mergeable function as though the max_sectors were one page.
> > This is because the interface guarantees that a one page request will always
> > be handled.
> > 
> 
> I'm also guilty of doing some mirror work, in exofs, over osd objects.
> 
> I was thinking about that reliability problem with mirrors, also related
> to that infamous problem of coping the mirrored buffers so they do not
> change while writing at the page cache level.

So this is a totally new topic, right?

> 
> So what if we don't fight it? what if we just keep a journal of the mirror
> unbalanced state and do not page_uptodate until the mirror is finally balanced.
> Only then pages can be dropped from the cache, and journal cleared.

I cannot see what you are suggesting, but it seems like a layering violation.
The block device level cannot see anything about whether the page is up to
date or not.  The page it has may not even be in the page cache.

The only thing that the block device can do is make a copy of the page and
write that out twice.

If we could have a flag which the filesystem can send to say "I promise not
to change this page until the IO completes", then that copy could be
optimised away in lots of common cases.


> 
> (Balanced-mirror-page is when a page has participated in an IO to all devices
>  without being marked dirty from the get-go to the completion of IO)
> 

Block device cannot see the 'dirty' flag.


> I think Trond's last work with adding that un_updated-but-committed state to
> pages can facilitate in doing that, though I do understand that it is a major
> conceptual change to the the VFS-BLOCKS relationship in letting the block devices
> participate in the pages state machine (And md keeping a journal). Sigh
> 
> ??
> Boaz

NeilBrown
