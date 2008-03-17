Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYCQQx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYCQQx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYCQQxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:53:19 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34801 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYCQQxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:53:18 -0400
Subject: Re: [RFC][2/3] Account and control virtual address space
	allocations
From: Dave Hansen <haveblue@us.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
	 <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 09:53:10 -0700
Message-Id: <1205772790.18916.17.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-16 at 23:00 +0530, Balbir Singh wrote:
> @@ -787,6 +788,8 @@ static int ptrace_bts_realloc(struct tas
>         current->mm->total_vm  -= old_size;
>         current->mm->locked_vm -= old_size;
>  
> +       mem_cgroup_update_as(current->mm, -old_size);
> +
>         if (size == 0)
>                 goto out;

I think splattering these things all over is probably a bad idea.

If you're going to do this, I think you need a couple of phases.  

1. update the vm_(un)acct_memory() functions to take an mm
2. start using them (or some other abstracted functions in place)
3. update the new functions for cgroups

It's a bit non-obvious why you do the mem_cgroup_update_as() calls in
the places that you do from context.

Having some other vm-abstracted functions will also keep you from
splattering mem_cgroup_update_as() across the tree.  That's a pretty bad
name. :)  ...update_mapped() or ...update_vm() might be a wee bit
better. 

-- Dave

