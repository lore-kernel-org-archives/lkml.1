Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0CBCuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 21:50:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:49888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab0CBCuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 21:50:11 -0500
Message-ID: <4B8C7C94.7070000@kernel.org>
Date: Mon, 01 Mar 2010 18:48:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] early_res: need to save name aside with free_early_partial
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	 <1265793639-15071-17-git-send-email-yinghai@kernel.org>	 <20100215010833.15f9e09a.sfr@canb.auug.org.au>	 <4B7B4378.1070206@kernel.org> <1267052387.12790.10.camel@laptop> <4B85B65E.503@kernel.org> <4B85B724.9050304@kernel.org> <4B85DB79.4010708@kernel.org> <4B85E245.5030001@kernel.org>
In-Reply-To: <4B85E245.5030001@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


noticed some early_res got blank name.

it turns out reserve_early_without_check could update allocate new early_res
and copy old early_res already. so can not take early_res as parameter.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/early_res.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/early_res.c
===================================================================
--- linux-2.6.orig/kernel/early_res.c
+++ linux-2.6/kernel/early_res.c
@@ -79,9 +79,16 @@ static void __init drop_range_partial(in
 		/* make head segment */
 		early_res[i].end = common_start;
 		if (old_end > common_end) {
+			char name[15];
+
+			/*
+			 * Save name aside, in reserve_early_ have allocated
+			 * and new early_res array because auto double
+			 */
+			strncpy(name, early_res[i].name,
+					 sizeof(early_res[i].name) - 1);
 			/* add another for left over on tail */
-			reserve_early_without_check(common_end, old_end,
-					 early_res[i].name);
+			reserve_early_without_check(common_end, old_end, name);
 		}
 		return;
 	} else {
