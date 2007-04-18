Return-Path: <linux-kernel-owner+w=401wt.eu-S1422822AbXDRKuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422822AbXDRKuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422824AbXDRKuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:50:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422822AbXDRKuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:50:03 -0400
Date: Wed, 18 Apr 2007 12:49:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418104955.GB2673@elte.hu>
References: <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com> <20070418090117.GA20764@elte.hu> <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com> <20070418091714.GA23446@elte.hu> <19a3b7a80704180225x3c8d6d60g366126862f05150@mail.gmail.com> <20070418092805.GA23125@elte.hu> <19a3b7a80704180252j72c955bcna5df5cb7057e6756@mail.gmail.com> <20070418101706.GA29031@elte.hu> <20070418103252.GA1621@elte.hu> <20070418103757.GA2673@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418103757.GA2673@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > hm. I've reviewed all uses of demux_lock. ./src/xine-engine/demux.c 
> > does this:
> 
> plus it does this too:
> 
>       pthread_mutex_unlock( &stream->demux_lock );
>       xine_usec_sleep(100000);
>       pthread_mutex_lock( &stream->demux_lock );
> 
> this would explain the nanosleep() strace entries. But the task stuck 
> on demux_lock never gets the unlock event. Weird.

9303 is stuck here on demux_lock:

#0  0xffffe410 in __kernel_vsyscall ()
#1  0x4a2538ce in __lll_mutex_lock_wait () from /lib/libpthread.so.0
#2  0x4a24f71c in _L_mutex_lock_79 () from /lib/libpthread.so.0
#3  0x4a24f24d in pthread_mutex_lock () from /lib/libpthread.so.0
#4  0xb79f64f9 in xine_play () from /usr/lib/libxine.so.1

that mutex related futex is at address 0xb07409e0, but the only sign in 
the strace of that futex being touched is:

9303  futex(0xb07409e0, FUTEX_WAIT, 2, NULL <unfinished ...>

no other event ever happens on futex 0xb07409e0. Other threads dont 
touch it.

Maybe thread 9324 is the owner of that mutex, and it's looping somewhere 
that does xine_xmalloc_aligned(), with the lock held? It did this:

#0  0xffffe410 in __kernel_vsyscall ()
#1  0x4a2539e1 in __lll_mutex_unlock_wake () from /lib/libpthread.so.0
#2  0x4a2506f9 in _L_mutex_unlock_99 () from /lib/libpthread.so.0
#3  0x4a250370 in __pthread_mutex_unlock_usercnt () from /lib/libpthread.so.0
#4  0x4a2506f0 in pthread_mutex_unlock () from /lib/libpthread.so.0
#5  0xb79fce5a in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
#6  0xb7a4b90b in dvd_plugin_free_buffer (buf=0xb0745470) at input_dvd.c:570
#7  0xb7a030a2 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
#8  0x4a24d2db in start_thread () from /lib/libpthread.so.0
#9  0x4a05820e in clone () from /lib/libc.so.6

	Ingo
