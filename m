Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYAMUiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYAMUiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYAMUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:37:59 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:40001 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYAMUh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:37:58 -0500
Date: Sun, 13 Jan 2008 15:37:33 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt1: macro "put_cpu_var" passed 2 arguments, but
 takes just 1
In-Reply-To: <200801132053.22830.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.58.0801131519410.9934@gandalf.stny.rr.com>
References: <1200250801.9190.7.camel@localhost.localdomain>
 <200801132053.22830.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jan 2008, Mariusz Kozlowski wrote:

> [... snip ...]
>
> @@ -56,12 +64,13 @@ static inline void __quicklist_free(int
>         struct page *page)
>  {
>         struct quicklist *q;
> +       int cpu;
>
> -       q = &get_cpu_var(quicklist)[nr];
> +       q = &get_cpu_var_locked(quicklist, &cpu)[nr];
>         *(void **)p = q->page;
>         q->page = p;
>         q->nr_pages++;
> -       put_cpu_var(quicklist);
> +       put_cpu_var(quicklist, cpu); <------------- should that be put_cpu_var_locked()?
>  }
>

Ouch! <looks at rejs>

*************** static inline void __quicklist_free(int
*** 76,86 ****
  		return;
  	}

- 	q = &get_cpu_var(quicklist)[nr];
  	*(void **)p = q->page;
  	q->page = p;
  	q->nr_pages++;
- 	put_cpu_var(quicklist);
  }

  static inline void quicklist_free(int nr, void (*dtor)(void *), void *pp)
--- 73,83 ----
  		return;
  	}

+ 	q = &get_cpu_var_locked(quicklist, &cpu)[nr];
  	*(void **)p = q->page;
  	q->page = p;
  	q->nr_pages++;
+ 	put_cpu_var_locked(quicklist, cpu);
  }

  static inline void quicklist_free(int nr, void (*dtor)(void *), void *pp)
************

Darn, that was my fault. OK, will release a -rt2 soon.

Thanks,

-- Steve

