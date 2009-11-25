Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZKYHSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZKYHSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbZKYHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:18:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43607 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZKYHSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:18:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH 4/7] nandsim: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
In-Reply-To: <4B0CD912.7090002@nokia.com>
References: <20091125084630.AFC5.A69D9226@jp.fujitsu.com> <4B0CD912.7090002@nokia.com>
Message-Id: <20091125161402.AFEA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 25 Nov 2009 16:18:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> >> KOSAKI Motohiro wrote:
> >>> Hi
> >>>
> >>> Thank you for this useful comments.
> >>>
> >>>>> I vaguely remember Adrian (CCed) did this on purpose. This is for the
> >>>>> case when nandsim emulates NAND flash on top of a file. So there are 2
> >>>>> file-systems involved: one sits on top of nandsim (e.g. UBIFS) and the
> >>>>> other owns the file which nandsim uses (e.g., ext3).
> >>>>>
> >>>>> And I really cannot remember off the top of my head why he needed
> >>>>> PF_MEMALLOC, but I think Adrian wanted to prevent the direct reclaim
> >>>>> path to re-enter, say UBIFS, and cause deadlock. But I'd thing that all
> >>>>> the allocations in vfs_read()/vfs_write() should be GFP_NOFS, so that
> >>>>> should not be a probelm?
> >>>>>
> >>>> Yes it needs PF_MEMALLOC to prevent deadlock because there can be a
> >>>> file system on top of nandsim which, in this case, is on top of another
> >>>> file system.
> >>>>
> >>>> I do not see how mempools will help here.
> >>>>
> >>>> Please offer an alternative solution.
> >>> I have few questions.
> >>>
> >>> Can you please explain more detail? Another stackable filesystam
> >>> (e.g. ecryptfs) don't have such problem. Why nandsim have its issue?
> >>> What lock cause deadlock?
> >> The file systems are not stacked.  One is over nandsim, which nandsim
> >> does not know about because it is just a lowly NAND device, and, with
> >> the file cache option, one file system below to provide the file cache.
> >>
> >> The deadlock is the kernel writing out dirty pages to the top file system
> >> which writes to nandsim which writes to the bottom file system which
> >> allocates memory which causes dirty pages to be written out to the top
> >> file system, which tries to write to nandsim => deadlock.
> > 
> > You mean you want to prevent pageout() instead reclaim itself?
> 
> Yes
> 
> > Dropping filecache seems don't make recursive call, right?
> 
> Yes

o.k.

I really think the cache dropping shuoldn't be prevented because
typical linux box have lots droppable file cache and very few free pages.
but prevent pageout() seems not so problematic.

Thank you for good information.


