Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbZDAV2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbZDAV2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZDAV1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:27:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50860 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbZDAV1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:27:45 -0400
Date: Wed, 1 Apr 2009 17:26:30 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on
 inode->dirtied_when checks (try #3)
Message-ID: <20090401172630.31c6ac7c@tleilax.poochiereds.net>
In-Reply-To: <87y6ukktu9.fsf@basil.nowhere.org>
References: <1238607475-8203-1-git-send-email-jlayton@redhat.com>
	<87y6ukktu9.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 22:22:06 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Jeff Layton <jlayton@redhat.com> writes:
> >
> > The problem is that these checks assume that dirtied_when is updated
> > periodically. If an inode is continuously being used for I/O it can be
> > persistently marked as dirty and will continue to age. Once the time
> > difference between dirtied_when and the jiffies value it is being
> > compared to is greater than or equal to half the maximum of the jiffies
> > type, the logic of the time_*() macros inverts and the opposite of what
> > is needed is returned. On 32-bit architectures that's just under 25 days
> > (assuming HZ == 1000).
> 
> I wonder if this can happen in other places using jiffies time stamp
> too. Why not? Perhaps that check macro should be in timer.h and some auditing done
> over the whiole code base?
> 

It certainly can happen in other places. We've seen very similar
problems in NFS, and they were fixed in similar ways. That's where the
time_in_range macro came from. I agree that a thorough audit of jiffies
usage would be a fine thing...

One possibility might be a new debugging option. We could add
replacement time_after() and time_before() macros that also check
whether the difference in times is beyond a certain threshold
(maybe a day or week or so), and pop a printk or otherwise record
info about it when one is detected?

That wouldn't find all of the problem cases, but it might help ID some
of them.

-- 
Jeff Layton <jlayton@redhat.com>
