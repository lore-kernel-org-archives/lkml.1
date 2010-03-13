Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab0CMO4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 09:56:44 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41159 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759244Ab0CMO4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 09:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=uuBNV+p2R7ADivn4MmuVxsaXBTLrQgCaSHx0KfmlJotyiNP/LKNezOszHPCNNlLpIw
         fBsi7RK259ESFENxMDkixFLa4mU7W1LPgEpuJLIub83paKkMb9WxGqN8/vs42ftj+00M
         DqVL8LJvyij4cL5h6xfb8Ds0oAUZUhMidGrRs=
Date: Sat, 13 Mar 2010 17:56:21 +0300
From: Dan Carpenter <error27@gmail.com>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [patch] memcontrol: fix potential null deref
Message-ID: <20100313145621.GA3569@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	kamezawa.hiroyu@jp.fujitsu.com,
	Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Balbir Singh <balbir@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a potential null deref introduced in:
c62b1a3b31b5 memcg: use generic percpu instead of private implementation

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7973b52..e1e0996 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3691,8 +3691,10 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	else
 		mem = vmalloc(size);
 
-	if (mem)
-		memset(mem, 0, size);
+	if (!mem)
+		return NULL;
+
+	memset(mem, 0, size);
 	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
 	if (!mem->stat) {
 		if (size < PAGE_SIZE)
