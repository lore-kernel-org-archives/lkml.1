Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbYALGFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbYALGFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 01:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYALGF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 01:05:27 -0500
Received: from phunq.net ([64.81.85.152]:59797 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750891AbYALGF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 01:05:26 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Date: Fri, 11 Jan 2008 22:05:10 -0800
User-Agent: KMail/1.9.5
Cc: abhishekrai@google.com, tytso@mit.edu, adilger@sun.com,
       linux-kernel@vger.kernel.org, kenchen@google.com, mikew@google.com,
       rohitseth@google.com
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com> <200801110905.18464.phillips@phunq.net> <20080111160431.905a853f.akpm@linux-foundation.org>
In-Reply-To: <20080111160431.905a853f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801112205.11733.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008 16:04, Andrew Morton wrote:
> It needs to be reviewed.  In exhaustive detail.  Few people can do
> that and fewer are inclined to do so.

Agreed, there just have to be a few bugs in this many lines of code.
I spent a couple of hours going through it, not really looking at the 
algorithms but just the superficial details.  I only found minor nits, 
and not many of those.

For example, I do not like to see "if (free_blocks == 0)" written as"if 
(free_blocks <= 0)" in an attempt to increase robustness.  What it 
actually does is make the effect of an error more subtle, or 
even "corrects" it.  Firmly in the niggle category.

I checked the locking of sbi->bginfo and didn't see a flaw, good.

I see a missing KERN_INFO added to a printk, it technically counts as an 
unrelated change but oh well.

Stylistically this new code is hard to tell apart from the incumbent 
code, except for being more heavily commented.  I wish all kernel code 
was written this clearly.

At this point I will run away in favor of for-real Ext3 hackers (you 
know who you are:-)

> I went to merge it so it could get some testing while we await review
> but the patch has all its tabs replaced with spaces, is seriously
> wordwrapped and has random newlines added to it.  Please fix email
> client and resend (offlist is OK if it is unaltered).

Odd, the original post has tabs and the updated one does not, though the 
client seems to be kmail in both cases.

> We should have a think about which workloads are most likely to be
> adversely affected by this change.

I was just rolling up my sleeves to construct the nasty sequential case 
where the head keeps seeking back to the center of the group after 
picking up each 4 MB of doubly indexed data when I realized that even 
the most simple minded disk cache makes this case a non-issue.  The 
drive will most likely suck a full track (roughly .5 MB) or big chunk 
thereof into cache the first time it seeks to the index cluster, thus 
having a whole group of double index blocks in cache and then will 
proceed to chew happily and linearly through the data blocks.
It seems like placing those second level index blocks all together 
really helps this case.  Hmm, how to break it.

How about having a disk full of 100 MB files and skipping all over the 
disk randomly reading one block each time.  That will fill the disk 
cache, and each random read then requires seeking to two places that 
were hopefully close together without index node clustering, and now 
will be an average of 32 MB apart.  Each of these "extra" seeks costs a 
couple of ms worth of head travel plus average rotational latency of 4 
ms or so, for a total 6 ms.  However, even with a perfect non-clustered 
layout, the index mode will still be an average of 2 MB away from the 
data block, so the rotational latency is still incurred and only the 
head travel is a little less, say 1 ms less.  So the "extra" seek time 
for clustered is 6 ms vs 5 ms for non-clustered.  Add in 8 ms for the 
long random seek and we have 14 ms vs 13 ms, or about 8% difference. 
Only a small regression there, and I tried hard.  Barring mistakes in 
my estimates the sequential improvement above is large while the 
regression for the nasty random construction is small.

Maybe somebody else will have better luck breaking it.

Regards,

Daniel
