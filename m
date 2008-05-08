Return-Path: <linux-kernel-owner+w=401wt.eu-S934085AbYEHWzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085AbYEHWzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762132AbYEHWzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:55:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761588AbYEHWzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:55:37 -0400
Date: Thu, 8 May 2008 15:55:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7
 40% regression with 2.6.26-rc1)
In-Reply-To: <20080508214557.GA13311@elte.hu>
Message-ID: <alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org>
References: <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu>
 <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org> <20080508201956.GA2547@elte.hu> <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
 <20080508214557.GA13311@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Ingo Molnar wrote:
>
>    2512  down <= lock_kernel <= opost <= write_chan <
>    2574  down <= lock_kernel <= write_chan <= tty_write <

Ok. tty write handling. Nasty. But not as nasty as the open/close code, 
perhaps, and maybe we'll get it fixed some day.

In fact, I thought we had fixed most of this already, but hey, I was 
clearly wrong. I assume Alan looks at it occasionally and groans. Alan?

> 
> some other interesting stats. Top wakeups sources:
> 
>   [...]
>    1301  default_wake_function <= __wake_up_common <= __wake_up <= n_tty_receive_buf <= pty_write <= write_chan <
>    2065  wake_up_state <= prepare_signal <= send_signal <= __group_send_sig_info <= group_send_sig_info <= __kill_pgrp_info <

Ok, signals being the top one, but that tty code is pretty high again.

> and here's a few seconds worth of NMI driven readprofile output:
> 
> 216021 sync_page                                3375.3281
> 391888 page_check_address                       1414.7581
> 962212 total                                      0.3039
> 
> system overhead is consistently 20% during this test.
> 
> the page_check_address() overhead is surprising - tons of rmap 
> contention? about 10% wall-clock overhead in that function alone - and 
> this is just on a dual-core box!

No, it's not rmap contention. Your profile hits are just on the actual 
calculations, and it's all data-dependent arithmetic and loads. Some cache 
misses on the page tables, clearly, but it looks like a lot of it is even 
just the plain arithmetic (the imul followed by a data-dependent 'lea' 
instruction).

Some of it is that "page_to_pfn(page)", which involves a nasty division 
(divide by sizeof(struct page)). It gets turned into that shift and 
multiply, but it's still quite expensive with big constants etc.

			Linus
