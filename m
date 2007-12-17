Return-Path: <linux-kernel-owner+w=401wt.eu-S932406AbXLQTEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbXLQTEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbXLQTEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:04:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287AbXLQTEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:04:10 -0500
Date: Mon, 17 Dec 2007 17:03:39 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Reduce overhead of CONFIG_TIMER_STATS
Message-ID: <20071217190339.GE25780@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20071216212944.GA5128@ghostprotocols.net> <20071217090337.0b1af816@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217090337.0b1af816@laptopd505.fenrus.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 17, 2007 at 09:03:37AM -0800, Arjan van de Ven escreveu:
> On Sun, 16 Dec 2007 19:29:44 -0200
> Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Hi,
> > 	While looking at the pahole output for struct timer_list on
> > recent kernels I noticed that there is a 4 bytes padding on struct
> > timer_list that gets propagated to many structs on 64 bits
> > architectures:
> > 
> > [acme@doppio linux-2.6]$ pahole -C timer_list /tmp/tcp.o.before
> > struct timer_list {
> >         struct list_head      entry;          /*     0    16 */
> >         long unsigned int     expires;        /*    16     8 */
> >         void                  (*function)(long unsigned int); /*
> > 24     8 */ long unsigned int     data;           /*    32     8 */
> >         struct tvec_t_base_s *base;           /*    40     8 */
> >         void *                start_site;     /*    48     8 */
> >         char                  start_comm[16]; /*    56    16 */
> >         /* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
> >         int                   start_pid;      /*    72     4 */
> > 
> >         /* size: 80, cachelines: 2 */
> >         /* padding: 4 */
> >         /* last cacheline: 16 bytes */
> > };
> > [acme@doppio linux-2.6]$
> > 
> > 	So the attached patch reduces the 4 bytes hole overhead of
> > CONFIG_TIMER_STATS on 64bit architectures by shrinking the field for
> > the process name by 4 bytes.
> > 
> > 	Statistically this doesn't affects that many process names as
> > most are less than 12 bytes. As CONFIG_TIMER_STATS is enabled at least
> > on fedora kernels I think that we can, with this patch, still reap the
> > benefits of powertopping.
> 
> I'm still worried that this means that PowerTOP will end up displaying shortened names..
> it's already sometimes tricky to know who's guilty at 16... at 12 I fear it just gets worse.
> Isn't there some other reorder that you can do to still get rid of the hole?

Nope. As shown above there is no other hole that we can conbine with the
4 bytes padding on struct timer_list.

<brainfarting>
What we could do, perhaps, would be to struct start_comm to be a pointer
and store the strings in a list, refcounted, so instead of 16 or 12
bytes we would use 8, but would incur in some CPU overhead definetely
bigger than a simple memcpy, but that would reduce even further the
memory footprint.

But the hole would still be there, as it would be sizeof(void *) +
sizeof(start_pid) :-)
</>

- Arnaldo
