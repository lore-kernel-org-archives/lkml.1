Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0CBJZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:25:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:38804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab0CBJZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:25:10 -0500
Date: Tue, 2 Mar 2010 20:25:02 +1100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch] RFC directio: partial writes support
Message-ID: <20100302092502.GD8653@laptop>
References: <87iq9lxz3t.fsf@openvz.org>
 <20100301152149.7ce78e14.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301152149.7ce78e14.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 03:21:49PM -0800, Andrew Morton wrote:
> On Thu, 25 Feb 2010 15:45:58 +0300
> Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> 
> > Can someone please describe me why directio deny partial writes.
> > For example if someone try to write 100Mb but file system has less
> > data it return ENOSPC in the middle of block allocation.
> > All allocated blocks will be truncated (it may be 100Mb -4k) end
> > ENOSPC will be returned. As far as i remember direct_io always act
> > like this, but i never asked why?
> > Why do we have to give up all the progress we made?
> > In fact partial writes are possible in case of holes, when we 
> > fall back to buffered write. XFS implemented partial writes.
> 
> The problem with direct-io writes is that the writes don't necessarily
> complete in file-offset-ascending order.  So if we've issued 50 write
> BIOs and then hit an EIO on a BIO then we could have a hunk of
> unwritten data with newly-writted data either side of it.  If we get a
> bunch of discontiguous EIO BIOs coming in then the problem gets even
> messier - we have a span of disk which has a random mix of
> correctly-written and not-correctly-written runs of sectors.  What do
> we do with that?

Hmm, what if we're filling in a hole with direct IO? I don't see where
blocks allocated in DIO code will be trimmed on a failed write (because
it's within isize). This could cause uninitalized data of the block to
leak couldn't it?

