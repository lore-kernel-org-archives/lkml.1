Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXLQRFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXLQRFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbXLQREw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:04:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48102 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXLQREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:04:52 -0500
Date: Mon, 17 Dec 2007 09:03:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Reduce overhead of CONFIG_TIMER_STATS
Message-ID: <20071217090337.0b1af816@laptopd505.fenrus.org>
In-Reply-To: <20071216212944.GA5128@ghostprotocols.net>
References: <20071216212944.GA5128@ghostprotocols.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007 19:29:44 -0200
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Hi,
> 	While looking at the pahole output for struct timer_list on
> recent kernels I noticed that there is a 4 bytes padding on struct
> timer_list that gets propagated to many structs on 64 bits
> architectures:
> 
> [acme@doppio linux-2.6]$ pahole -C timer_list /tmp/tcp.o.before
> struct timer_list {
>         struct list_head      entry;          /*     0    16 */
>         long unsigned int     expires;        /*    16     8 */
>         void                  (*function)(long unsigned int); /*
> 24     8 */ long unsigned int     data;           /*    32     8 */
>         struct tvec_t_base_s *base;           /*    40     8 */
>         void *                start_site;     /*    48     8 */
>         char                  start_comm[16]; /*    56    16 */
>         /* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
>         int                   start_pid;      /*    72     4 */
> 
>         /* size: 80, cachelines: 2 */
>         /* padding: 4 */
>         /* last cacheline: 16 bytes */
> };
> [acme@doppio linux-2.6]$
> 
> 	So the attached patch reduces the 4 bytes hole overhead of
> CONFIG_TIMER_STATS on 64bit architectures by shrinking the field for
> the process name by 4 bytes.
> 
> 	Statistically this doesn't affects that many process names as
> most are less than 12 bytes. As CONFIG_TIMER_STATS is enabled at least
> on fedora kernels I think that we can, with this patch, still reap the
> benefits of powertopping.

I'm still worried that this means that PowerTOP will end up displaying shortened names..
it's already sometimes tricky to know who's guilty at 16... at 12 I fear it just gets worse.
Isn't there some other reorder that you can do to still get rid of the hole?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
