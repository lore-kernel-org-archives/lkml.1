Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbYBTVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbYBTVMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYBTVMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:12:42 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39229 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYBTVMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:12:41 -0500
Subject: Re: [PATCH 28/30] r/o bind mounts: track numbers of writers to
	mounts
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, akpm@osdl.org
In-Reply-To: <E1JR8a0-0003sT-8d@pomaz-ex.szeredi.hu>
References: <20080215223721.9E0A088A@kernel>
	 <20080215223759.6B1F044A@kernel>  <E1JR8a0-0003sT-8d@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 13:12:20 -0800
Message-Id: <1203541940.29823.38.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-18 at 17:10 +0100, Miklos Szeredi wrote:
> 
> > +     /*
> > +      * We don't have to hold all of the locks at the
> > +      * same time here because we know that we're the
> > +      * last reference to mnt and that no new writers
> > +      * can come in.
> > +      */
> > +     for_each_possible_cpu(cpu) {
> > +             struct mnt_writer *cpu_writer = &per_cpu(mnt_writers, cpu);
> > +             if (cpu_writer->mnt != mnt)
> > +                     continue;
> > +             spin_lock(&cpu_writer->lock);
> > +             atomic_add(cpu_writer->count, &mnt->__mnt_writers);
> > +             cpu_writer->count = 0;
> 
> I think you should also add a
> 
>                 cpu_writer->mnt = NULL;
> 
> here.  It's not a bug, but I had to think a bit about why it's not a
> bug.

Yeah, I kinda copied the code from __clear_mnt_count() where keeping
->mnt is actually a mini optimization.  But, there is certainly no
chance of that mnt popping up again after a __mntput(), so I clear it in
there now.  I also added a comment explaining.

-- Dave

