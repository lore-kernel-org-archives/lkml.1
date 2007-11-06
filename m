Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbXKFVkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbXKFVkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbXKFVkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:40:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbXKFVkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:40:12 -0500
Date: Tue, 6 Nov 2007 13:38:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dirk Hohndel <hohndel@linux.intel.com>
cc: Bob Copeland <me@bobcopeland.com>, Jens Axboe <jens.axboe@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FS: add_partition silently ignored errors
In-Reply-To: <20071106200259.GA3879@linux.intel.com>
Message-ID: <alpine.LFD.0.999.0711061334030.15101@woody.linux-foundation.org>
References: <20071029154849.GA24187@bigserver.hohndel.org>
 <20071030080742.GE4993@kernel.dk> <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com>
 <20071030165608.GA2601@linux.intel.com> <20071030183112.7e860c23@gondolin.boeblingen.de.ibm.com>
 <20071030225635.GA3401@linux.intel.com> <20071102130438.GC28340@kernel.dk>
 <20071102192914.GA888@linux.intel.com> <b6c5339f0711021250w78fc420ekbc68e3c74b9939d3@mail.gmail.com>
 <20071102202949.GA1128@linux.intel.com>
 <20071106200259.GA3879@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Nov 2007, Dirk Hohndel wrote:
>
> (since there was no more discussion, here's the last version that includes
> the requested change to not fail if the partition is larger than the disk)

I'd suggest keeping it in -mm for a while.

I worry about these kinds of "trivial" changes.  Quite often, some errors 
may be normal, and breaking out early can sometimes hurt more than it 
helps, in that it just makes things not even limp along. That said, with 
the disk/partition size check removed, this looks more palatable.

> -			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
> +			err = add_partition(disk, part, start, length,
> +						ADDPART_FLAG_NONE)
> +			if (err) {
> +				mutex_unlock(&bdev->bd_mutex);
> +				return err;
> +			}
>  			mutex_unlock(&bdev->bd_mutex);
>  			return 0;

However, this is just ugly. The thing is not only apparently totally 
untested, since it is missing a semicolon, it should also just read

	err = add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
	mutex_unlock(&bdev->bd_mutex);
	return err;

without any unnecessary conditionals (or ugly line-breaks, for that 
matter).

> -		sysfs_create_file(&p->kobj, &addpartattr);
> +		err = sysfs_create_file(&p->kobj, &addpartattr);
> +		if (err) {
> +			sysfs_remove_link(&p->kobj, "subsystem");
> +			goto out_cleanup;

Wouldn't this be better done as

	if (err)
		goto out_unlink_cleanup;

to match the rest of the error handling?

			Linus
