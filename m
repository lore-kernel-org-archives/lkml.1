Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYANJzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYANJzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYANJz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:55:27 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41822 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752097AbYANJz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:55:26 -0500
Message-ID: <400304530.01514@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 14 Jan 2008 17:55:18 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Joerg Platte <jplatte@naasa.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801130905.44855.jplatte@naasa.net> <400212488.11031@ustc.edu.cn> <200801131049.33111.jplatte@naasa.net> <20080113115933.GA11045@mail.ustc.edu.cn> <20080114035439.GA7330@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114035439.GA7330@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JEM2I-00010S-5U@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 11:54:39AM +0800, Fengguang Wu wrote:
> > particular this bug is triggered because the dir mapping page has
> > PAGECACHE_TAG_DIRTY set and PG_dirty cleared, staying in an
> > inconsistent state.
> 
> Just found that a deleted dir will enter that inconsistent state when
> someone still have reference to it...

Joerg, this patch fixed the bug for me :-)

Fengguang
---

clear PAGECACHE_TAG_DIRTY for truncated page in block_write_full_page()

The `truncated' page in block_write_full_page() may stick for a long time.
E.g. ext2_rmdir() will set i_size to 0. The dir may still be referenced by
someone, and have dirty pages in it.

So clear PAGECACHE_TAG_DIRTY to prevent pdflush from retrying and iowaiting on
it.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
fs/buffer.c |    2 ++
 1 files changed, 2 insertions(+)

Index: linux/fs/buffer.c
===================================================================
--- linux.orig/fs/buffer.c
+++ linux/fs/buffer.c
@@ -2820,7 +2820,9 @@ int block_write_full_page(struct page *p
 		 * freeable here, so the page does not leak.
 		 */
 		do_invalidatepage(page, 0);
+		set_page_writeback(page);
 		unlock_page(page);
+		end_page_writeback(page);
 		return 0; /* don't care */
 	}
 

