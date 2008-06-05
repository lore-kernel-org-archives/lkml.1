Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYFEJ7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYFEJ7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbYFEJ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:56:33 -0400
Received: from mail.suse.de ([195.135.220.2]:39376 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328AbYFEJ4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:56:30 -0400
Message-Id: <20080605094300.295184000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Thu, 05 Jun 2008 19:43:00 +1000
From: npiggin@suse.de
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org
Subject: [patch 0/7] speculative page references, lockless pagecache, lockless gup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've decided to submit the speculative page references patch to get merged.
I think I've now got enough reasons to get it merged. Well... I always
thought I did, I just didn't think anyone else thought I did. If you know
what I mean.

cc'ing the powerpc guys specifically because everyone else who probably
cares should be on linux-mm...

So speculative page references are required to support lockless pagecache and
lockless get_user_pages (on architectures that can't use the x86 trick). Other
uses for speculative page references could also pop up, it is a pretty useful
concept. Doesn't need to be pagecache pages either.

Anyway,

lockless pagecache:
- speeds up single threaded pagecache lookup operations significantly, by
  avoiding atomic operations, memory barriers, and interrupts-off sections.
  I just measured again on a few CPUs I have lying around here, and the
  speedup is over 2x reduction in cycles on them all, closer to 3x in some
  cases.

   find_get_page takes:
                ppc970 (g5)     K10             P4 Nocona       Core2
    vanilla     275 (cycles)    85              315             143
    lockless    125             40              127             61

- speeds up single threaded pagecache modification operations, by using
  regular spinlocks rather than rwlocks and avoiding an atomic operation
  on x86 for one. Also, most real paths which involve pagecache modification
  also involve pagecache lookups, so it is hard not to get a net speedup.

- solves the rwlock starvation problem for pagecache operations. This is
  being noticed on big SGI systems, but theoretically could happen on
  relatively small systems (dozens of CPUs) due to the really nasty
  writer starvation problem of rwlocks -- not even hardware fairness can
  solve that.

- improves pagecache scalability to operations on a single file. I
  demonstrated page faults to a single file were improved in throughput
  by 250x on a 64-way Altix several years ago. We now have systems with
  thousands of CPUs in them.

lockless get_user_pages:
- provides a way to operate on user pages which is scalable to many threads,
  and does not get impacted by, or contribute to, mmap_sem contention.

- Alrady shown to speed up DB2 running OLTP by a significant amount.

The speculative page references idea has been out there for quite a few
years now, and never been disproved.

So, that's the jist of my justification. If it were up to me, then I would
have merged the thing solely on the very first point under lockless
pagecache, but...

Review/comments/testing appreciated. I wonder how people feel about merging
this soon?

(the actual patchset must go on top of the fast get_user_pages patches I
posted earlier because I'm adding the powerpc variant of that here)

-- 

