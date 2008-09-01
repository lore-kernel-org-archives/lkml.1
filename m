Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYIAHoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYIAHoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYIAHnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:43:53 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:41944 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751364AbYIAHnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:43:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wpCNd1KJq08qSmqVnJtspQez7+zhbyuM/2pHToauzSVvgn2rjwhygqxhJ31nwjy/NPGcH6pzAPdxqw2o1uGwiEP6uSUnC5a991HIuskTS1wrtivYD4aYuZYwjiqQbG/+hiVGpmm+kbw/ttk1CdBPYgyl4lV+eL1yiN1gRYLzKVY=  ;
X-YMail-OSG: _9ZRZNwVM1mDkXM3kbMWxGkRfGSdu4ymahFeL5wDCiKtEzLOkeUDveN3YpQHa0SGnV6atWPcFkTbdRPJ0G9Rsn2XnOgUiDycADWGhnVuGvbloZHYTwhJSilP3XkIW6qa4EiNXs648y9eR91w98Z3DtZ2
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Date: Mon, 1 Sep 2008 17:43:42 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080831174756.GA25790@balbir.in.ibm.com> <200809011656.45190.nickpiggin@yahoo.com.au> <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011743.42658.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008 17:19, KAMEZAWA Hiroyuki wrote:
> On Mon, 1 Sep 2008 16:56:44 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Monday 01 September 2008 10:01, KAMEZAWA Hiroyuki wrote:
> > > On Sun, 31 Aug 2008 23:17:56 +0530
> > >
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > This is a rewrite of a patch I had written long back to remove struct
> > > > page (I shared the patches with Kamezawa, but never posted them
> > > > anywhere else). I spent the weekend, cleaning them up for
> > > > 2.6.27-rc5-mmotm (29 Aug 2008).
> > >
> > > It's just because I think there is no strong requirements for 64bit
> > > count/mapcount. There is no ZERO_PAGE() for ANON (by Nick Piggin. I add
> > > him to CC.) (shmem still use it but impact is not big.)
> >
> > I think it would be nice to reduce the impact when it is not configured
> > anyway. Normally I would not mind so much, but this is something that
> > many distros will want to enable but fewer users will make use of it.
> >
> > I think it is always a very good idea to try to reduce struct page size.
> > When looking at the performance impact though, just be careful with the
> > alignment of struct page... I actually think it is going to be a
> > performance win in many cases to make struct page 64 bytes.
>
> On 32bit, sizeof(struct page) = 32bytes + 4bytes(page_cgroup)
> On 64bit, sizeof(struct page) = 56bytes + 8bytes(page_cgroup)
> So, 32bit case is a problem.

Right. Well, either one is a problem because we always prefer to have
less things in struct page rather than more ;)


> > If you do that, it might even be an idea to allocate flat arrays with
> > bootmem. It would just be slightly more tricky more tricky to fit this
> > in with the memory model. But that's not a requirement, just an idea
> > for a small optimisation.
>
> If we make mem_res_controller available only under SPARSEMEM, I think we
> can do in very straightfoward way.

That could be a reasonable solution.  Balbir has other concerns about
this... so I think it is OK to try the radix tree approach first.
