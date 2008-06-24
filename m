Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYFXOe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYFXOe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbYFXOet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:34:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:40813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbYFXOes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:34:48 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 1/3] e820_update_range(): Strip size of original region
Date: Tue, 24 Jun 2008 16:35:23 +0200
Message-Id: <1214318125-32619-2-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1214318125-32619-1-git-send-email-bwalle@suse.de>
References: <1214318125-32619-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in e820_update_range(): Previously, if a region was
partially covered, then e820_update_range() only added a new E820 range but
didn't update the end/size of the previous range. That lead to duplicate
covering of a region.

Patch tested on i386 and x86-64 with patch that uses e820_update_range()
to limit the E820 map when "mem" parameter is specified on the command line.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/e820.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index e285ea3..e466073 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -422,6 +422,7 @@ u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
 		final_end = min(start + size, ei->addr + ei->size);
 		if (final_start >= final_end)
 			continue;
+		ei->size -= final_end - final_start;
 		e820_add_region(final_start, final_end - final_start,
 					 new_type);
 		real_updated_size += final_end - final_start;
-- 
1.5.4.5

