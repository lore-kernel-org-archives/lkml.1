Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0CAXWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:22:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640Ab0CAXWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:22:35 -0500
Date: Mon, 1 Mar 2010 15:21:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch] RFC directio: partial writes support
Message-Id: <20100301152149.7ce78e14.akpm@linux-foundation.org>
In-Reply-To: <87iq9lxz3t.fsf@openvz.org>
References: <87iq9lxz3t.fsf@openvz.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010 15:45:58 +0300
Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> Can someone please describe me why directio deny partial writes.
> For example if someone try to write 100Mb but file system has less
> data it return ENOSPC in the middle of block allocation.
> All allocated blocks will be truncated (it may be 100Mb -4k) end
> ENOSPC will be returned. As far as i remember direct_io always act
> like this, but i never asked why?
> Why do we have to give up all the progress we made?
> In fact partial writes are possible in case of holes, when we 
> fall back to buffered write. XFS implemented partial writes.

The problem with direct-io writes is that the writes don't necessarily
complete in file-offset-ascending order.  So if we've issued 50 write
BIOs and then hit an EIO on a BIO then we could have a hunk of
unwritten data with newly-writted data either side of it.  If we get a
bunch of discontiguous EIO BIOs coming in then the problem gets even
messier - we have a span of disk which has a random mix of
correctly-written and not-correctly-written runs of sectors.  What do
we do with that?

The code _could_ perhaps go back and crawl through the request and
identify the number of successfully-written bytes between
start-of-request and first-EIO and then return that.  But we didn't
bother.


ENOSPC errors are handled via the same code path and hence got
deoptimised due to this EIO handling.  We could perhaps improve the
ENOSPC handling along the lines you propose, as long as we
appropriately take care of EIO considerations.  Which, afacit, your
patch didn't do.

The presence of opt-in DIO_PARTIAL_WRITE thing is rather unfortunate -
it would be better to make this change for all filesystems in one hit. 
But I guess DIO_PARTIAL_WRITE permits us to migrate filesystems
one-at-a-time as testing permits.  But the aim should be to remove
DIO_PARTIAL_WRITE altogether once all the conversion and testing is
completed.

