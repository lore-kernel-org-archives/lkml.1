Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbXI1OUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbXI1OUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbXI1OU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:20:28 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:33920 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756166AbXI1OU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:20:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mwUuwu2JrY2ybyOEsFkmsua37A3bjBHwhJypbsql+RqEF2PU8kkNOgP4D5uMyqyZKnC6kX93gAsd+dWJ/VDi+GhC4DNK+qyN0gNI0IAgY9CQBk5WckXJdpUwj9aUUD53Xu5sTAvasY8XfjM4BSsPT/W5LePqu6mW/r110XWULKo=  ;
X-YMail-OSG: xG2R0nEVM1niCBGFYM.fH2FUFEZ7sHfPLLT25syt9bVZvOd.FdYlVZn7eV7o2hm6DLzIzYoMyw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH] writeback: remove unnecessary wait in throttle_vm_writeout()
Date: Fri, 28 Sep 2007 07:49:09 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kumar Gala <galak@kernel.crashing.org>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <390857819.00313@ustc.edu.cn>
In-Reply-To: <390857819.00313@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709280749.09822.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2007 11:50, Fengguang Wu wrote:
> We don't want to introduce pointless delays in throttle_vm_writeout()
> when the writeback limits are not yet exceeded, do we?

I don't think so (ie. I agree with you).
IIRC, Marcelo initially did the throttle_vm_writeout?

> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  mm/page-writeback.c |   18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> --- linux-2.6.23-rc8-mm1.orig/mm/page-writeback.c
> +++ linux-2.6.23-rc8-mm1/mm/page-writeback.c
> @@ -507,16 +507,6 @@ void throttle_vm_writeout(gfp_t gfp_mask
>  	long background_thresh;
>  	long dirty_thresh;
>
> -	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
> -		/*
> -		 * The caller might hold locks which can prevent IO completion
> -		 * or progress in the filesystem.  So we cannot just sit here
> -		 * waiting for IO to complete.
> -		 */
> -		congestion_wait(WRITE, HZ/10);
> -		return;
> -	}
> -
>          for ( ; ; ) {
>  		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
>
> @@ -530,6 +520,14 @@ void throttle_vm_writeout(gfp_t gfp_mask
>  			global_page_state(NR_WRITEBACK) <= dirty_thresh)
>                          	break;
>                  congestion_wait(WRITE, HZ/10);
> +
> +		/*
> +		 * The caller might hold locks which can prevent IO completion
> +		 * or progress in the filesystem.  So we cannot just sit here
> +		 * waiting for IO to complete.
> +		 */
> +		if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO))
> +			break;
>          }
>  }
