Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYGGR2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYGGR2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYGGR2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:28:15 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:15211 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYGGR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:28:14 -0400
Subject: Re: [PATCH] Make CONFIG_MIGRATION available for s390
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <4872319B.9040809@linux-foundation.org>
References: <1215354957.9842.19.camel@localhost.localdomain>
	 <4872319B.9040809@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 19:28:09 +0200
Message-Id: <1215451689.8431.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 10:09 -0500, Christoph Lameter wrote:
> This will extend the number of pages that are migratable and lead to strange
> semantics in the NUMA case. There suddenly vma_is migratable will forbid hotplug
> to migrate certain pages. 
> 
> I think we need two functions:
> 
> vma_migratable()	General migratability
> 
> vma_policy_migratable()	Migratable under NUMA policies.

Nothing will change here for the NUMA case, this is all about making it
compile w/o NUMA and with MIGRATION. What new strange semantics do you mean?
BTW, the latest patch in this thread will not touch vma_migratable() anymore,
I haven't read your mail before, sorry.

> That wont work since the migrate function takes a nodemask! The point of
> the function is to move memory from node to node which is something that you
> *cannot* do in a non NUMA configuration. So leave this chunk out.

Right, but I noticed that this function definition was needed to make it
compile with MIGRATION and w/o NUMA, although it would never be called in
non-NUMA config.
A better solution would probably be to put migrate_vmas(), the only caller
of vm_ops->migrate(), inside '#ifdef CONFIG_NUMA', because it will only be
called from NUMA-only mm/mempolicy.c. Does that sound reasonable?

> Hmmm... Okay. I tried to make MIGRATION as independent of CONFIG_NUMA as possible so hopefully this will work.

Umm, it doesn't compile with MIGRATION and w/o NUMA, which was the reason
for this patch, because of the policy_zone reference in vma_migratable()
and the missing vm_ops->migrate() function.

Thanks,
Gerald

