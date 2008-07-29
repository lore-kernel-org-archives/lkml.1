Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYG2CC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYG2CC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYG2CCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:02:15 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:39205 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752068AbYG2CCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:02:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x6fV1YUbKgT1IzJlubM+07alraE5A3d+Bx12fCW4sSLnEanOas0HYEy9ztgvW6enHsSkqnaqosLCjjCR1OVwcDqf2BaLBJquSQt4zCSTmjJL6w8l4UC7OxF/sgAi5ddCU4wb4vGSnF5sRFBTzacdEBf43SuEuqNETO8vnZ8rJuU=  ;
X-YMail-OSG: DTCuOpAVM1nyXg5J86uiN.6t0eu3c5GnrRJNM3qdj.BneSPp61GVvxW66SKc_nOZ2BKnCD_HrqlK10vEbYcYZhF1U800IIB.JI8EYLRhjxXCqppvBO5dSppntdihVqSwxBQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH] - GRU Driver V3 fixes to resolve code review comments
Date: Tue, 29 Jul 2008 12:02:01 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, npiggin@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080728200559.GA26689@sgi.com>
In-Reply-To: <20080728200559.GA26689@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291202.01991.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 06:05, Jack Steiner wrote:

> Index: linux/drivers/misc/sgi-gru/grutlbpurge.c
> ===================================================================
> --- linux.orig/drivers/misc/sgi-gru/grutlbpurge.c	2008-07-28
> 14:52:26.000000000 -0500 +++
> linux/drivers/misc/sgi-gru/grutlbpurge.c	2008-07-28 14:52:54.000000000
> -0500 @@ -242,7 +242,9 @@ static void gru_invalidate_range_end(str
>  	struct gru_mm_struct *gms = container_of(mn, struct gru_mm_struct,
>  						 ms_notifier);
>
> -	atomic_dec(&gms->ms_range_active);
> +	/* ..._and_test() provides needed barrier */
> +	(void)atomic_dec_and_test(&gms->ms_range_active);
> +
>  	wake_up_all(&gms->ms_wait_queue);

What about

if (atomic_dec_and_test())
    wake_up_all()
?

Also, I would prefer either a comment to say why the increment of
ms_range_active is safe, or an smp_mb__after_atomic_inc() for it too.
