Return-Path: <linux-kernel-owner+w=401wt.eu-S1751398AbZHAEK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbZHAEK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 00:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZHAEKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 00:10:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:18568 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbZHAEKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 00:10:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,306,1246863600"; 
   d="scan'208";a="171172684"
Date: Sat, 1 Aug 2009 12:10:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090801041042.GA13747@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com> <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com> <20090729114322.GA9335@localhost> <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com> <33307c790907291828x6906e874l4d75e695116aa874@mail.gmail.com> <20090730020922.GD7326@localhost> <33307c790907291957n35c55afehfe809c6583b10a76@mail.gmail.com> <20090730031927.GA17669@localhost> <33307c790907301333i28b571eat29460164d558d370@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790907301333i28b571eat29460164d558d370@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 04:33:09AM +0800, Martin Bligh wrote:
> (BTW: background ... I'm not picking through this code for fun, I'm
> trying to debug writeback problems introduced in our new kernel
> that are affecting Google production workloads ;-))
> 
> >> Well, I see two problems. One is that we set more_io based on
> >> whether s_more_io is empty or not before we finish the loop.
> >> I can't see how this can be correct, especially as there can be
> >> other concurrent writers. So somehow we need to check when
> >> we exit the loop, not during it.
> >
> > It is correct inside the loop, however with some overheads.
> >
> > We put it inside the loop because sometimes the whole filesystem is
> > skipped and we shall not set more_io on them whether or not s_more_io
> > is empty.
> 
> My point was that you're setting more_io based on a condition
> at a point in time that isn't when you return to the caller.
> 
> By the time you return to the caller (after several more loops
> iterations), that condition may no longer be true.
> 
> One other way to address that would to be only to set if if we're
> about to fall off the end of the loop, ie change it to:
> 
> if (!list_empty(&sb->s_more_io) && list_empty(&sb->s_io))
>        wbc->more_io = 1;

Ah I see it (as the below patch), looks reasonable to me.

Thanks,
Fengguang

---
 fs/fs-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- sound-2.6.orig/fs/fs-writeback.c
+++ sound-2.6/fs/fs-writeback.c
@@ -544,9 +544,9 @@ void generic_sync_sb_inodes(struct super
 			wbc->more_io = 1;
 			break;
 		}
-		if (!list_empty(&sb->s_more_io))
-			wbc->more_io = 1;
 	}
+	if (!list_empty(&sb->s_more_io) && list_empty(&sb->s_io))
+			wbc->more_io = 1;
 
 	if (sync) {
 		struct inode *inode, *old_inode = NULL;
