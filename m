Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZKMI0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZKMI0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZKMI0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:26:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50864 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZKMI0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:26:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20091113143930.33BF.A69D9226@jp.fujitsu.com>
References: <Pine.LNX.4.64.0911111048170.12126@sister.anvils> <20091113143930.33BF.A69D9226@jp.fujitsu.com>
Message-Id: <20091113172453.33CB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 13 Nov 2009 17:26:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Wed, 11 Nov 2009, KOSAKI Motohiro wrote:
> > 
> > Though it doesn't quite answer your question,
> > I'll just reinsert the last paragraph of my description here...
> > 
> > > > try_to_unmap_file()'s TTU_MUNLOCK nonlinear handling was particularly
> > > > amusing: once unravelled, it turns out to have been choosing between
> > > > two different ways of doing the same nothing.  Ah, no, one way was
> > > > actually returning SWAP_FAIL when it meant to return SWAP_SUCCESS.
> > 
> > ... 
> > > > @@ -1081,45 +1053,23 @@ static int try_to_unmap_file(struct page
> > ...
> > > >
> > > > -	if (list_empty(&mapping->i_mmap_nonlinear))
> > > > +	/* We don't bother to try to find the munlocked page in nonlinears */
> > > > +	if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
> > > >  		goto out;
> > > 
> > > I have dumb question.
> > > Does this shortcut exiting code makes any behavior change?
> > 
> > Not dumb.  My intention was to make no behaviour change with any of
> > this patch; but in checking back before completing the description,
> > I suddenly realized that that shortcut intentionally avoids the
> > 
> > 	if (max_nl_size == 0) {	/* all nonlinears locked or reserved ? */
> > 		ret = SWAP_FAIL;
> > 		goto out;
> > 	}
> > 
> > (which doesn't show up in the patch: you'll have to look at rmap.c),
> > which used to have the effect of try_to_munlock() returning SWAP_FAIL
> > in the case when there were one or more VM_NONLINEAR vmas of the file,
> > but none of them (and none of the covering linear vmas) VM_LOCKED.
> > 
> > That should have been a SWAP_SUCCESS case, or with my changes
> > another SWAP_AGAIN, either of which would make munlock_vma_page()
> > 				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
> > which would be correct; but the SWAP_FAIL meant that count was not
> > incremented in this case.
> 
> Ah, correct.
> Then, we lost the capability unevictability of non linear mapping pages, right.
> if so, following additional patch makes more consistent?

[indistinct muttering]

Probably we can remove VM_NONLINEAR perfectly. I've never seen real user of it.





