Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZCKQwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZCKQwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZCKQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:51:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbZCKQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:51:50 -0400
Date: Wed, 11 Mar 2009 09:48:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: graff yang <graff.yang@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, gyang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] Blackfin Serial Driver: use barrier instead of 
 cpu_relax for Blackfin SMP like patch
Message-Id: <20090311094823.38ec1e17.akpm@linux-foundation.org>
In-Reply-To: <7d86d44a0903110250l9bcccd7led5558068f153522@mail.gmail.com>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-3-git-send-email-cooloney@kernel.org>
	<20090306143756.738db0ee.akpm@linux-foundation.org>
	<1236679631.5183.72.camel@dy>
	<8bd0f97a0903100325k6cbcf73ek8e5f3723b2c4bb0a@mail.gmail.com>
	<20090310094810.2ffe1f63.akpm@linux-foundation.org>
	<7d86d44a0903110250l9bcccd7led5558068f153522@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 17:50:21 +0800 graff yang <graff.yang@gmail.com> wrote:

> On Wed, Mar 11, 2009 at 12:48 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 10 Mar 2009 06:25:08 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:
> >
> > > On Tue, Mar 10, 2009 at 06:07, gyang wrote:
> > > > On Fri, 2009-03-06 at 14:37 -0800, Andrew Morton wrote:
> > > >> On Fri, __6 Mar 2009 14:42:44 +0800
> > > >> Bryan Wu <cooloney@kernel.org> wrote:
> > > >>
> > > >> > From: Graf Yang <graf.yang@analog.com>
> > > >> >
> > > >> > We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
> > > >> > data cache flush function which will count it to a per-cpu counter.
> > > >> > If this serial function is called too early, the per-cpu data area have
> > > >> > not been initialized, this call will cause crash.
> > > >>
> > > >> That's a bug in blackfin architecture support. __The kernel should be
> > > >> able to call cpu_relax() at any time, surely. __It's a very low-level
> > > >> and simple thing.
> > > >>
> > > >> > So we'd like to use barrier() instead of cpu_relax().
> > > >> >
> > > >>
> > > >> barrier() is purely a compiler concept. __We might as well just remove
> > > >> the cpu_relax() altogether.
> > > >
> > > > Do you mean remove cpu_relax(), and either not add barrier() here?
> > >
> > > afaik, early printk all runs before SMP is setup, so having it be a
> > > 100% busy wait is fine
> >
> > No, blackfin is busted, please fix this bug in blackfin core.
> >
> > What happens if core kernel code decides to run cpu_relax() prior to
> > initialising per-cpu data?
> 
> cpu_relax() will call smp_mb(), and it need to invalidate data-cache
> in blackfin smp-like kernel,
> the cache flush number is increased and recorded into a per-cpu data.
> 
> When cpu_relax() is called from early-printk functions, the per-cpu
> data areas have not
> been initialized.

Right.  And we've demonstrated here that this was a bad idea.

So I suggest that the blackfin maintainers delete that code.

If it's really valuable (which I doubt) then it could be reimplemented
via a statically-allocated array of longs and local_irq_save()
protection.  Or a statically allocated array of atomic_long_t's.

