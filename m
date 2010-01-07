Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163Ab0AGVqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0AGVqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871Ab0AGVqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:46:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:9999 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0AGVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:46:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=k46uDWyinEv2SjpdLxW56tLNdfx4nM7bJ2O1BTNSu6mB6UwAzs4s9EiypFYJRzMhQ
	unASZt9JgyVJPueG8A+yA==
Date: Thu, 7 Jan 2010 13:46:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] Allow CONFIG_MIGRATION to be set without
 CONFIG_NUMA
In-Reply-To: <1262795169-9095-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1001071331520.23894@chino.kir.corp.google.com>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Mel Gorman wrote:

> CONFIG_MIGRATION currently depends on CONFIG_NUMA. The current users of
> page migration such as sys_move_pages(), sys_migrate_pages() and cpuset
> process migration are ordinarily only beneficial on NUMA.
> 
> As memory compaction will operate within a zone and is useful on both NUMA
> and non-NUMA systems, this patch allows CONFIG_MIGRATION to be set if the
> user selects CONFIG_COMPACTION as an option.
> 
> TODO
>   o After this patch is applied, the migration core is available but it
>     also makes NUMA-specific features available. This is too much
>     exposure so revisit this.
> 

CONFIG_MIGRATION is no longer strictly dependent on CONFIG_NUMA since 
ARCH_ENABLE_MEMORY_HOTREMOVE has allowed it to be configured for UMA 
machines.  All strictly NUMA features in the migration core should be 
isolated under its #ifdef CONFIG_NUMA (sys_move_pages()) in mm/migrate.c 
or by simply not compiling mm/mempolicy.c (sys_migrate_pages()), so this 
patch looks fine as is (although the "help" text for CONFIG_MIGRATION 
could be updated to reflect that it's useful for both memory hot-remove 
and now compaction).

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/Kconfig |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 17b8947..1d8e2b2 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -168,12 +168,22 @@ config SPLIT_PTLOCK_CPUS
>  	default "4"
>  
>  #
> +# support for memory compaction
> +config COMPACTION
> +	bool "Allow for memory compaction"
> +	def_bool y
> +	select MIGRATION
> +	depends on EXPERIMENTAL && HUGETLBFS
> +	help
> +	  Allows the compaction of memory for the allocation of huge pages.
> +
> +#
>  # support for page migration
>  #
>  config MIGRATION
>  	bool "Page migration"
>  	def_bool y
> -	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
> +	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION
>  	help
>  	  Allows the migration of the physical location of pages of processes
>  	  while the virtual addresses are not changed. This is useful for
