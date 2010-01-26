Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129Ab0AZMdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0AZMdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577Ab0AZMdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:33:40 -0500
Received: from mga05.intel.com ([192.55.52.89]:39201 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752523Ab0AZMdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:33:40 -0500
Message-Id: <89k77n$mrr1hi@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,346,1262592000"; 
   d="scan'208";a="767395378"
Date: Tue, 26 Jan 2010 12:33:29 +0000
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Roman Jarosz <kedgedev@gmail.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
Cc: kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
       A Rojas <nqn1976list@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
References: <20100126141055.5AAD.A69D9226@jp.fujitsu.com> <op.u64t84zuasvm2a@kedge> <20100126183412.6AC9.A69D9226@jp.fujitsu.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100126183412.6AC9.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 20:07:43 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>         obj->filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
> (snip)
>         /* Basically we want to disable the OOM killer and handle ENOMEM
>          * ourselves by sacrificing pages from cached buffers.
>          * XXX shmem_file_[gs]et_gfp_mask()
>          */
>         mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping,
>                              GFP_HIGHUSER |
>                              __GFP_COLD |
>                              __GFP_FS |
>                              __GFP_RECLAIMABLE |
>                              __GFP_NORETRY |
>                              __GFP_NOWARN |
>                              __GFP_NOMEMALLOC);
> 
> 
> This comment is lie. __GFP_NORETY cause ENOMEM to shmem, not GEM itself.
> GEM can't handle nor recover it. I suspect following commit is wrong. 

Indeed, the NORETRY flag is required for the inode mapping routines to
return ENOMEM instead of triggering the OOM killer themselves. GEM has
code to handle the ENOMEM as returned from shmem (please at least read the
code before commenting, and comments are appreciated), by attempting to
free up some of its own inactive buffers before retrying the allocation
(with NORETRY removed, so the OOM killer will be invoked on the second
instance). The reason for this convoluted approach is that GEM's inactive
list shrinker requires the struct mutex and so cannot be run when GEM
itself is attempting and failing to allocate memory. We could recover from
more situations if we made some more invasive changes to our locking.

This is without a doubt an area that needs improvement.
-- 
Chris Wilson, Intel Open Source Technology Centre
