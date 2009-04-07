Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZDGN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZDGN7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZDGN7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:59:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbZDGN7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:59:02 -0400
Date: Tue, 7 Apr 2009 15:57:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, mtosatti@redhat.com, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v2
Message-ID: <20090407135745.GA21874@random.random>
References: <1238855722-32606-1-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238855722-32606-1-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 05:35:18PM +0300, Izik Eidus wrote:
> From v1 to v2:
> 
> 1)Fixed security issue found by Chris Wright:
>     Ksm was checking if page is a shared page by running !PageAnon.
>     Beacuse that Ksm scan only anonymous memory, all !PageAnons
>     inside ksm data strctures are shared page, however there might
>     be a case for do_wp_page() when the VM_SHARED is used where
>     do_wp_page() would instead of copying the page into new anonymos
>     page, would reuse the page, it was fixed by adding check for the
>     dirty_bit of the virtual addresses pointing into the shared page.
>     I was not finding any VM code tha would clear the dirty bit from
>     this virtual address (due to the fact that we allocate the page
>     using page_alloc() - kernel allocated pages), ~but i still want
>     confirmation about this from the vm guys - thanks.~

As far as I can tell this wasn't a bug and this change is
unnecessary. I already checked this bit but I may have missed
something, so I ask here to be sure.

As far as I can tell when VM_SHARED is set, no anonymous page can ever
be allocated by in that vma range, hence no KSM page can ever be
generated in that vma either. MAP_SHARED|MAP_ANONYMOUS is only a
different API for /dev/shm, IPCSHM backing, no anonymous pages can
live there. It surely worked like that in older 2.6, reading latest
code it seems to still work like that, but if something has changed
Hugh will surely correct me in a jiffy ;).

I still see this in the file=null path.
  
  } else if (vm_flags & VM_SHARED) {
    error = shmem_zero_setup(vma);
    	  if (error)
		goto free_vma;
		}


So you can revert your change for now.
