Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYGIBII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYGIBII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 21:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYGIBH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 21:07:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:27133 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYGIBHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 21:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,327,1212390000"; 
   d="scan'208";a="406882037"
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
From: Huang Ying <ying.huang@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080708104044.GA15327@elf.ucw.cz>
References: <1215401122.4660.4.camel@caritas-dev.intel.com>
	 <20080707125010.GA21254@elf.ucw.cz>
	 <1215508209.29894.8.camel@caritas-dev.intel.com>
	 <20080708104044.GA15327@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 09:12:42 +0800
Message-Id: <1215565962.16450.8.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel,

On Tue, 2008-07-08 at 12:40 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > @@ -1411,3 +1421,50 @@ static int __init crash_save_vmcoreinfo_
> > > >  }
> > > > 
> > > >  module_init(crash_save_vmcoreinfo_init)
> > > > +
> > > > +/**
> > > > + *   kernel_kexec - reboot the system
> > 
> > > Really?
> > 
> > I will change the comments to reflect the changes to kernel_kexec.
> > 
> > > > + *   Move into place and start executing a preloaded standalone
> > > > + *   executable.  If nothing was preloaded return an error.
> > > > + */
> > > > +int kernel_kexec(void)
> > > > +{
> > > > +     int error = 0;
> > > > +
> > > > +     if (xchg(&kexec_lock, 1))
> > > > +             return -EBUSY;
> > > 
> > > That's quite a strange way to provide a lock. mutex_trylock?
> > 
> > I think this is because kexec_lock is used by crash_kexec() too, which
> > may be called in some extreme environment, such as during panic().
> > 
> > > > +     if (!kexec_image) {
> > > > +             error = -EINVAL;
> > > > +             goto Unlock;
> > > > +     }
> > > > +
> > > > +     if (kexec_image->preserve_context) {
> > > > +#ifdef CONFIG_KEXEC_JUMP
> > > > +             local_irq_disable();
> > > > +             save_processor_state();
> > > 
> > > #else
> > >         BUG()
> > > 
> > > ...because otherwise you silently do nothing?
> > > 
> > > > +#endif
> > 
> > If CONFIG_KEXEC_JUMP is defined, kexec_image->preserve_context will
> > always be 0. So current code is safe. Here, #ifdef is used to resolve
> > the dependency issue. For example, save_processor_state() may be
> > undefined if CONFIG_KEXEC_JUMP is not defined.
> 
> Move the #ifdef outside the if (), then, so this is clear?

I think this is reasonable, I will do it.

> Actually, if preserve_context is always zero in !KEXEC_JUMP case, it
> might make sense to remove whole variable...

I think this will add too many #ifndef CONFIG_KEXEC_JUMP ... #endif that
is necessary. The memory and performance gain is too little to
compensate the code readability reduction.

Best Regards,
Huang Ying


