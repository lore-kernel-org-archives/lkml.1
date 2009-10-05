Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZJETQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZJETQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZJETQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:16:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55305 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZJETQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:16:23 -0400
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 12:15:43 -0700
Message-Id: <1254770143.8175.1213.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 23:57 +0800, Jeff Chua wrote:
> # with 64GB
>               total       used       free     shared    buffers     cached
> Mem:         63995        524      63470          0          4        365
> Low:           378         32        345
> High:        63616        492      63124
> -/+ buffers/cache:        154      63840
> Swap:        28003          0      28003
> 
> 
> Question is ... is there anyway to increase "low mem" without resorting to 
> migrating to 64bit? (Look... it only has 378MB total low mem vs 850MB on 
> the 4GB system). I've oracle installed on the 64GB system and it keeps 
> getting OOMs!

Heh.  You've really squeezed yourself into a bad situation.  Go get a
64-bit kernel... please.  You should be able to run 32-bit userspace
with a 64-bit kernel.  Do you have some 32-bit kernel component that you
are relying on?

The kernel has a structure called 'struct page'.  We allocate one of
those for each 4k page of physical memory on x86.  But, each 'struct
page' is/was 32-bytes (is it still??).  That means that on a 64GB
system, you've used at *least* 512MB of your 896MB of lowmem before
you're even out of early boot.  That's just one structure. 

The practical options are to use a different VMSPLIT or to use the RHEL
4/4 kernel.  The VMSPLIT option is in mainline and it will let chop up
the user/kernel virtual address boundary in different ways.  Looking at
arch/x86/Kconfig it doesn't look like mainline's code works with PAE.
It's theoretically possible, but not very practical.  I think I hacked
up a custom kernel for a customer to do this once a long time ago, but
it was painful.

The RHEL 4/4 kernel is a big fat hack.  I think they called it "hugemem"
or something.  It gives the kernel (and userspace) ~4GB of of vaddr
space each, but costs you some extra context switch time.  It lived in
-mm for a while and never made it to mainline.

I see it mentioned here:

	http://www.redhat.com/rhel/previous_versions/rhel3/

and I don't know if it was continued in other RHEL releases.

You can get around the 896MB limit, but it's painful.  You'll almost
certainly need a hacked kernel.

-- Dave

