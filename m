Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXBKC4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXBKC4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 21:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXBKC4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 21:56:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35936 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXBKC4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 21:56:11 -0500
Date: Sat, 10 Feb 2007 18:55:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: William Cohen <wcohen@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Size of 2.6.20 task_struct on x86_64 machines
In-Reply-To: <20070211002020.GA6849@redhat.com>
Message-ID: <Pine.LNX.4.64.0702101853140.8424@woody.linux-foundation.org>
References: <45CB4C55.4070902@redhat.com> <20070211002020.GA6849@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Feb 2007, Dave Jones wrote:
> 
> Shrink the held_lock struct by using bitfields.
> This shrinks task_struct on lockdep enabled kernels by 480 bytes.

Are we sure that there are no users that depend on accessing the different 
fields under different locks?

Having them as separate "int" fields means that they don't have any 
interaction, and normal cache coherency will "just work". Once they are 
fields in the same word in memory, updating one field automatically will 
do a read-write cycle on the other fields, and if _they_ are updated by 
interrupts or other CPU's at the same time, a write can get lost..

So I'd like this to be ack'ed by Ingo.

Ingo?

		Linus
---
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index ea097dd..ba81cce 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -175,11 +175,11 @@ struct held_lock {
>  	 * The following field is used to detect when we cross into an
>  	 * interrupt context:
>  	 */
> -	int				irq_context;
> -	int				trylock;
> -	int				read;
> -	int				check;
> -	int				hardirqs_off;
> +	unsigned char irq_context:1;
> +	unsigned char trylock:1;
> +	unsigned char read:2;
> +	unsigned char check:1;
> +	unsigned char hardirqs_off:1;
>  };
>  
>  /*
> 
> -- 
> http://www.codemonkey.org.uk
> 
