Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZCKJue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZCKJue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZCKJuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:50:25 -0400
Received: from mail-gx0-f167.google.com ([209.85.217.167]:44523 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZCKJuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YJtcfzGgJlCkEh0MGmmRsjFs0DYtaxhiXdRGyMo1Wryx7yRy6vlBJHN0/p+QtfXnlZ
         /ALIMapiOZgGYglcYJSNTZVh7cSPwnIUuFBsfw0LYh7L8g6q9wcg18aUlhGi8a0ygrYd
         lt3HgvR4XQ756egvV0L/rSG4h98mgakNyX074=
MIME-Version: 1.0
In-Reply-To: <20090310094810.2ffe1f63.akpm@linux-foundation.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	 <1236321780-28718-3-git-send-email-cooloney@kernel.org>
	 <20090306143756.738db0ee.akpm@linux-foundation.org>
	 <1236679631.5183.72.camel@dy>
	 <8bd0f97a0903100325k6cbcf73ek8e5f3723b2c4bb0a@mail.gmail.com>
	 <20090310094810.2ffe1f63.akpm@linux-foundation.org>
Date: Wed, 11 Mar 2009 17:50:21 +0800
Message-ID: <7d86d44a0903110250l9bcccd7led5558068f153522@mail.gmail.com>
Subject: Re: [PATCH 02/18] Blackfin Serial Driver: use barrier instead of 
	cpu_relax for Blackfin SMP like patch
From: graff yang <graff.yang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, gyang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 12:48 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 10 Mar 2009 06:25:08 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:
>
> > On Tue, Mar 10, 2009 at 06:07, gyang wrote:
> > > On Fri, 2009-03-06 at 14:37 -0800, Andrew Morton wrote:
> > >> On Fri,  6 Mar 2009 14:42:44 +0800
> > >> Bryan Wu <cooloney@kernel.org> wrote:
> > >>
> > >> > From: Graf Yang <graf.yang@analog.com>
> > >> >
> > >> > We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
> > >> > data cache flush function which will count it to a per-cpu counter.
> > >> > If this serial function is called too early, the per-cpu data area have
> > >> > not been initialized, this call will cause crash.
> > >>
> > >> That's a bug in blackfin architecture support.  The kernel should be
> > >> able to call cpu_relax() at any time, surely.  It's a very low-level
> > >> and simple thing.
> > >>
> > >> > So we'd like to use barrier() instead of cpu_relax().
> > >> >
> > >>
> > >> barrier() is purely a compiler concept.  We might as well just remove
> > >> the cpu_relax() altogether.
> > >
> > > Do you mean remove cpu_relax(), and either not add barrier() here?
> >
> > afaik, early printk all runs before SMP is setup, so having it be a
> > 100% busy wait is fine
>
> No, blackfin is busted, please fix this bug in blackfin core.
>
> What happens if core kernel code decides to run cpu_relax() prior to
> initialising per-cpu data?

cpu_relax() will call smp_mb(), and it need to invalidate data-cache
in blackfin smp-like kernel,
the cache flush number is increased and recorded into a per-cpu data.

When cpu_relax() is called from early-printk functions, the per-cpu
data areas have not
been initialized.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
-Graff
