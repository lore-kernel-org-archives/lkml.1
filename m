Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYGGRA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYGGRA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYGGRAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:00:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52035 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbYGGRA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:00:29 -0400
Date: Mon, 7 Jul 2008 14:50:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Message-ID: <20080707125010.GA21254@elf.ucw.cz>
References: <1215401122.4660.4.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215401122.4660.4.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The patch looks mostly ok to me. (Perhaps there's time to split it
into smaller chunks?)

You can add Acked-by: Pavel Machek <pavel@suse.cz> to it, I guess.


> This patch provides an enhancement to kexec/kdump. It implements
> the following features:
> 
> - Backup/restore memory used by the original kernel before/after
>   kexec.
> 
> - Save/restore CPU state before/after kexec.
> 
> The features of this patch can be used as a general method to call
> program in physical mode (paging turning off). This can be used to
> call BIOS code under Linux.
> 
> 
> kexec-tools needs to be patched to support kexec jump. The patches and
> the precompiled kexec can be download from the following URL:
> 
>        source: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-src_git_kh10.tar.bz2
>        patches: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-patches_git_kh10.tar.bz2
>        binary: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec_git_kh10
> 
> 
> Usage example of calling some physical mode code and return:

> @@ -98,16 +101,24 @@ int machine_kexec_prepare(struct kimage 
>   */
>  void machine_kexec_cleanup(struct kimage *image)
>  {
> +	if (nx_enabled)
> +		set_pages_nx(image->control_code_page, 1);
>  }

, 0 ? (setup and cleanup were same, which is strange).



> @@ -1411,3 +1421,50 @@ static int __init crash_save_vmcoreinfo_
>  }
>  
>  module_init(crash_save_vmcoreinfo_init)
> +
> +/**
> + *	kernel_kexec - reboot the system

Really?

> + *	Move into place and start executing a preloaded standalone
> + *	executable.  If nothing was preloaded return an error.
> + */
> +int kernel_kexec(void)
> +{
> +	int error = 0;
> +
> +	if (xchg(&kexec_lock, 1))
> +		return -EBUSY;

That's quite a strange way to provide a lock. mutex_trylock?


> +	if (!kexec_image) {
> +		error = -EINVAL;
> +		goto Unlock;
> +	}
> +
> +	if (kexec_image->preserve_context) {
> +#ifdef CONFIG_KEXEC_JUMP
> +		local_irq_disable();
> +		save_processor_state();

#else
	BUG()

...because otherwise you silently do nothing?

> +#endif
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
