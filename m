Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbYEGCXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbYEGCXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYEGCXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:23:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55253 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbYEGCXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:23:04 -0400
Date: Wed, 7 May 2008 11:27:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Mika =?UTF-8?B?UGVudHRpbMOk?= <mika.penttila@kolumbus.fi>,
       Tony Battersby <tonyb@cybernetics.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] more ZERO_PAGE handling ( was 2.6.24 regression:
 deadlock on coredump of big process)
Message-Id: <20080507112708.623bc8fd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080507111404.871b8990.kamezawa.hiroyu@jp.fujitsu.com>
References: <4815E932.1040903@cybernetics.com>
	<20080429100048.3e78b1ba.kamezawa.hiroyu@jp.fujitsu.com>
	<48172C72.1000501@cybernetics.com>
	<20080430132516.28f1ee0c.kamezawa.hiroyu@jp.fujitsu.com>
	<4817FDA5.1040702@kolumbus.fi>
	<20080430141738.e6b80d4b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080430051932.GD27652@wotan.suse.de>
	<20080430143542.2dcf745a.kamezawa.hiroyu@jp.fujitsu.com>
	<20080430061125.GF27652@wotan.suse.de>
	<20080507111404.871b8990.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 11:14:04 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > >  	pte = *ptep;
> > > -	if (!pte_present(pte))
> > > +	if (!pte_present(pte)) {
> > > +		if (!(flags & FOLL_WRITE) && pte_none(pte)) {
> > > +			pte_unmap_unlock(ptep, ptl);
> > > +			goto null_or_zeropage;
> > > +		}
> > >  		goto unlock;
> > > +	}
> > 
> > Just a small nitpick: I guess you don't need this FOLL_WRITE test because
> > null_or_zeropage will test FOLL_ANON which implies !FOLL_WRITE. It should give
> > slightly smaller code.
> > 
> > Otherwise, looks good to me:
> > 
> Hmm, but 
> 
> do_execve()
>   -> copy_strings()
>        -> get_arg_page()
>             -> get_user_pages()
> 
> can do write-page-fault in ANON (and it's a valid ops.)
> 
> So, I think it's safe not to remove FOLL_WRITE check here.
> 
BTW, in above case, returning ZERO_PAGE() when pgd/pud/pmd is not available is
safe ? (above path is expanding-stack at exec.)

Thanks,
-Kame




