Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZGLIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZGLIEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZGLIEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:04:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:63807 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZGLIES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:04:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,386,1243839600"; 
   d="scan'208";a="164076862"
Date: Sun, 12 Jul 2009 16:04:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Fernando Silveira <fsilveira@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: I/O and pdflush
Message-ID: <20090712080410.GA8512@localhost>
References: <6afc6d4a0907111027w76234c8fv11ab77864515fdb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6afc6d4a0907111027w76234c8fv11ab77864515fdb0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 02:27:25PM -0300, Fernando Silveira wrote:
> Hi.
> 
> I'm having a hard time with an application that writes sequentially
> 250GB of non-stop data directly to a solid state disk (OCZ SSD CORE
> v2) device and I hope you can help me. The command "dd if=/dev/zero
> of=/dev/sdc bs=4M" reproduces the same symptoms I'm having and writes
> exactly as that application does.
> 
> The problem is that after some time of data writing at 70MB/s, it
> eventually falls down to about 25MB/s and does not get up again until
> a loooong time has passed (from 1 to 30 minutes). This happens much
> more often when "vm.dirty_*" settings are default (30 secs to expire,
> 5 secs for writeback, 10% and 40% for background and normal ratio),
> and when I set them to 1 second or even 0, the problem happens much
> less often and the sticking period of 25MB/s is much lower.
> 
> In one of my experiences, I could see that writing some blocks of of
> data (aprox. 48 blocks of 4MB each time) at a random position of the
> "disk" increases the chances of decreasing the writing rate to 25MB/s.
> You can see at this graph[1] that after the 7th random big write (at
> 66 GB) it falls down to 25MB/s. The writes happened at the following
> positions (in GB): 10, 20, 30, 39, 48, 57, 66, 73, 80, 90, 100, 109,
> 118, 128, 137, 147, and 156 GB.
> 
> As I don't know much about kernel internals, IMHO it might be the SSD
> might be "hiccuping" and some kind of kernel I/O scheduler or pdflush
> decreases its rate to avoid write errors, I don't know.
> 
> Could somebody tell me how could I debug the kernel and any of its
> modules to understand exactly why the writing is behaving this way?
> Maybe I could do it just by logging write errors or something, I don't
> know. Telling me which part I should start analyzing would be a huge
> hint, seriously.
> 
> Thanks.
> 
> 1. http://rootshell.be/~swrh/ssd-tests/ssd-no_dirty_buffer_with_random_192mb_writes.png
> 
> PS: This is used with two A/D converters which provide 25MB/s of data
> each, leading my writing software to need at least 50MB/s of
> sequential writing rate.

Hi Fernando,

What's your kernel version?  Can the following patch help?

Thanks,
Fengguang

---
 fs/fs-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mm.orig/fs/fs-writeback.c
+++ mm/fs/fs-writeback.c
@@ -325,7 +325,8 @@ __sync_single_inode(struct inode *inode,
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				if (wbc->nr_to_write <= 0) {
+				if (wbc->nr_to_write <= 0 ||
+				    wbc->encountered_congestion) {
 					/*
 					 * slice used up: queue for next turn
 					 */
