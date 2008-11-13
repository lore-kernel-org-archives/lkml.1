Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYKMR2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYKMR2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKMR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:28:27 -0500
Received: from over.ny.us.ibm.com ([32.97.182.150]:60392 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYKMR21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:28:27 -0500
Subject: Re: [BUGFIX][PATCH] memory hotplug: fix notiier chain return value
	(Was Re: 2.6.28-rc4 mem_cgroup_charge_common panic)
From: Badari Pulavarty <pbadari@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081113202758.2f12915a.kamezawa.hiroyu@jp.fujitsu.com>
References: <1226353408.8805.12.camel@badari-desktop>
	 <20081113202758.2f12915a.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 09:11:09 -0800
Message-Id: <1226596269.4835.21.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 20:27 +0900, KAMEZAWA Hiroyuki wrote:
> Badari, I think you used SLUB. If so, page_cgroup's notifier callback was not
> called and newly allocated page's page_cgroup wasn't allocated.
> This is a fix. (notifier saw STOP_HERE flag added by slub's notifier.)

No. I wasn't using SLUB.

 # egrep "SLUB|SLAB" .config
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_SLABINFO=y
# CONFIG_DEBUG_SLAB is not set


I can test the patch and let you know.

Thanks,
Badari

> 
> I'm now testing modified kernel, which does alloc/free page_cgroup by notifier.
> (Usually, all page_cgroups are from bootmem and not freed.
>  so, modified a bit for test)
> 
> And I cannot reproduce panic. I think you do "real" memory hotplug other than
> online/offline and saw panic caused by this. 
> 
> Is this slub's behavior intentional ? page_cgroup's notifier has lower priority
> than slub, now.
> 
> Thanks,
> -Kame
> ==
> notifier callback's notifier_from_errno() just works well in error
> route. (It adds mask for "stop here")
> 
> Hanlder should return NOTIFY_OK in explict way.
> 
> Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/page_cgroup.c |    5 ++++-
>  mm/slub.c        |    6 ++++--
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> Index: mmotm-2.6.28-Nov10/mm/slub.c
> ===================================================================
> --- mmotm-2.6.28-Nov10.orig/mm/slub.c
> +++ mmotm-2.6.28-Nov10/mm/slub.c
> @@ -3220,8 +3220,10 @@ static int slab_memory_callback(struct n
>  	case MEM_CANCEL_OFFLINE:
>  		break;
>  	}
> -
> -	ret = notifier_from_errno(ret);
> +	if (ret)
> +		ret = notifier_from_errno(ret);
> +	else
> +		ret = NOTIFY_OK;
>  	return ret;
>  }
> 
> Index: mmotm-2.6.28-Nov10/mm/page_cgroup.c
> ===================================================================
> --- mmotm-2.6.28-Nov10.orig/mm/page_cgroup.c
> +++ mmotm-2.6.28-Nov10/mm/page_cgroup.c
> @@ -216,7 +216,10 @@ static int page_cgroup_callback(struct n
>  		break;
>  	}
> 
> -	ret = notifier_from_errno(ret);
> +	if (ret)
> +		ret = notifier_from_errno(ret);
> +	else
> +		ret = NOTIFY_OK;
> 
>  	return ret;
>  }
> 
> 

