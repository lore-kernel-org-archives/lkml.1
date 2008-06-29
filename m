Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYF2MVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYF2MVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbYF2MVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:21:07 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43798 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYF2MVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:21:05 -0400
Date: Sun, 29 Jun 2008 13:20:42 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: memcg swapbacked pages active
In-Reply-To: <20080629171251.37CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0806291302160.787@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
 <Pine.LNX.4.64.0806290120270.21758@blonde.site> <20080629171251.37CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, KOSAKI Motohiro wrote:
> > add_to_page_cache_lru puts PageSwapBacked pages on the active_anon lru,
> > so shouldn't mem_cgroup_charge_common mirror that by setting FLAG_ACTIVE?
> > 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> I don't think so.
> 
> in global lru, active vs inactive anon ratio is controlled by 
> inactive_anon_is_low().
> but memcg doesn't have any sililar things.
> 
> thus, this patch increase active anon. and too many active page cause
> decrease reclaim throuput.
> 
> yes, We should implement SEQ replacement reclaim (like global reclaim)
> for memcg.
> I'm working on this.

Hmm.  Thanks for looking into it (and the others).  This is something
I noticed as a discrepancy in the source, rather than something from
which I observed any OOMs.  So if you're already working on bringing
the global and memcg approaches into line, I defer to your judgement.

But it seems to me worrying and fragile while they diverge in this way.
If the global has anon, active anon, file, active file and unevictable
lrus for the page; and the memcg has anon, active anon, file, active file
and unevictable lrus for the page cgroup; but different choices are made
which to put on where, then we're heading for confusion and trouble.

And when called, __mem_cgroup_move_lists tries to keep the activ-ity of
the memcg lrus in step with the activ-ity of the global lrus, doesn't
it?  So it's beyond my comprehension to start them off out of step.

Hugh
