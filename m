Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZKFESY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZKFESY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 23:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbZKFESX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 23:18:23 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37663 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbZKFESW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 23:18:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Nov 2009 13:15:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic V2
Message-Id: <20091106131545.62f52abb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	<20091104234923.GA25306@redhat.com>
	<alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1>
	<alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 10:36:06 -0500 (EST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> +static inline unsigned long get_mm_rss(struct mm_struct *mm)
> +{
> +	int cpu;
> +	unsigned long r = 0;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct mm_counter *c = per_cpu_ptr(mm->rss, cpu);
> +
> +		r = c->file + c->anon;
> +	}
> +
> +	return r;
> +}
> +
> +static inline void update_hiwater_rss(struct mm_struct *mm)
> +{
> +	unsigned long _rss = get_mm_rss(mm);
> +	if (mm->hiwater_rss < _rss)
> +		mm->hiwater_rss = _rss;
> +}
> +

I'm sorry for my replies are scatterd.

Isn't it better to add some filter in following path ?

==
static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
                                enum ttu_flags flags)
{
<snip>
       /* Update high watermark before we lower rss */
        update_hiwater_rss(mm);
==

Thanks,
-Kame

