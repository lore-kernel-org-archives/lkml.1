Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYKML2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYKML2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYKML2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:28:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46139 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYKML2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:28:37 -0500
Date: Thu, 13 Nov 2008 20:27:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [BUGFIX][PATCH] memory hotplug: fix notiier chain return value (Was
 Re: 2.6.28-rc4 mem_cgroup_charge_common panic)
Message-Id: <20081113202758.2f12915a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1226353408.8805.12.camel@badari-desktop>
References: <1226353408.8805.12.camel@badari-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Badari, I think you used SLUB. If so, page_cgroup's notifier callback was not
called and newly allocated page's page_cgroup wasn't allocated.
This is a fix. (notifier saw STOP_HERE flag added by slub's notifier.)

I'm now testing modified kernel, which does alloc/free page_cgroup by notifier.
(Usually, all page_cgroups are from bootmem and not freed.
 so, modified a bit for test)

And I cannot reproduce panic. I think you do "real" memory hotplug other than
online/offline and saw panic caused by this. 

Is this slub's behavior intentional ? page_cgroup's notifier has lower priority
than slub, now.

Thanks,
-Kame
==
notifier callback's notifier_from_errno() just works well in error
route. (It adds mask for "stop here")

Hanlder should return NOTIFY_OK in explict way.

Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_cgroup.c |    5 ++++-
 mm/slub.c        |    6 ++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

Index: mmotm-2.6.28-Nov10/mm/slub.c
===================================================================
--- mmotm-2.6.28-Nov10.orig/mm/slub.c
+++ mmotm-2.6.28-Nov10/mm/slub.c
@@ -3220,8 +3220,10 @@ static int slab_memory_callback(struct n
 	case MEM_CANCEL_OFFLINE:
 		break;
 	}
-
-	ret = notifier_from_errno(ret);
+	if (ret)
+		ret = notifier_from_errno(ret);
+	else
+		ret = NOTIFY_OK;
 	return ret;
 }
 
Index: mmotm-2.6.28-Nov10/mm/page_cgroup.c
===================================================================
--- mmotm-2.6.28-Nov10.orig/mm/page_cgroup.c
+++ mmotm-2.6.28-Nov10/mm/page_cgroup.c
@@ -216,7 +216,10 @@ static int page_cgroup_callback(struct n
 		break;
 	}
 
-	ret = notifier_from_errno(ret);
+	if (ret)
+		ret = notifier_from_errno(ret);
+	else
+		ret = NOTIFY_OK;
 
 	return ret;
 }


