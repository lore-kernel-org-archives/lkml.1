Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZKBG71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZKBG71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 01:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZKBG71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 01:59:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51355 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZKBG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:59:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: OOM killer, page fault
Cc: kosaki.motohiro@jp.fujitsu.com, Norbert Preining <preining@logic.at>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20091102135640.93de7c2a.minchan.kim@barrios-desktop>
References: <20091102005218.8352.A69D9226@jp.fujitsu.com> <20091102135640.93de7c2a.minchan.kim@barrios-desktop>
Message-Id: <20091102155543.E60E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  2 Nov 2009 15:59:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon,  2 Nov 2009 13:24:06 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi,
> > 
> > (Cc to linux-mm)
> > 
> > Wow, this is very strange log.
> > 
> > > Dear all,
> > > 
> > > (please Cc)
> > > 
> > > With 2.6.32-rc5 I got that one:
> > > [13832.210068] Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0
> > 
> > order = 0
> 
> I think this problem results from 'gfp_mask = 0x0'.
> Is it possible?
> 
> If it isn't H/W problem, Who passes gfp_mask with 0x0?
> It's culpit. 
> 
> Could you add BUG_ON(gfp_mask == 0x0) in __alloc_pages_nodemask's head?

No.
In page fault case, gfp_mask show meaningless value. Please ignore it.
pagefault_out_of_memory() always pass gfp_mask==0 to oom.


mm/oom_kill.c
====================================
void pagefault_out_of_memory(void)
{
        unsigned long freed = 0;

        blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
        if (freed > 0)
                /* Got some memory back in the last second. */
                return;

        /*
         * If this is from memcg, oom-killer is already invoked.
         * and not worth to go system-wide-oom.
         */
        if (mem_cgroup_oom_called(current))
                goto rest_and_return;

        if (sysctl_panic_on_oom)
                panic("out of memory from page fault. panic_on_oom is selected.\n");

        read_lock(&tasklist_lock);
        __out_of_memory(0, 0);       <---- here! 
        read_unlock(&tasklist_lock);

