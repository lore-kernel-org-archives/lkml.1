Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbYKMBbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbYKMBbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYKMBa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:30:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64900 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYKMBa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:30:59 -0500
Message-ID: <491B82B7.5030002@cn.fujitsu.com>
Date: Thu, 13 Nov 2008 09:28:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
 (v3)
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop> <20081111123448.6566.55973.sendpatchset@balbir-laptop>
In-Reply-To: <20081111123448.6566.55973.sendpatchset@balbir-laptop>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * If parent's use_hiearchy is set, we can't make any modifications
> +	 * in the child subtrees. If it is unset, then the change can
> +	 * occur, provided the current cgroup has no children.
> +	 *
> +	 * For the root cgroup, parent_mem is NULL, we allow value to be
> +	 * set if there are no children.
> +	 */
> +	if (!parent_mem || (!parent_mem->use_hierarchy &&
> +				(val == 1 || val == 0))) {
> +		if (list_empty(&cont->children))
> +			mem->use_hierarchy = val;
> +		else
> +			retval = -EBUSY;
> +	} else
> +		retval = -EINVAL;
> +
> +	return retval;
> +}

As I mentioned there is a race here. :(

echo 1 > /memcg/memory.use_hierarchy
 =>if (list_empty(&cont->children))
                                      mkdir /memcg/0
                                       => mem->use_hierarchy = 0
       mem->use_hierarchy = 1;

Now it ends up with parent's use_hierarchy is set but its child's
use_hierarchy is not set.
