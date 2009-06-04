Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZFDPPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZFDPPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZFDPPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:15:33 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49325 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbZFDPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:15:32 -0400
Date: Thu, 4 Jun 2009 08:15:14 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       garyhade@us.ibm.com, pbadari@us.ibm.com,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>, ebiederm@xmission.com,
       gregkh@suse.de
Subject: Re: sysfs_create_link_nowarn still remains (Was Re: mmotm
	2009-06-03-16-33 uploaded
Message-ID: <20090604151514.GA7233@us.ibm.com>
References: <200906032353.n53Nre5r019806@imap1.linux-foundation.org> <20090604123813.96c2c5a9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604123813.96c2c5a9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:38:13PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 03 Jun 2009 16:33:52 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-06-03-16-33 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> It seems sysfs_create_link_nowarn() is removed in linux-next.patch but
> driver/base/node.c still includes it.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c04fc586c1a480ba198f03ae7b6cbd7b57380b91
> 
> How should we fix it ? Folllowing is a quick hack for compile but ...
> should be clarified by memory hotplug guys.
> 
> ==
> 
> sysfs_create_link_nowarn() is obsolete.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> Index: mmotm-2.6.30-Jun3/drivers/base/node.c
> ===================================================================
> --- mmotm-2.6.30-Jun3.orig/drivers/base/node.c
> +++ mmotm-2.6.30-Jun3/drivers/base/node.c
> @@ -279,7 +279,7 @@ int register_mem_sect_under_node(struct 
>  			continue;
>  		if (page_nid != nid)
>  			continue;
> -		return sysfs_create_link_nowarn(&node_devices[nid].sysdev.kobj,
> +		return sysfs_create_link(&node_devices[nid].sysdev.kobj,
>  					&mem_blk->sysdev.kobj,
>  					kobject_name(&mem_blk->sysdev.kobj));
>  	}
> 

Eric asked me about this yesterday and I told him that I
thought this change should be OK.  Below is the long-winded
version. 

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc


I believe I used it in an earlier version of my changes where
register_mem_sect_under_node() was called during boot for the
same memory section during both
    1. Node registration:
         topology_init() -> register_one_node() ->
         link_mem_sections() -> register_mem_sect_under_node()
and 2. Memory registration:
         memory_dev_init() -> add_memory_block() ->
         register_mem_sect_under_node()
I believe I remember looking for a call that I could use in
register_mem_sect_under_node() to test for the presence of an
existing symlink, could not find one, and ended up using
sysfs_create_link_nowarn() to avoid the warnings.

register_mem_sect_under_node() was also called during memory hotadd:
  __add_section() -> register_new_memory() ->
  add_memory_block() -> register_mem_sect_under_node()
but in this case an existing symlink should not already exist.

While working on a later version of the changes I think I decided
that even though the code worked fine, it was "tacky" to be calling
register_mem_sect_under_node() for the same memory section during
both node and memory registration.  I believe this is why I added
a bunch of code to pass the context (BOOT or HOTPLUG) down to
add_memory_block() so that I could limit
the register_mem_sect_under_node() call to memory hotadd only.
>From add_memory_block():
                        ...
                if (context == HOTPLUG)
                        ret = register_mem_sect_under_node(mem, nid);
                        ...

While doing this I believe I left the sysfs_create_link_nowarn()
call as-is because of that paranoia factor.  So, unless I'm missing
something else I *think* it is OK to change sysfs_create_link_nowarn()
to sysfs_create_link() but I'm never 100% certain about these sort
of changes without testing.  I hope you plan to do that.

That said, even though I agree with limiting the use of
sysfs_create_link_nowarn() I'm not sure that I agree with totally
killing it without replacing it with a clean way to check for the
presence of an existing symlink.  It seems like, although sometimes
"tacky", there might be cases where either "not warning" or "testing
for and not creating" makes totally good sense.

