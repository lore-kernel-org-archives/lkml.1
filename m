Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbYAKOtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbYAKOtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbYAKOtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:49:32 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3341 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758741AbYAKOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:49:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=a2k8byY5TPwNHIeHMRRy8zn3mshcPeuQzzEC4RKq0+Yf/b8XAEhyi0FNCoGzXU61n
	jmwmE8/kBd0zd36YtO2Cw==
Message-ID: <d9885f0f0801110649x4bdbc082he6b6bffd9d748a6f@mail.gmail.com>
Date: Fri, 11 Jan 2008 09:49:28 -0500
From: "Abhishek Rai" <abhishekrai@google.com>
To: 7eggert@gmx.de
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org,
       Jesse <jesse.barnes@intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, "Suresh B" <suresh.b.siddha@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <E1JDKcK-0003cu-Ps@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9q1CT-82L-3@gated-at.bofh.it> <9q3v2-2Br-3@gated-at.bofh.it>
	 <9qgLE-7ds-21@gated-at.bofh.it> <9qjJx-3wE-9@gated-at.bofh.it>
	 <9qm4D-70Q-1@gated-at.bofh.it> <9CQTt-7cr-27@gated-at.bofh.it>
	 <9KcYS-46E-27@gated-at.bofh.it>
	 <E1JDKcK-0003cu-Ps@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That will surely help sequential read performance for large
unfragmented files and we have considered it before. There are two
main reasons why we want the data blocks and the corresponding
indirect blocks to share the same block group.

1. When a block group runs out of a certain types of blocks (data
blocks or indirect blocks), we use blocks of the other type for
allocation. Consequently, if data blocks and their corresponding
indirect blocks are sharing the same block group, we'll run out of
data blocks in the block group exactly at the same time as we run out
of indirect blocks, so we know we have well utilized the block group
and can move on to the next block group. This keeps things simple and
results in low fragmentation. However, if data blocks and their
indirect blocks were to go into two different block groups, it is
possible that you run out of one kind of blocks in one block group
while you still have the other kind available in the other block group
since these two are independent now. So now we need to decide which
kind of allocation to move over to which block group. This requires
slightly more advanced heuristics and I didn't want to add this
complexity for the small gain it offers.

2. I think sharing a block group the way it's done currently is a
cleaner design since allocation is quite self-contained within a block
group. I'd argue in the long run it's good to stick to a cleaner
design even if it is 1-2% worse in performance in some cases. Among
other things, cleaner designs are easier to change and enhance in the
future. More importantly, in this case our goal is to speed up fsck
without slowing down IO and we are comfortably achieving that goal.

Thanks,
Abhishek

On Jan 11, 2008 9:12 AM, Bodo Eggert <7eggert@gmx.de> wrote:
> Abhishek Rai <abhishekrai@google.com> wrote:
>
> > Putting metacluster at the end of the block group gives slightly
> > inferior sequential read throughput compared to putting it in the
> > beginning or the middle, but the difference is very tiny and exists
> > only for large files that span multiple block groups.
>
> Just an idea:
>
> What about putting it into the end of the previous block group (except for
> the first group, off cause) and starting to read the block group a little
> earlier (readahead/~before)? I imagine it might be about as good as placing
> it at the beginning while avoiding the fragmentation.
>
>
