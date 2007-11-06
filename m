Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbXKGAIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbXKGAIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbXKGAIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:08:11 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:23160 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754412AbXKGAIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:08:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Q2OYuU16BdNf5KXkx7eJtIvCAT6TY1Jmk3nmpIiRtpQsQxd051lyr+9gLauk68LeBvi4Tel/0Vdz5aDpWKPlVN7Q9Jma63uK1iCMrBngrHodnwS67WWjiH/jGaGjK+26T/3x61BVutCQ/XWdgmfbXp3famUJBgj6iEVyutz0wco=  ;
X-YMail-OSG: AjymKVMVM1lTJQZ4yXUWwec8ark.cmCl6cdCbvPiaXW3D8CgENiuZBvD4DZrN2eWBJa7eWKwrg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: VM/networking crash cause #1: page allocation failure (order:1, GFP_ATOMIC)
Date: Wed, 7 Nov 2007 09:01:17 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071105174214.GA10729@janus>
In-Reply-To: <20071105174214.GA10729@janus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711070901.17839.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 November 2007 04:42, Frank van Maarseveen wrote:
> For quite some time I'm seeing occasional lockups spread over 50 different
> machines I'm maintaining. Symptom: a page allocation failure with order:1,
> GFP_ATOMIC, while there is plenty of memory, as it seems (lots of free
> pages, almost no swap used) followed by a lockup (everything dead). I've
> collected all (12) crash cases which occurred the last 10 weeks on 50
> machines total (i.e. 1 crash every 41 weeks on average). The kernel
> messages are summarized to show the interesting part (IMO) they have
> in common. Over the years this has become the crash cause #1 for stable
> kernels for me (fglrx doesn't count ;).
>
> One note: I suspect that reporting a GFP_ATOMIC allocation failure in an
> network driver via that same driver (netconsole) may not be the smartest
> thing to do and this could be responsible for the lockup itself. However,
> the initial page allocation failure remains and I'm not sure how to
> address that problem.

It isn't unexpected. If an atomic allocation doesn't have enough memory,
it kicks off kswapd to start freeing memory for it. However, it cannot
wait for memory to become free (it's GFP_ATOMIC), so it has to return
failure. GFP_ATOMIC allocation paths are designed so that the kernel can
recover from this situation, and a subsequent allocation will have free
memory.

Probably in production kernels we should default to only reporting this
when page reclaim is not making any progress.


> I still think the issue is memory fragmentation but if so, it looks
> a bit extreme to me: One system with 2GB of ram crashed after a day,
> merely running a couple of TCP server programs. All systems have either
> 1 or 2GB ram and at least 1G of (merely unused) swap.

You can reduce the chances of it happening by increasing
/proc/sys/vm/min_free_kbytes.

