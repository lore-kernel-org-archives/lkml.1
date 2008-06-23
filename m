Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYFWWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYFWWlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 18:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYFWWlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 18:41:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26340 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYFWWlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 18:41:08 -0400
Date: Mon, 23 Jun 2008 15:40:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/6] res_counter:  handle limit change
Message-Id: <20080623154043.c4d68d62.randy.dunlap@oracle.com>
In-Reply-To: <20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 18:29:24 +0900 KAMEZAWA Hiroyuki wrote:

> Add a support to shrink_usage_at_limit_change feature to res_counter.
> memcg will use this to drop pages.
> 
> Change log: xxx -> v4 (new file.)
>  - cut out the limit-change part from hierarchy patch set.
>  - add "retry_count" arguments to shrink_usage(). This allows that we don't
>    have to set the default retry loop count.
>  - res_counter_check_under_val() is added to support subsystem.
>  - res_counter_init() is res_counter_init_ops(cnt, NULL)
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> ---
>  Documentation/controllers/resource_counter.txt |   19 +++++-
>  include/linux/res_counter.h                    |   33 ++++++++++-
>  kernel/res_counter.c                           |   74 ++++++++++++++++++++++++-
>  3 files changed, 121 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.26-rc5-mm3/Documentation/controllers/resource_counter.txt
> ===================================================================
> --- linux-2.6.26-rc5-mm3.orig/Documentation/controllers/resource_counter.txt
> +++ linux-2.6.26-rc5-mm3/Documentation/controllers/resource_counter.txt
> @@ -141,8 +145,19 @@ counter fields. They are recommended to 
>  	failcnt		reset to zero
>  
>  
> +5. res_counter_ops (Callbacks)
>  
> -5. Usage example
> +   res_counter_ops is for implementing feedback control from res_counter
> +   to subsystem. Each one has each own purpose and the subsystem doesn't

                                                                    isn't

> +   necessary to provide all callbacks. Just implement necessary ones.

      required

> +
> +   - shrink_usage(res_counter, newlimit, retry)
> +     Called for reducing usage to newlimit, retry is incremented per
> +     loop. (See memory resource controller as example.)
> +     Returns 0 at success. Any error code is acceptable but -EBUSY will be
> +     suitable to show "the kernel can't shrink usage."
> +
> +6. Usage example
>  
>   a. Declare a task group (take a look at cgroups subsystem for this) and
>      fold a res_counter into it


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
