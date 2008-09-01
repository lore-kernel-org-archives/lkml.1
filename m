Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYIAG5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYIAG5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYIAG45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:56:57 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:30478 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750977AbYIAG44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:56:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gZ022FaiYgYdmiAFmX9+pBjhY8M4c9QzJVTvRxsBohTHRasHEoB7m5XtsuNeYLk5d1PwdvB/5CGoPCS3yUN1F+Xip9sdiK67EiECppzZjKQX/MjCZkUFQBOZF27i2WuS85JnE20TQjJHm/h6ztBY/lN1khp16phzFeuBH23L5YA=  ;
X-YMail-OSG: b7IOvLUVM1kIiCHsuX954b3EPqa47LymE7ApLWlF5xQAyRwY4BpK_2COFxwRts4VvQaegDslm4.Up.2ggs7_weeqQNIh997nl4Y7nIRStLxszzVndo1d68JyPZtQNiJCnKkBCwTNfp1hBtMd7La54opE
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Date: Mon, 1 Sep 2008 16:56:44 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080831174756.GA25790@balbir.in.ibm.com> <20080901090102.46b75141.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080901090102.46b75141.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011656.45190.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008 10:01, KAMEZAWA Hiroyuki wrote:
> On Sun, 31 Aug 2008 23:17:56 +0530
>
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > This is a rewrite of a patch I had written long back to remove struct
> > page (I shared the patches with Kamezawa, but never posted them anywhere
> > else). I spent the weekend, cleaning them up for 2.6.27-rc5-mmotm (29 Aug
> > 2008).
>
> It's just because I think there is no strong requirements for 64bit
> count/mapcount. There is no ZERO_PAGE() for ANON (by Nick Piggin. I add him
> to CC.) (shmem still use it but impact is not big.)

I think it would be nice to reduce the impact when it is not configured
anyway. Normally I would not mind so much, but this is something that
many distros will want to enable but fewer users will make use of it.

I think it is always a very good idea to try to reduce struct page size.
When looking at the performance impact though, just be careful with the
alignment of struct page... I actually think it is going to be a
performance win in many cases to make struct page 64 bytes.


> > I've tested the patches on an x86_64 box, I've run a simple test running
> > under the memory control group and the same test running concurrently
> > under two different groups (and creating pressure within their groups).
> > I've also compiled the patch with CGROUP_MEM_RES_CTLR turned off.
> >
> > Advantages of the patch
> >
> > 1. It removes the extra pointer in struct page
> >
> > Disadvantages
> >
> > 1. It adds an additional lock structure to struct page_cgroup
> > 2. Radix tree lookup is not an O(1) operation, once the page is known
> >    getting to the page_cgroup (pc) is a little more expensive now.
> >
> > This is an initial RFC for comments
> >
> > TODOs
> >
> > 1. Test the page migration changes
> > 2. Test the performance impact of the patch/approach
> >
> > Comments/Reviews?
>
> plz wait until lockless page cgroup....
>
> And If you don't support radix-tree-delete(), pre-allocating all at boot is
> better.

If you do that, it might even be an idea to allocate flat arrays with
bootmem. It would just be slightly more tricky more tricky to fit this
in with the memory model. But that's not a requirement, just an idea
for a small optimisation.

Thanks,
Nick
