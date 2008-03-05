Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYCEQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYCEQ27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYCEQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:28:50 -0500
Received: from n27.bullet.mail.mud.yahoo.com ([68.142.200.142]:24599 "HELO
	n27.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752734AbYCEQ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:28:49 -0500
X-Yahoo-Newman-Id: 326801.61768.bm@omp423.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=kX64GnDytLvxQKQZVIZK1O/y3s7PrAQtmS6IDpF37R/Ki89jhABXroght6AXs36jI1xg6YzO8jaBnwuHMPatQFvoFy/h4RL/OIIg1rjG6pyQmITqo3odFFM7CqC4tlFC15MWLKn1rdaaDqMG24vSNO5YNPOoUHPDGP78q9Ncqjo=  ;
X-YMail-OSG: mJXmu0IVM1lw5akcMvAOn6xK1Yr9TcPODPJUf0cVK67bBG3EVYI6g..Z6MjBwN4dyRudZs23fQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/5] vmalloc: do not check for freed locks on user maps
Date: Thu, 6 Mar 2008 03:28:19 +1100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <20080305154829.185609547@linutronix.de> <20080305155117.447021903@linutronix.de>
In-Reply-To: <20080305155117.447021903@linutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803060328.20349.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 03:03, Thomas Gleixner wrote: 
> User maps do not contain kernel internal objects. No need to check
> them.

Why not? Depends on your definition of kernel internal... and
objects ;)

Drivers could create and manage some objects in this vmalloc
area. They are no longer internal if you map them to userspace,
but I still don't think you want to vunmap it until those
object lifetimes are finished.


> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
>  mm/vmalloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/mm/vmalloc.c
> ===================================================================
> --- linux-2.6.orig/mm/vmalloc.c
> +++ linux-2.6/mm/vmalloc.c
> @@ -382,7 +382,8 @@ static void __vunmap(const void *addr, i
>  		return;
>  	}
>
> -	debug_check_no_locks_freed(addr, area->size);
> +	if (!(area->flags & VM_USERMAP))
> +		debug_check_no_locks_freed(addr, area->size);
>
>  	if (deallocate_pages) {
>  		int i;

