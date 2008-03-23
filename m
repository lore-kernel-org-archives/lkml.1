Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYCWAiC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYCWAiC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 20:38:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYCWAhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 20:37:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516AbYCWAhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 20:37:54 -0400
Date: Sat, 22 Mar 2008 17:36:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       stable@kernel.org
Subject: Re: 2.6.24.3 bug in sysfs with md.
Message-Id: <20080322173651.61bff26d.akpm@linux-foundation.org>
In-Reply-To: <20080322222531.GA12182@animx.eu.org>
References: <20080322222531.GA12182@animx.eu.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 18:25:31 -0400 Wakko Warner <wakko@animx.eu.org> wrote:

> I was poking around with the files laying in /sys/block/md*/md/dev-*/super
> and found this bug (NOTE: I attempted to read the file 2 times):
> 
> [ 5591.212764] ------------[ cut here ]------------
> [ 5591.212773] kernel BUG at /usr/src/linux/dist/2.6.24.3/fs/sysfs/file.c:126!

hm, I didn't know 2.6.24 was affected.

Neil, should we backport this?


From: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: git-commits-head@vger.kernel.org
Subject: md: remove the 'super' sysfs attribute from devices in an 'md' array
Date: 	Thu, 20 Mar 2008 02:59:10 GMT
Sender: git-commits-head-owner@vger.kernel.org

Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e82989d95cc46cc58622381eafa54f7428ee679
Commit:     0e82989d95cc46cc58622381eafa54f7428ee679
Parent:     43d8eac44f28d384d2377dcdd1407f51f79dda55
Author:     NeilBrown <neilb@suse.de>
AuthorDate: Wed Mar 19 17:00:44 2008 -0700
Committer:  Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Wed Mar 19 18:53:35 2008 -0700

    md: remove the 'super' sysfs attribute from devices in an 'md' array
    
    Exposing the binary blob which is the md 'super-block' via sysfs doesn't
    really fit with the whole sysfs model, and ever since commit
    8118a859dc7abd873193986c77a8d9bdb877adc8 ("sysfs: fix off-by-one error
    in fill_read_buffer()") it doesn't actually work at all (as the size of
    the blob is often one page).
    
    (akpm: as in, fs/sysfs/file.c:fill_read_buffer() goes BUG)
    
    So just remove it altogether.  It isn't really useful.
    
    Signed-off-by: Neil Brown <neilb@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/md/md.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ccbbf63..61ccbd2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1864,17 +1864,6 @@ static struct rdev_sysfs_entry rdev_state =
 __ATTR(state, S_IRUGO|S_IWUSR, state_show, state_store);
 
 static ssize_t
-super_show(mdk_rdev_t *rdev, char *page)
-{
-	if (rdev->sb_loaded && rdev->sb_size) {
-		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
-		return rdev->sb_size;
-	} else
-		return 0;
-}
-static struct rdev_sysfs_entry rdev_super = __ATTR_RO(super);
-
-static ssize_t
 errors_show(mdk_rdev_t *rdev, char *page)
 {
 	return sprintf(page, "%d\n", atomic_read(&rdev->corrected_errors));
@@ -2060,7 +2049,6 @@ __ATTR(size, S_IRUGO|S_IWUSR, rdev_size_show, rdev_size_store);
 
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
-	&rdev_super.attr,
 	&rdev_errors.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,
--
To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
