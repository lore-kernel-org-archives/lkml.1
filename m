Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbZLOLMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbZLOLMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbZLOLMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:12:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53581 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759903AbZLOLMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:12:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Dec 2009 20:09:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 4/4] memcg: implement memory thresholds
Message-Id: <20091215200927.68126d96.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cc557aab0912150246k476aa85m6c1b61045fb0b26e@mail.gmail.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	<ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	<c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	<747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	<9e6e8d687224c6cbc54281f7c3d07983f701f93d.1260571675.git.kirill@shutemov.name>
	<20091215105850.87203454.kamezawa.hiroyu@jp.fujitsu.com>
	<cc557aab0912150246k476aa85m6c1b61045fb0b26e@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 12:46:32 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Tue, Dec 15, 2009 at 3:58 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Sat, 12 Dec 2009 00:59:19 +0200
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> > If you use have to use spinlock here, this is a system-wide spinlock,
> > threshold as "100" is too small, I think.
> 
> What is reasonable value for THRESHOLDS_EVENTS_THRESH for you?
> 
> In most cases spinlock taken only for two checks. Is it significant time?
> 
I tend to think about "bad case" when I see spinlock. 

And...I'm not sure but, recently, there are many VM users.
spinlock can be a big pitfall in some enviroment if not para-virtualized.
(I'm sorry I misunderstand somehing and VM handle this well...)

> Unfortunately, I can't test it on a big box. I have only dual-core system.
> It's not enough to test scalability.
> 

please leave it as 100 for now. But there is a chance to do simple optimization
for reducing the number of checks.

example)
static void mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
{
	/* For handle memory allocation in rush, check jiffies */
	*/
	smp_rmb();
	if (memcg->last_checkpoint_jiffies == jiffies)
		return;   /* reset event to half value ..*/
	memcg->last_checkpoint_jiffies = jiffies;
	smp_wmb();
	.....

I think this kind of check is necessary for handle "Rushing" memory allocation
in scalable way. Above one is just an example, 1 tick may be too long.

Other simple plan is

	/* Allow only one thread to do scan the list at the same time. */
	if (atomic_inc_not_zero(&memcg->threahold_scan_count) {
		atomic_dec(&memcg->threshold_scan_count);
		return;
	}
	...
	atomic_dec(&memcg->threahold_scan_count)

Some easy logic (as above) for taking care of scalability and commenary for that
is enough at 1st stage. Then, if there seems to be a trouble/concern, someone
(me?) will do some work later.




Thanks,
-Kame

