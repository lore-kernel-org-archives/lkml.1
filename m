Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZIVLHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZIVLHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZIVLHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:07:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34077 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZIVLHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:07:41 -0400
Date: Tue, 22 Sep 2009 12:07:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>
Cc: Christoph Hellwig <hch@lst.de>, t-sato@yk.jp.nec.com,
       m-hamaguchi@ys.jp.nec.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/4] Do not allow umounting of frozen filesystems
Message-ID: <20090922110737.GL5858@ZenIV.linux.org.uk>
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de> <4A965BD1.205@oss.ntt.co.jp> <4A9692CF.80508@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9692CF.80508@oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 11:06:07PM +0900, Fernando Luis V?zquez Cao wrote:
> Instead of making umount users wait until the filesystem is
> unfreezed return EBUSY, which is very convenient in HA
> configurations.
>
> This could have been implemented at a lower level but it would
> require considerable plumbing in functions such as release_mounts
> which do not return errors.

> +	if (sb->s_bdev != NULL) {
> +		mutex_lock(&sb->s_bdev->bd_fsfreeze_mutex);
> +		if (sb->s_frozen != SB_UNFROZEN) {
> +			mutex_unlock(&sb->s_bdev->bd_fsfreeze_mutex);
> +			return -EBUSY;
> +		}
> +	}

NAK.  First of all, it _partially_ breaks umount -l for no good reason.
If the first fs on the mountpoint is frozen, we fail; if it's deeper
we succeed just fine (and delay actual fs shutdown until the thaw).

As far as I can see, the real problem is that fsthaw ioctl has braindead
API; it takes some opened file on fs in question.  Why not do a bdev
ioctl instead?  Then we could let umount go ahead just fine, leaving
fs frozen (and not shut down until it thaws).  And whoever does thaw
(via bdev ioctl) will automatically trigger the actual fs shutdown.
Just with Christoph's pair of patches...

IOW, I'd rather add two new ioctls (check if frozen/thaw), both by
bdev.  On top of the first two patches in this set.

Comments?
