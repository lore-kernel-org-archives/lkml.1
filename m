Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZBLBXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZBLBXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZBLBXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:23:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:57725 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZBLBXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:23:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,194,1233561600"; 
   d="scan'208";a="109795600"
Subject: Re: specjbb2005 fails with 2.6.29-rc4
From: Lin Ming <ming.m.lin@intel.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1234401390.7699.29.camel@minggr.sh.intel.com>
References: <1234401390.7699.29.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 09:20:44 +0800
Message-Id: <1234401644.7699.33.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 09:16 +0800, Lin Ming wrote:
> specjbb2005 fails with 2.6.29-rc4 in many testing machines.
> 
> On a 4*4cores Tigerton machine, run specjb2005 with
> starting_number_warehouses = 1 and ending_number_warehouses = 34.
> It fails when warehouses=16.
> 
> Test with Jrockit VM fails. And it works well if OpenJDK is used
> instead.

Bisect locates below commit.

> 
> commit fc8744adc870a8d4366908221508bb113d8b72ee
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Jan 31 15:08:56 2009 -0800
> 
>     Stop playing silly games with the VM_ACCOUNT flag
>     
>     The mmap_region() code would temporarily set the VM_ACCOUNT flag for
>     anonymous shared mappings just to inform shmem_zero_setup() that it
>     should enable accounting for the resulting shm object.  It would then
>     clear the flag after calling ->mmap (for the /dev/zero case) or doing
>     shmem_zero_setup() (for the MAP_ANON case).
>     
>     This just resulted in vma merge issues, but also made for just
>     unnecessary confusion.  Use the already-existing VM_NORESERVE flag for
>     this instead, and let shmem_{zero|file}_setup() just figure it out from
>     that.
>     
>     This also happens to make it obvious that the new DRI2 GEM layer uses a
>     non-reserving backing store for its object allocation - which is quite
>     possibly not intentional.  But since I didn't want to change semantics
>     in this patch, I left it alone, and just updated the caller to use the
>     new flag semantics.
>     
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/gpu/drm/drm_gem.c |    2 +-
>  ipc/shm.c                 |    4 +-
>  mm/mmap.c                 |   48 +++++++++++++++++++++++---------------------
>  mm/shmem.c                |    2 +-
>  4 files changed, 29 insertions(+), 27 deletions(-)
> 

