Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYIKRv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYIKRv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 13:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYIKRu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 13:50:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56699 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756080AbYIKRu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 13:50:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mvoON2US98gCycTVcSN1YgIE4nzH0j2dkkr8aUfo5EaIpfM5tBOFD5daK8Jp743d3
	4piyLkjiLlUrOAIY4dOqQ==
Message-ID: <6599ad830809111050h27d22369m8fc4faa47920f784@mail.gmail.com>
Date: Thu, 11 Sep 2008 10:50:44 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH -mm 2/2] cgroup: fold struct cg_cgroup_link into struct css_set
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48C929DF.3050009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C929DF.3050009@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 7:23 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> one struct cg_cgroup_link per link is very waste.
> This way need to allocate struct cg_cgroup_link for
> (css_set_count * hierarchy_count) times.

Correct - but in the common case, hierarchy_count==1. So it's 7
pointers (two list_heads and a pointer in the cg_cgroup_link, and a
list_head in the css_set) per css_set. Each additional hierarchy
introduces 5 pointers per css_set with the new cg_cgroup_link. (So
overall, 2 + 5*H)

We're up to 9 cgroup subsystems in -mm right now, so your approach
consumes 18 pointers (9 list heads) per css_set, regardless of how
many hierarchies are mounted.

So I think that the current solution saves memory when there are fewer
than four hierarchies mounted. As the number of cgroup subsystems
increases, the break-even point will increase. I expect that the most
common number of mounted hierarchies will be 0 (but there's only one
css_set in that case, so the overhead is irrelevant) or 1.

>
> This patch removes lots of line of code. remove struct cg_cgroup_link
> and corresponding code.

Yes, the code is definitely simpler after your patch. It's pretty much
how it was *before* I introduced the cg_cgroup_link structures to
allow an arbitrary number of hierarchies without bloating the css_set
structure. I'm not convinced that we want to go back to the original
way.

Paul
