Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbZHDQZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbZHDQZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932957AbZHDQZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:25:53 -0400
Received: from sandeen.net ([209.173.210.139]:11536 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932954AbZHDQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:25:53 -0400
Message-ID: <4A786110.8090404@sandeen.net>
Date: Tue, 04 Aug 2009 11:25:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
CC: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, hch@lst.de,
       linux-kernel@vger.kernel.org, mszeredi@novell.com
Subject: Re: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
 device
References: <1249329808.7686.26.camel@logos>	<20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>
In-Reply-To: <1249351241.7513.18.camel@logos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramon de Carvalho Valle wrote:
> On Mon, 2009-08-03 at 17:49 -0400, Christoph Hellwig wrote:
>> On Mon, Aug 03, 2009 at 05:03:28PM -0300, Ramon de Carvalho Valle wrote:
>>> The __xfs_get_blocks function does not check if the pointer to the target
>>> device is valid before dereferencing it.
>> It should never be zero.  It's set by xfs_imap_to_bmap to either
>> mp->m_ddev_targp which is always allocated, or to mp->m_rtdev_targp
>> which is always allocated if we have a realtime device, and
>> XFS_IS_REALTIME_INODE should only be true in that case.
>>
> 
> While testing XFS code with a modified version of fsfuzzer on SLES 10
> SP3 (Kernel 2.6.16.60-0.49.3.ramon-ppc64), I came across the following
> Oops:

...

ahah, useful information that would have been great in the original
patch submission.  :)

> I added a printk() line just before the:
> 
> 	bh_result->b_bdev = iomap.iomap_target->bt_bdev;
> 
> and as we can see iomap.iomap_target is NULL.
> 
> My guess is that the XFS_DIFLAG_REALTIME flag is being set incorrectly
> on the xfs inode structure, setting iomapp->iomap_target to the wrong
> device pointer (probably NULL).
> 
> I don't know if this is the best place to add a check, neither if
> returning -XFS_ERROR(EIO) is correct at this point. Maybe doing:
> 
> 	if (iomap.iomap_target && omap.iomap_flags & IOMAP_REALTIME)
> 		bh_result->b_bdev = iomap.iomap_target->bt_bdev;
> 
> would be a better solution.

Can you test hch's patch w/ your fuzzed image?

Thanks,
-Eric
