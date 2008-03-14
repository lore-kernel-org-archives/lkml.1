Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYCNAQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYCNAQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbYCNAQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:16:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54022 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674AbYCNAQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:16:26 -0400
Message-ID: <47D9C369.2030709@cn.fujitsu.com>
Date: Fri, 14 Mar 2008 09:14:33 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Add a document describing the resource counter abstraction
 (v2)
References: <47D8F561.4000004@openvz.org>
In-Reply-To: <47D8F561.4000004@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> The resource counter is supposed to facilitate the resource accounting
> of arbitrary resource (and it already does this for memory controller).
> 
> However, it is about to be used in other resources controllers (swap,
> kernel memory, networking, etc), so provide a doc describing how to
> work with it.  This will eliminate all the possible future duplications
> in the appropriate controllers' docs.
> 
> Fixed errors pointed out by Randy.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/Documentation/controllers/resource_counter.txt b/Documentation/controllers/resource_counter.txt
> new file mode 100644
> index 0000000..563000d
> --- /dev/null
> +++ b/Documentation/controllers/resource_counter.txt
> @@ -0,0 +1,181 @@
> +
> +		The Resource Counter
> +
> +The resource counter, declared at include/linux/res_counter.h,
> +is supposed to facilitate the resource management by controllers
> +by providing common stuff for accounting.
> +
> +This "stuff" includes the res_counter structure and routines
> +to work with it.
> +
> +
> +
> +1. Crucial parts of the res_counter structure
> +
> + a. unsigned long long usage
> +
> + 	The usage value shows the amount of a resource that is consumed
> +	by a group at a given time. The units of measurement should be
> +	determined by the controller that uses this counter. E.g. it can
> +	be bytes, items or any other unit the controller operates on.
> +
> + b. unsigned long long max_usage
> +
> + 	The maximal value of the usage over time.
> +
> + 	This value is useful when gathering statistical information about
> +	the particular group, as it shows the actual resource requirements
> +	for a particular group, not just some usage snapshot.
> +
> + c. unsigned long long limit
> +
> + 	The maximal allowed amount of resource to consume by the group. In
> +	case the group requests for more resources, so that the usage value
> +	would exceed the limit, the resource allocation is rejected (see
> +	the next section).
> +
> + d. unsigned long long failcnt
> +
> + 	The failcnt stands for "failures counter". This is the number of
> +	resource allocation attempts that failed.
> +
> + c. spinlock_t lock
> +
> + 	Protects changes of the above values.
> +
> +
> +
> +2. Basic accounting routines
> +
> + a. void res_counter_init(struct res_counter *rc)
> +
> + 	Initializes the resource counter. As usual, should be the first
> +	routine called for a new counter.
> +
> + b. int res_counter_charge[_locked]
> +			(struct res_counter *rc, unsigned long val)
> +
> +	When a resource is about to be allocated it has to be accounted
> +	with the appropriate resource counter (controller should determine
> +	which one to use on its own). This operation is called "charging".
> +
> +	This is not very important which operation - resource allocation
> +	or charging - is performed first, but
> +	  * if the allocation is performed first, this may create a
> +	    temporary resource over-usage by the time resource counter is
> +	    charged;
> +	  * if the charging is performed first, then it should be uncharged
> +	    on error path (if the one is called).
> +
> + c. void res_counter_uncharge[_locked]
> +			(struct res_counter *rc, unsigned long val)
> +
> +	When a resource is released (freed) is should be de-accounted

                                            it

