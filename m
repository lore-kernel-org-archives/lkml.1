Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbYETGa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbYETGa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYETGaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:30:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44669 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYETGap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:30:45 -0400
Date: Tue, 20 May 2008 15:35:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, ebiederm@xmission.com,
       hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com,
       rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp
Subject: Re: + memcg-remove-refcnt-from-page_cgroup.patch added to -mm tree
Message-Id: <20080520153525.5b21b89c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200805160253.m4G2rH4I023232@imap1.linux-foundation.org>
References: <200805160253.m4G2rH4I023232@imap1.linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, I found a bug in this patch. (A fix is attached below.)

On Thu, 15 May 2008 19:53:17 -0700
akpm@linux-foundation.org wrote:

> +/* remove redundant charge if migration failed*/
>  void mem_cgroup_end_migration(struct page *newpage)
>  {
> -	mem_cgroup_uncharge_page(newpage);
> +	/* At success, page->mapping is not NULL */
> +	if (newpage->mapping)
> +		__mem_cgroup_uncharge_common(newpage,
> +					 MEM_CGROUP_CHARGE_TYPE_FORCE);
>  }
>  

Should be if (!newpage->mapping). Maybe a typo in restructuring...

Sorry.
-Kame
==
This rollback should be done at failure.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mm-2.6.26-rc2-mm1/mm/memcontrol.c
===================================================================
--- mm-2.6.26-rc2-mm1.orig/mm/memcontrol.c
+++ mm-2.6.26-rc2-mm1/mm/memcontrol.c
@@ -760,8 +760,8 @@ int mem_cgroup_prepare_migration(struct 
 /* remove redundant charge if migration failed*/
 void mem_cgroup_end_migration(struct page *newpage)
 {
-	/* At success, page->mapping is not NULL */
-	if (newpage->mapping)
+	/* At success, page->mapping is not NULL and nothing to do. */
+	if (!newpage->mapping)
 		__mem_cgroup_uncharge_common(newpage,
 					 MEM_CGROUP_CHARGE_TYPE_FORCE);
 }

