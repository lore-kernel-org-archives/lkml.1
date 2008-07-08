Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYGHUcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYGHUcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYGHUbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:31:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33466 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbYGHUbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:31:46 -0400
Date: Tue, 8 Jul 2008 12:40:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Message-ID: <20080708104044.GA15327@elf.ucw.cz>
References: <1215401122.4660.4.camel@caritas-dev.intel.com> <20080707125010.GA21254@elf.ucw.cz> <1215508209.29894.8.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215508209.29894.8.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > @@ -1411,3 +1421,50 @@ static int __init crash_save_vmcoreinfo_
> > >  }
> > > 
> > >  module_init(crash_save_vmcoreinfo_init)
> > > +
> > > +/**
> > > + *   kernel_kexec - reboot the system
> 
> > Really?
> 
> I will change the comments to reflect the changes to kernel_kexec.
> 
> > > + *   Move into place and start executing a preloaded standalone
> > > + *   executable.  If nothing was preloaded return an error.
> > > + */
> > > +int kernel_kexec(void)
> > > +{
> > > +     int error = 0;
> > > +
> > > +     if (xchg(&kexec_lock, 1))
> > > +             return -EBUSY;
> > 
> > That's quite a strange way to provide a lock. mutex_trylock?
> 
> I think this is because kexec_lock is used by crash_kexec() too, which
> may be called in some extreme environment, such as during panic().
> 
> > > +     if (!kexec_image) {
> > > +             error = -EINVAL;
> > > +             goto Unlock;
> > > +     }
> > > +
> > > +     if (kexec_image->preserve_context) {
> > > +#ifdef CONFIG_KEXEC_JUMP
> > > +             local_irq_disable();
> > > +             save_processor_state();
> > 
> > #else
> >         BUG()
> > 
> > ...because otherwise you silently do nothing?
> > 
> > > +#endif
> 
> If CONFIG_KEXEC_JUMP is defined, kexec_image->preserve_context will
> always be 0. So current code is safe. Here, #ifdef is used to resolve
> the dependency issue. For example, save_processor_state() may be
> undefined if CONFIG_KEXEC_JUMP is not defined.

Move the #ifdef outside the if (), then, so this is clear?

Actually, if preserve_context is always zero in !KEXEC_JUMP case, it
might make sense to remove whole variable...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
