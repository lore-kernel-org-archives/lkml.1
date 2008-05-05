Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbYEEWgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbYEEWgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYEEWfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:35:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbYEEWfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:35:53 -0400
Date: Mon, 5 May 2008 15:35:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       rientjes@google.com, xemul@openvz.org, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 4/4] Add rlimit controller documentation
Message-Id: <20080505153509.da667caf.akpm@linux-foundation.org>
In-Reply-To: <20080503213825.3140.4328.sendpatchset@localhost.localdomain>
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
	<20080503213825.3140.4328.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 May 2008 03:08:25 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> This is the documentation patch. It describes the rlimit controller and how
> to build and use it.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  Documentation/controllers/rlimit.txt |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff -puN /dev/null Documentation/controllers/rlimit.txt
> --- /dev/null	2008-05-03 22:12:13.033285313 +0530
> +++ linux-2.6.25-balbir/Documentation/controllers/rlimit.txt	2008-05-04 03:06:06.000000000 +0530
> @@ -0,0 +1,29 @@
> +This controller is enabled by the CONFIG_CGROUP_RLIMIT_CTLR option. Prior
> +to reading this documentation please read Documentation/cgroups.txt and
> +Documentation/controllers/memory.txt. Several of the principles of this
> +controller are similar to the memory resource controller.
> +
> +This controller framework is designed to be extensible to control any
> +resource limit (memory related) with little effort.
> +
> +This new controller, controls the address space expansion of the tasks
> +belonging to a cgroup. Address space control is provided along the same lines as
> +RLIMIT_AS control, which is available via getrlimit(2)/setrlimit(2).
> +The interface for controlling address space is provided through
> +"rlimit.limit_in_bytes". The file is similar to "limit_in_bytes" w.r.t. the user
> +interface. Please see section 3 of the memory resource controller documentation
> +for more details on how to use the user interface to get and set values.
> +
> +The "rlimit.usage_in_bytes" file provides information about the total address
> +space usage of the tasks in the cgroup, in bytes.

Finally, with a bit of between-the-line reading, I begin to understand what
this stuff is actually supposed to do.

It puts an upper limit upon the _total_ address-space size of all the mms
which are contained within the resource group, yes?

(can am mm be shared by two threads whcih are in different resource groups,
btw?)

> +Advantages of providing this feature
> +
> +1. Control over virtual address space allows for a cgroup to fail gracefully
> +   i.e., via a malloc or mmap failure as compared to OOM kill when no
> +   pages can be reclaimed.
> +2. It provides better control over how many pages can be swapped out when
> +   the cgroup goes over its limit. A badly setup cgroup can cause excessive
> +   swapping. Providing control over the address space allocations ensures
> +   that the system administrator has control over the total swapping that
> +   can take place.

Here's another missing piece: what is the kernel's behaviour when such a
limit is increased?  Seems that the sole option is a failure return from
mmap/brk/sbrk/etc, yes?

This should be spelled out in careful detail, please.  This is a
newly-proposed kernel<->userspace interface and we care about those very
much.

Finally, I worry about overflows.  afacit the
sum-of-address-space-sizes-for-a-cgroup is accounted for in an unsigned
long?

If so, a 32-bit machine could easily overflow it.

And a 64-bit machine could possibly do so with a bit of effort, perhaps? 
That's assuming that the code doesn't attempt to avoid duplicate accounting
due to multiple-mms-mapping-the-same-pages, which afaict appears to be the
case.  (Then again, perhaps no machine will ever have the pagetable space
to get that far).



Ho hum, I had to do rather a lot of guesswork here to try to understand
your proposed overall design for this feature.  I'd prefer to hear about
your design via more direct means.
