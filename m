Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYGHJFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYGHJFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYGHJF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:05:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:3753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYGHJFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:05:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,322,1212390000"; 
   d="scan'208";a="350084104"
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
From: Huang Ying <ying.huang@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080707125010.GA21254@elf.ucw.cz>
References: <1215401122.4660.4.camel@caritas-dev.intel.com>
	 <20080707125010.GA21254@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 17:10:09 +0800
Message-Id: <1215508209.29894.8.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel,

On Mon, 2008-07-07 at 20:50 +0800, Pavel Machek wrote:
> Hi!
> 
> The patch looks mostly ok to me. (Perhaps there's time to split it
> into smaller chunks?)
> 
> You can add Acked-by: Pavel Machek <pavel@suse.cz> to it, I guess.

Thank you very much!

[...]
> > @@ -98,16 +101,24 @@ int machine_kexec_prepare(struct kimage
> >   */
> >  void machine_kexec_cleanup(struct kimage *image)
> >  {
> > +     if (nx_enabled)
> > +             set_pages_nx(image->control_code_page, 1);
> >  }
> 
> , 0 ? (setup and cleanup were same, which is strange).

Oh, Yes. That should be 0, I will change it.
> 
> > @@ -1411,3 +1421,50 @@ static int __init crash_save_vmcoreinfo_
> >  }
> > 
> >  module_init(crash_save_vmcoreinfo_init)
> > +
> > +/**
> > + *   kernel_kexec - reboot the system

> Really?

I will change the comments to reflect the changes to kernel_kexec.

> > + *   Move into place and start executing a preloaded standalone
> > + *   executable.  If nothing was preloaded return an error.
> > + */
> > +int kernel_kexec(void)
> > +{
> > +     int error = 0;
> > +
> > +     if (xchg(&kexec_lock, 1))
> > +             return -EBUSY;
> 
> That's quite a strange way to provide a lock. mutex_trylock?

I think this is because kexec_lock is used by crash_kexec() too, which
may be called in some extreme environment, such as during panic().

> > +     if (!kexec_image) {
> > +             error = -EINVAL;
> > +             goto Unlock;
> > +     }
> > +
> > +     if (kexec_image->preserve_context) {
> > +#ifdef CONFIG_KEXEC_JUMP
> > +             local_irq_disable();
> > +             save_processor_state();
> 
> #else
>         BUG()
> 
> ...because otherwise you silently do nothing?
> 
> > +#endif
> 
> Pavel

If CONFIG_KEXEC_JUMP is defined, kexec_image->preserve_context will
always be 0. So current code is safe. Here, #ifdef is used to resolve
the dependency issue. For example, save_processor_state() may be
undefined if CONFIG_KEXEC_JUMP is not defined.

Best Regards,
Huang Ying


