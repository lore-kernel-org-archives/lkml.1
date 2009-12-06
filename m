Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZLGAec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZLGAec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758415AbZLGAea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:34:30 -0500
Received: from kroah.org ([198.145.64.141]:34228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758316AbZLGAMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:41 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:43 2009
Message-Id: <20091207000643.761211232@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Soeren Sandmann Pedersen <sandmann@redhat.com>, a.p.zijlstra@chello.nl,
       Ingo Molnar <mingo@elte.hu>
Subject: [021/119] highmem: Fix race in debug_kmap_atomic() which could cause warn_count to underflow
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=highmem-fix-race-in-debug_kmap_atomic-which-could-cause-warn_count-to-underflow.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Soeren Sandmann <sandmann@daimi.au.dk>

commit 5ebd4c22897dce65845807a9bd3a31cc4e142b53 upstream.

debug_kmap_atomic() tries to prevent ever printing more than 10
warnings, but it does so by testing whether an unsigned integer
is equal to 0. However, if the warning is caused by a nested
IRQ, then this counter may underflow and the stream of warnings
will never end.

Fix that by using a signed integer instead.

Signed-off-by: Soeren Sandmann Pedersen <sandmann@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <ye8zl7b8ktj.fsf@camel23.daimi.au.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/highmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -426,9 +426,9 @@ void __init page_address_init(void)
 
 void debug_kmap_atomic(enum km_type type)
 {
-	static unsigned warn_count = 10;
+	static int warn_count = 10;
 
-	if (unlikely(warn_count == 0))
+	if (unlikely(warn_count < 0))
 		return;
 
 	if (unlikely(in_interrupt())) {


