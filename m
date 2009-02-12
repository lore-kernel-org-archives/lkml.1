Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbZBLKm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbZBLKm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758670AbZBLKkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:40:36 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:23231 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758647AbZBLKke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:40:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fXZq87XH7F+QVk5n5hIcksUIBQdkkN++/hiAYcdS4qMiWKy40pAzFxyatOZlAJjkLBcArtgG/TPfFnU8qlhA9MJ2XTZhdTesam2itbxdCADAEy0czJ0wvh6kt1oDi9kBQrWMsPJl+MmWaHG7SwhRMK1yT9uS4uY6V3Ul8JDTVw4=  ;
X-YMail-OSG: LXoC.eYVM1l1WfawctluJUSHq.Zm_bfffBNzjBzNjWbZKQjh_OMnU5TZ5fnPkfelNZm4D3r0aKU4zBZV20AS5RLfYdHFeaIp.l1HiR.4xpKzm1XF3YtxbHvTo_egmTLgzoXSiCMW_VFJfKKLf3Kno_SSVKFLgcLz8UhPWtnS6u5BbmmrQmZKJr0z66LIYtVShlwJPht.kx1HOTPMElnXYyr48_Z.hxH_BzQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: miaox@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the unallowed node when memory spread is set
Date: Thu, 12 Feb 2009 21:40:03 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Paul Menage <menage@google.com>, Paul Jackson <pj@usa.net>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       Derek Fults <dfults@sgi.com>
References: <4976D77C.3020107@cn.fujitsu.com> <200902121255.43047.nickpiggin@yahoo.com.au> <4993DD64.2090705@cn.fujitsu.com>
In-Reply-To: <4993DD64.2090705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902122140.03886.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 February 2009 19:27:16 Miao Xie wrote:
> on 2009-2-12 9:55 Nick Piggin wrote:
> > On Thursday 12 February 2009 12:19:11 Paul Menage wrote:
> >> On Wed, Feb 11, 2009 at 4:54 PM, Nick Piggin <nickpiggin@yahoo.com.au>
> >
> > wrote:
> >>> It would be possible, depending on timing, for the allocating thread to
> >>> see either pre or post mems_allowed even if access was fully locked.
> >>
> >> Right - seeing either the pre set or the post set is fine.
> >>
> >>> The only difference is that a partially changed mems_allowed could be
> >>> seen. But what does this really mean? Some combination of the new and
> >>> the old nodes. I don't think this is too much of a problem.
> >>
> >> But if the old and new nodes are disjoint, that could lead to seeing no
> >> nodes.
> >
> > Well we could structure updates as setting all new allowed nodes,
> > then clearing newly disallowed ones.
>
> But it still has the other problem. such as:
> Task1							Task2
> get_page_from_freelist()				while(1) {
> {
> 	for_each_zone_zonelist_nodemask() {
> 								change Task1's mems_allowed
> 		if (!cpuset_zone_allowed_softwall())
> 			goto try_next_zone;
> try_next_zone:
> 		...
> 	}
> }							}
>
> In the extreme case, Task1 will be completely unable to allocate memory
> at worst. At least, it will lead to the delay of allocate pages. Though
> the probability of this case is very low, we have to take into account.

Hmm, but a task with that permission could kill task1 in a number
of ways. Is it really worth worrying about?

