Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYFXV71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYFXV71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbYFXV5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:57:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:16596 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbYFXV5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:57:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=dVmlpwZVtOTCEVNqQETuvE95Aacde/WGFstP46/2PiXHOJB44mqE6VLAHTLOxiit0L
         EphCCGqETIQlXWHqxkGi10UbTOaUP08ux5YC+kfzfUjkPw2cf6GcWQhSUZ3wvEahX5I1
         scEeCSAVOzhFGtssN8zumRWitr3c6I8ooDDzA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix e820_update_range size when overlapping
Date: Tue, 24 Jun 2008 14:55:32 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241455.33199.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


before that we relay on sanitize_e820_map to remove the overlap.

but e820_update_range(,,E820_RESERVED, E820_RAM) will not work

this patch fix that

who is going to use this?

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 512f779..15b4393 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -425,6 +425,11 @@ u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
 		e820_add_region(final_start, final_end - final_start,
 					 new_type);
 		real_updated_size += final_end - final_start;
+
+		ei->size -= final_end - final_start;
+		if (ei->addr < final_start)
+			continue;
+		ei->addr = final_end;
 	}
 	return real_updated_size;
 }
