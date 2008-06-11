Return-Path: <linux-kernel-owner+w=401wt.eu-S1764658AbYFKRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764658AbYFKRLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 13:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYFKRLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 13:11:00 -0400
Received: from as1.cineca.com ([130.186.84.213]:48274 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbYFKRLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:11:00 -0400
Message-ID: <4850070F.6060305@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain> <20080521152948.15001.39361.sendpatchset@localhost.localdomain>
In-Reply-To: <20080521152948.15001.39361.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jun 2008 19:10:40 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> +static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
> +{
> +	*tmp = memparse(buf, &buf);
> +	if (*buf != '\0')
> +		return -EINVAL;
> +
> +	*tmp = PAGE_ALIGN(*tmp);
> +	return 0;
> +}

We shouldn't use PAGE_ALIGN() here, otherwise we limit the address space
to 4GB on 32-bit architectures (that could be reasonable, because this
is a per-cgroup limit and not per-process).

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 mm/memrlimitcgroup.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/memrlimitcgroup.c b/mm/memrlimitcgroup.c
index 9a03d7d..2d42ff3 100644
--- a/mm/memrlimitcgroup.c
+++ b/mm/memrlimitcgroup.c
@@ -29,6 +29,8 @@
 #include <linux/res_counter.h>
 #include <linux/memrlimitcgroup.h>
 
+#define PAGE_ALIGN64(addr) (((((addr)+PAGE_SIZE-1))>>PAGE_SHIFT)<<PAGE_SHIFT)
+
 struct cgroup_subsys memrlimit_cgroup_subsys;
 
 struct memrlimit_cgroup {
@@ -124,7 +126,7 @@ static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
 	if (*buf != '\0')
 		return -EINVAL;
 
-	*tmp = PAGE_ALIGN(*tmp);
+	*tmp = PAGE_ALIGN64(*tmp);
 	return 0;
 }
 
