Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYAYQfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYAYQfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYAYQez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:34:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbYAYQex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:34:53 -0500
Message-ID: <479A0F91.2030206@redhat.com>
Date: Fri, 25 Jan 2008 10:34:25 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Takashi Sato <t-sato@yk.jp.nec.com>,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3 freeze feature
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
In-Reply-To: <20080125133329.GB8184@mit.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> The other approach would be to say, "oh well, the freeze ioctl is
> inherently dangerous, and root is allowed to himself in the foot, so
> who cares".  :-)

I tend to agree.  Either you need your fs frozen, or not, and if you do,
be prepared for the consequences.

> But it was this concern which is why ext3 never exported freeze
> functionality to userspace, even though other commercial filesystems
> do support this.  It wasn't that it wasn't considered, but the concern
> about whether or not it was sufficiently safe to make available.

What's the safety concern; that the admin will forget to unfreeze?

> And I do agree that we probably should just implement this in
> filesystem independent way, in which case all of the filesystems that
> support this already have super_operations functions
> write_super_lockfs() and unlockfs().

That's what I was thinking; can't the path to freeze_bdev just be
elevated out of dm-ioctl.c to fs/ioctl.c and exposed, such that any
filesystem which implements .write_super_lockfs can be frozen?  This is
essentially what the xfs_freeze userspace does via
xfs_ioctl/XFS_IOC_FREEZE - which, AFAIK, isn't used much now that the
lvm hooks are in place.

I'm also not sure I see the point of the timeout in the original patch;
either you are done snapshotting and ready to unfreeze, or you're not;
1, or 2, or 3 seconds doesn't really matter.  When you're done, you're
done, and you can only unfreeze then.  Shouldn't this be done
programmatically, and not with some pre-determined timeout?

-Eric
