Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYH2XgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYH2XgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYH2Xf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:35:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYH2Xf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:35:56 -0400
Date: Fri, 29 Aug 2008 16:35:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Korty <joe.korty@ccur.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shrink printk timestamp field
Message-Id: <20080829163540.634e86d9.akpm@linux-foundation.org>
In-Reply-To: <20080827151759.GA10678@tsunami.ccur.com>
References: <20080827151759.GA10678@tsunami.ccur.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008 11:17:59 -0400
Joe Korty <joe.korty@ccur.com> wrote:

> Shrink the printk timestamp field.
> 
> Keep the printk timestamp from occupying more of the
> scarce, 80-column console line space than it really needs.
> 
> We eliminate the excessive whitespace the field added to
> the line, and reduce timestamp precision from six digits
> (usecs) to three digits (msecs).  msecs seems adequate
> for the purpose of tracking boot sequence timing issues.
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
> Index: 2.6.27-rc4-git4/kernel/printk.c
> ===================================================================
> --- 2.6.27-rc4-git4.orig/kernel/printk.c	2008-08-26 18:23:03.000000000 -0400
> +++ 2.6.27-rc4-git4/kernel/printk.c	2008-08-26 18:23:49.000000000 -0400
> @@ -739,9 +739,9 @@
>  
>  				t = cpu_clock(printk_cpu);
>  				nanosec_rem = do_div(t, 1000000000);
> -				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
> +				tlen = sprintf(tbuf, "[%3lu.%03lu] ",
>  						(unsigned long) t,
> -						nanosec_rem / 1000);
> +						nanosec_rem / 1000000);
>  
>  				for (tp = tbuf; tp < tbuf + tlen; tp++)
>  					emit_log_char(*tp);

This is a significant loss in utility.

[   16.817285] md: Autodetecting RAID arrays.
[   16.817288] md: Scanned 0 and added 0 devices.
[   16.817290] md: autorun ...
[   16.817292] md: ... autorun DONE.

This not-terribly-fast machine can emit printks into the log buffer
within two microseconds.  That's a pretty useful ad-hoc timing
factility.

This patch will reduce the precision by a factor of five hundred.
