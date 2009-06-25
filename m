Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZFYV2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZFYV2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZFYV2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:28:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbZFYV2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:28:45 -0400
Date: Thu, 25 Jun 2009 14:28:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com,
       lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [PATCH 0/2] memcg: cgroup fix rmdir hang
Message-Id: <20090625142809.ac6b7b85.akpm@linux-foundation.org>
In-Reply-To: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 16:07:20 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> previous discussion was this => http://marc.info/?t=124478543600001&r=1&w=2
> 
> This patch tries to fix problem as
>   - rmdir can sleep very very long if swap entry is shared between multiple
>     cgroups
> 
> Now, cgroup's rmdir path does following
> 
> ==
> again:
> 	check there are no tasks and children group.
> 	call pre_destroy()
> 	check css's refcnt
> 	if (refcnt > 0) {
> 		sleep until css's refcnt goes down to 0.
> 		goto again
> 	}
> ==
> 
> Unfortunately, memory cgroup does following at charge.
> 
> 	css_get(&memcg->css)
> 	....
> 	charge(memcg) (increase USAGE)
> 	...
> And this "memcg" is not necessary to include the caller, task.
> 
> pre_destroy() tries to reduce memory usage until USAGE goes down to 0.
> Then, there is a race that
> 	- css's refcnt > 0 (and memcg's usage > 0)
> 	- rmdir() caller sleeps until css->refcnt goes down 0.
> 	- But to make css->refcnt be 0, pre_destroy() should be called again.
> 
> This patch tries to fix this in asyhcnrounos way (i.e. without big lock.)
> Any comments are welcome.
> 

Do you believe that these fixes should be backported into 2.6.30.x?
