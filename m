Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab0BKXGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:06:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:36682 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab0BKXGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:06:31 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       fengguang.wu@intel.com
Subject: [RFC] [PATCH 0/3] Writeback livelock avoidance using page tags (v2)
Date: Fri, 12 Feb 2010 00:06:21 +0100
Message-Id: <1265929584-5080-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  the following two patches (the third one is just a debugging aid, not to be
merged) implement avoidance of livelock of write_cache_pages.  The idea is
simple: We tag patches that should be written in the beginning of
write_cache_pages and then write only tagged pages (see the patch for details).
Since last version, I've made tagging function faster as Andrew suggested and
also gave the patch more testing.
  The thing I've aimed at with this patch is a simplification of current
writeback code. Basically, with this patch I think we can just rip out all the
range_cyclic and nr_to_write (or other "fairness logic"). The rationalle is
following:
  What we want to achieve with fairness logic is that when a page is
dirtied, it gets written to disk within some reasonable time (like 30s or
so). We track dirty time on per-inode basis only because keeping it
per-page is simply too expensive. So in this setting fairness between
inodes really does not make any sence - why should be a page in a file
penalized and written later only because there are lots of other dirty
pages in the file? It is enough to make sure that we don't write one file
indefinitely when there are new dirty pages continuously created - and my
patch achieves that.
  Comments and suggestions for improvement are welcome!

								Honza
