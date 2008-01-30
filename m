Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYA3Aub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYA3Aub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYA3AuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:50:19 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:46901 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYA3AuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:50:11 -0500
To: linux-kernel@vger.kernel.org
Subject: Re: task blocked in sync_buffer from ext3_free_branches
X-Message-Flag: Warning: May contain useful information
References: <aday7a8cg24.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 29 Jan 2008 16:49:54 -0800
In-Reply-To: <aday7a8cg24.fsf@cisco.com> (Roland Dreier's message of "Tue, 29 Jan 2008 16:28:35 -0800")
Message-ID: <adatzkwcf2l.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2008 00:49:54.0421 (UTC) FILETIME=[0741E250:01C862DA]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually this appears to be the bug that Jens fixed with this patch,
and with that patch my system seems fine as well:

diff --git a/block/as-iosched.c b/block/as-iosched.c
index b201d16..9603684 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1275,9 +1275,13 @@ static void as_merged_requests(struct request_queue *q, struct request *req,
 			 * Don't copy here but swap, because when anext is
 			 * removed below, it must contain the unused context
 			 */
-			double_spin_lock(&rioc->lock, &nioc->lock, rioc < nioc);
-			swap_io_context(&rioc, &nioc);
-			double_spin_unlock(&rioc->lock, &nioc->lock, rioc < nioc);
+			if (rioc != nioc) {
+				double_spin_lock(&rioc->lock, &nioc->lock,
+								rioc < nioc);
+				swap_io_context(&rioc, &nioc);
+				double_spin_unlock(&rioc->lock, &nioc->lock,
+								rioc < nioc);
+			}
 		}
 	}
 

