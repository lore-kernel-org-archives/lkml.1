Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYFJHl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYFJHl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYFJHlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:41:49 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:42972 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750859AbYFJHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:41:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=b/lvNqfsVWjcVge4PG57RN3hyubCO69ZMVhJpbK+Ki5GM0HQ138r5vbATzqoCNUiQHIxBSkJOBZ+VRJ556WNrBKvIYJS3NALXoKBbV49xv9VDW9tv1i7T9SK6ds2imBzdm68jcBERqOoQQ1NVfmIKrm9Cdd9QvLOryRTvCiqW6I=  ;
X-YMail-OSG: P5YbiVEVM1lNbx.p5.TA82LYdgbhsJ6YspnWBq1kTV0OGmxC5qzOfvjtvUm9.VvKUghTS3ER92mitaVez49_mzBO6tCJK1xn7xAaYYJtmcfakIgIyQi5IsPTUHuqephRV.4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Isaku Yamahata <yamahata@valinux.co.jp>
Subject: Re: [PATCH] xen: Use wmb instead of rmb in xen_evtchn_do_upcall().
Date: Tue, 10 Jun 2008 17:41:39 +1000
User-Agent: KMail/1.9.5
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com,
       Samuel Thibault <samuel.thibault@eu.citrix.com>
References: <20080610073532.GG24381%yamahata@valinux.co.jp>
In-Reply-To: <20080610073532.GG24381%yamahata@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101741.39871.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 17:35, Isaku Yamahata wrote:
> This patch is ported one from 534:77db69c38249 of linux-2.6.18-xen.hg.
> Use wmb instead of rmb to enforce ordering between
> evtchn_upcall_pending and evtchn_pending_sel stores
> in xen_evtchn_do_upcall().

There are a whole load of places in the kernel that should be using
smp_ variants of memory barriers. This seemed to me like one of them,
but I could be wrong.

Also, if you do that can you get rid of the ifdef? If it really *really*
mattered, we could introduce smp_mb before/after xchg... but if you
use smp_wmb anyway then it definitely does not matter because that is a
noop on x86.

Thanks,
Nick

>
 Cc: Samuel Thibault <samuel.thibault@eu.citrix.com>
> Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
> ---
>  drivers/xen/events.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 73d78dc..332dd63 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -529,7 +529,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>
>  #ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86.
> */ /* Clear master flag /before/ clearing selector flag. */
> -		rmb();
> +		wmb();
>  #endif
>  		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
>  		while (pending_words != 0) {
