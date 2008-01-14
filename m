Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYANRWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYANRWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYANRWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:22:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:39433 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYANRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:22:15 -0500
Date: Mon, 14 Jan 2008 09:20:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ratn.josh@gmail.com
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Re-organization of PIDMAP_ENTRIES macro expansion
Message-Id: <20080114092035.321a64cc.randy.dunlap@oracle.com>
In-Reply-To: <1200307835.2819.18.camel@life.india.kernelcorp.com>
References: <1200307835.2819.18.camel@life.india.kernelcorp.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 16:20:35 +0530 Ratnadeep Joshi wrote:

> This patch tries to re-organize the macro expansion of PIDMAP_ENTRIES
> (possibly) to a more clear one.
> 
> Thanks,
> - Ratnadeep Joshi
> 
> diff --git a/include/linux/pid_namespace.h
> b/include/linux/pid_namespace.h
> index 1689e28..06e3e99 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -12,7 +12,7 @@ struct pidmap {
>         void *page;
>  };
>  
> -#define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE -
> 1)/PAGE_SIZE/8)
> +#define PIDMAP_ENTRIES         ((PID_MAX_LIMIT - 1)/PAGE_SIZE/8 + 1)
>  
>  struct pid_namespace {
>  	struct kref kref;


I beg to disagree.  There is a very common (idiomatic) way for
doing this kind of calculation and the first/original expression
is in that form, although it's a little difficult to recognize.

This common formula lives in linux/kernel.h:

#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

where n is (AFAIK) numerator and d is divisor.

Example:  One use of this is in linux/bitops.h:

#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)

This macro returns the number of longs that it takes to hold
'nr' bits.  Expanded, it looks like:

nr_longs = (nr_bits + BITS_PER_LONG - 1) / BITS_PER_LONG;

The idiomatic formula handles boundary conditions very nicely.


Now for PIDMAP_ENTRIES, use 8 * PAGE_SIZE as the (d) part of
DIV_ROUND_UP() and you can see that it is done correctly.

---
~Randy
