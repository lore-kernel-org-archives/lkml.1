Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYEPWak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYEPWak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYEPWa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:30:29 -0400
Received: from mail2.shareable.org ([80.68.89.115]:49925 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYEPWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:30:28 -0400
Date: Fri, 16 May 2008 23:30:23 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080516223023.GF15334@shareable.org>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516130545.845a3be9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > A collection of patches to make ext3 & 4 use barriers by
> > default, and to call blkdev_issue_flush on fsync if they
> > are enabled.
> 
> Last time this came up lots of workloads slowed down by 30% so I
> dropped the patches in horror.

Apart from batching larger journal commits, I thought of another way
which might improve write performance with barriers.

Basically, right now a barrier prevents any write I/Os from being
moved before or after it in the elevator, as well as issuing commands
itself.

It may be that relaxing barriers to allow moving writes when it's fine
will allow the elevator to schedule writes to reduce seeking?

A clear example of when it's fine is data=ordered, overwriting data in
a file.  Those data writes don't have to be ordered against other
filesystem activity which is triggering journal commits.  So they
could be moved around barrier ops, if the elevator deems that would
reduce seeks or to coalesce ops.

Similar arguments apply to moving writes past fsync() flushes, but the
rules are a bit different.

-- Jamie


