Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZKKWiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZKKWiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbZKKWiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:38:12 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37712 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531AbZKKWiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:38:10 -0500
Date: Wed, 11 Nov 2009 14:38:49 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: mtk.manpages@googlemail.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, matthltc@suka.localdomain,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       linux-api@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v12][PATCH 1/9] Factor out code to allocate pidmap page
Message-ID: <20091111223849.GB24988@suka>
References: <20091111043440.GA9377@suka> <20091111044250.GA11393@suka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111044250.GA11393@suka>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc LKML

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| 
| Subject: [v12][PATCH 1/9] Factor out code to allocate pidmap page
| 
| To simplify alloc_pidmap(), move code to allocate a pid map page to a
| separate function.
| 
| Changelog[v3]:
| 	- Earlier version of patchset called alloc_pidmap_page() from two
| 	  places. But now its called from only one place. Even so, moving
| 	  this code out into a separate function simplifies alloc_pidmap().
| Changelog[v2]:
| 	- (Matt Helsley, Dave Hansen) Have alloc_pidmap_page() return
| 	  -ENOMEM on error instead of -1.
| 
| Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| Acked-by: Serge Hallyn <serue@us.ibm.com>
| Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
| ---
|  kernel/pid.c |   45 ++++++++++++++++++++++++++++++---------------
|  1 files changed, 30 insertions(+), 15 deletions(-)
| 
| diff --git a/kernel/pid.c b/kernel/pid.c
| index d3f722d..7d4bb6e 100644
| --- a/kernel/pid.c
| +++ b/kernel/pid.c
| @@ -122,9 +122,35 @@ static void free_pidmap(struct upid *upid)
|  	atomic_inc(&map->nr_free);
|  }
| 
| +static int alloc_pidmap_page(struct pidmap *map)
| +{
| +	void *page;
| +
| +	if (likely(map->page))
| +		return 0;
| +
| +	page = kzalloc(PAGE_SIZE, GFP_KERNEL);
| +
| +	/*
| +	 * Free the page if someone raced with us installing it:
| +	 */
| +	spin_lock_irq(&pidmap_lock);
| +	if (map->page)
| +		kfree(page);
| +	else
| +		map->page = page;
| +	spin_unlock_irq(&pidmap_lock);
| +
| +	if (unlikely(!map->page))
| +		return -ENOMEM;
| +
| +	return 0;
| +}
| +
|  static int alloc_pidmap(struct pid_namespace *pid_ns)
|  {
|  	int i, offset, max_scan, pid, last = pid_ns->last_pid;
| +	int rc;
|  	struct pidmap *map;
| 
|  	pid = last + 1;
| @@ -134,21 +160,10 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
|  	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
|  	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
|  	for (i = 0; i <= max_scan; ++i) {
| -		if (unlikely(!map->page)) {
| -			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
| -			/*
| -			 * Free the page if someone raced with us
| -			 * installing it:
| -			 */
| -			spin_lock_irq(&pidmap_lock);
| -			if (map->page)
| -				kfree(page);
| -			else
| -				map->page = page;
| -			spin_unlock_irq(&pidmap_lock);
| -			if (unlikely(!map->page))
| -				break;
| -		}
| +		rc = alloc_pidmap_page(map);
| +		if (rc)
| +			break;
| +
|  		if (likely(atomic_read(&map->nr_free))) {
|  			do {
|  				if (!test_and_set_bit(offset, map->page)) {
| -- 
| 1.6.0.4
| 
| _______________________________________________
| Containers mailing list
| Containers@lists.linux-foundation.org
| https://lists.linux-foundation.org/mailman/listinfo/containers
