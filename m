Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZDWVX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZDWVX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbZDWVXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:23:17 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50136 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZDWVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:23:16 -0400
Date: Thu, 23 Apr 2009 22:23:14 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Message-ID: <20090423212314.GK13326@shareable.org>
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423192123.GL4593@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> The intent was to add some sort of notification mechanism from the file
> system to inform the IO scheduler (and others?) that this process is how
> holding a file system wide resource. So if you have a low priority
> process getting access to such a resource, you want to boost its
> priority to avoid higher priority apps getting stuck beind it. Sort of a
> poor mans priority inheritance.

Very closely related to this: I'm building something where I want one
particular task to have absolute higher I/O priority than all other
tasks.  No problem, use the lovely RT I/O priority facility.

But if that task needs access to a buffer or page which is already
undergoing I/O started by another task - what happens?  I'd like the
_I/O_ priority to be boosted in that case, so that the high priority
task does not have to wait on a long queue of low priority I/Os.

E.g. this happens when the high priority task reads from a file, and a
low priority task has already initiated readahead for that file.  It's
a particular problem if the low priority task's I/O is queued behind a
lot of other low priority I/O.

That can be avoided by just not reading the same files :-)  But more
subtly, the high priority task may find itself waiting on metadata
blocks which overlap metadata blocks from I/O in a low priority tasks.
The application can't easily avoid this.

So I'd like operations which wait for I/O to complete to compare the
task's I/O priority with the I/O request already queued, and boost the
request priority if it's lower, moving it forward in the elevator if
necessary.

All this to guarantee a high I/O priority task has a maximum response
time no matter what low priority I/O is doing.  Even O_DIRECT has to
read metadata sometimes...

It seems if I/O priority boosting were implemented like this, that
might solve the superblock priority thing too, without needing
filesystem changes and generically for all metadata?

How hard would it be to do this?

Thanks,
-- Jamie
