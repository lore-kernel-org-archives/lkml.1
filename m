Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbYCQCEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbYCQCEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbYCQCCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 22:02:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809AbYCQCCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 22:02:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ULM7F8vCjZ7oc9nuONAi0swjHZjgO5P4KKomLgNvaQc0fuMZvfzTaT4+0CCfYFnTR
	yscqlS/U8BoKEh3BWinTg==
Message-ID: <6599ad830803161902r8f9a274t246a25b3d337fee8@mail.gmail.com>
Date: Mon, 17 Mar 2008 10:02:09 +0800
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
	 <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 1:30 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>   /*
>  + * Check if the current cgroup exceeds its address space limit.
>  + * Returns 0 on success and 1 on failure.
>  + */
>  +int mem_cgroup_update_as(struct mm_struct *mm, long nr_pages)
>  +{
>  +       int ret = 0;
>  +       struct mem_cgroup *mem;
>  +       if (mem_cgroup_subsys.disabled)
>  +               return ret;
>  +
>  +       rcu_read_lock();
>  +       mem = rcu_dereference(mm->mem_cgroup);
>  +       css_get(&mem->css);
>  +       rcu_read_unlock();
>  +

How about if this function avoided charging the root cgroup? You'd
save 4 atomic operations on a global data structure on every
mmap/munmap when the virtual address limit cgroup wasn't in use, which
could be significant on a large system. And I don't see situations
where you really need to limit the address space of the root cgroup.

Paul
