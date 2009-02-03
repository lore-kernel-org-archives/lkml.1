Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZBCPBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZBCPBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZBCPB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:01:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39992 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZBCPBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:01:25 -0500
Date: Tue, 3 Feb 2009 16:01:12 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090203150111.GA20323@random.random>
References: <20090128213322.GA15789@kroah.com> <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com> <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090130061714.GC31209@kroah.com> <20090202220856.GY20323@random.random> <20090203035012.GC1867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203035012.GC1867@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 07:50:12PM -0800, Greg KH wrote:
> On Mon, Feb 02, 2009 at 11:08:56PM +0100, Andrea Arcangeli wrote:
> > Hi Greg!
> > 
> > > Thanks for the pointers, I'll go read the thread and follow up there.
> > 
> > If you also run into this final fix is attached below. Porting to
> > mainline is a bit hard because of gup-fast... Perhaps we can use mmu
> > notifiers to fix gup-fast... need to think more about it then I'll
> > post something.
> > 
> > Please help testing the below on pre-gup-fast kernels, thanks!
> 
> Thanks a lot for the patch, I'll try this out tomorrow.

before testing I recommend to make this change:

-       if ((flags & FOLL_WRITE) && PageAnon(page) && !PageGUP(page))
+	if (PageAnon(page) && !PageGUP(page))

If gup triggers cow, gup clears FOLL_WRITE from foll_flags before
calling follow_page again, I think that's why it didn't work right for
everyone, it just couldn't work right if FOLL_WRITE was going away
before the last follow_page run. I wanted to set PG_gup only for
gup(write=1) and not for gup(write=0) but that optimization that
clears FOLL_WRITE prevents the above to work right, so the simple
solution is to always set PG_gup, it won't make a big difference.

I'm looking at the hugetlb cow before posting an update...
