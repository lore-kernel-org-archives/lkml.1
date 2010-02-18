Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab0BRQmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:42:01 -0500
Received: from nox.protox.org ([88.191.38.29]:47687 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab0BRQl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:41:59 -0500
Date: Thu, 18 Feb 2010 17:35:05 +0100
From: Jerome Glisse <glisse@freedesktop.org>
To: hpa@zytor.com, suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com
Cc: thellstrom@vmware.com, airlied@linux.ie, currojerez@riseup.net,
       linux-kernel@vger.kernel.org
Subject: Re: Uncool feature for TTM introduced by x86, pat: Use page flags to
 track memtypes of RAM pages
Message-ID: <20100218163505.GA11509@localhost.localdomain>
References: <20100218153032.GA4506@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218153032.GA4506@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 04:30:32PM +0100, Jerome Glisse wrote:
> Hi,
> 
> commit id: f58417409603d62f2eb23db4d2cf6853d84a1698
> 
> TTM is doing uncommon use of set_memory_wc|uc|wb for instance it's not
> uncommon for TTM to change memory type from wc to uc or from uc to wc.
> Since x86, pat: Use page flags to track memtypes of RAM pages (commit
> id above) this isn't allowed anymore, before going from uc to wc or
> wc to uc we first have to free the memtype by going through wb this
> means an extra step which likely lead to some overhead (i guess that
> uc -> wc or wc -> uc won't trigger massive tlb/cpu flush while
> uc -> wb -> wc or wc -> wb -> uc will). reserve_ram_pages_type is the
> function which will check that memory is wb thus enforcing us to go
> through wb step.
> 
> Can we modify the interface to support again changing from uc to wc
> or wc to uc ? (i can try to do a patch for that).

Ok, we are likely not hit by wc -> uc or uc -> wc change (which is dumb
but i haven't yet understand what is exactly happening for the user)
My guess is that on non PAT get_page_memtype always return -1
Thus i think we will need to export a function bool pat_is_enabled() so
ttm can pickup the proper path in the unlikely/broken case of
wc -> uc.

> If no, we have a sever regression on non PAT arch :
> http://bugzilla.kernel.org/show_bug.cgi?id=15328
> (AFAIK bugzilla.kernel.org is down for me at the moment) because we
> are doing the extra set wb step (i haven't dived deep into the code
> to check what happen on non PAT). My guess is that on non PAT the
> extra set wb can be avoided right ? Also what is your educated guess
> on why on non PAT this extra set wb is slowing down thing badly ?
> Last can we make this extra step only on PAT enabled arch ?
> 
> In PAT case right now we are calling get get_page_memtype to know
> if we need to set page to wb first my understanding is that we should
> protect this call by memtype_lock spinlock (even if i don't think we
> can have collision here as we are protected by TTM locking), maybe
> we can directly use TTM information to call or not set wb and avoid
> using get_page_memtype.
> 
> Sorry for being such annoying user of PAT, i guess GPU is the only
> place having such strange and intensive cache change pattern.
> 
Cheers,
Jerome
