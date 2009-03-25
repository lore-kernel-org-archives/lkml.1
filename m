Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZCYT25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZCYT25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZCYT2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:28:48 -0400
Received: from colo.lackof.org ([198.49.126.79]:42362 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbZCYT2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:28:47 -0400
Date: Wed, 25 Mar 2009 13:28:29 -0600
From: dann frazier <dannf@debian.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 2/2] MIPS: o32: Get rid of useless wrapper for llseek
Message-ID: <20090325192828.GA31578@colo.lackof.org>
References: <20090325001555.GA1357@linux-mips.org> <20090325182905.5fbca9df@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325182905.5fbca9df@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 06:29:05PM +0100, Heiko Carstens wrote:
> On Wed, 25 Mar 2009 01:15:55 +0100
> Ralf Baechle <ralf@linux-mips.org> wrote:
> 
> > Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> > 
> >  arch/mips/kernel/linux32.c     |    7 -------
> >  arch/mips/kernel/scall64-o32.S |    2 +-
> >  2 files changed, 1 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
> > index 49aac6e..ab2da41 100644
> > --- a/arch/mips/kernel/linux32.c
> > +++ b/arch/mips/kernel/linux32.c
> > @@ -133,13 +133,6 @@ SYSCALL_DEFINE4(32_ftruncate64, unsigned long, fd, unsigned long, __dummy,
> >  	return sys_ftruncate(fd, merge_64(a2, a3));
> >  }
> > 
> > -SYSCALL_DEFINE5(32_llseek, unsigned long, fd, unsigned long, offset_high,
> > -	unsigned long, offset_low, loff_t __user *, result,
> > -	unsigned long, origin)
> > -{
> > -	return sys_llseek(fd, offset_high, offset_low, result, origin);
> > -}
> > -
> 
> Ah.. this hunk seems to be the origin of the bug. git commit
> dbda6ac0897603f6c6dfadbbc37f9882177ec7ac "MIPS: CVE-2009-0029: Enable
> syscall wrappers." contains this:
> 
> -asmlinkage int sys32_llseek(unsigned int fd, unsigned int offset_high,
> -			    unsigned int offset_low, loff_t __user * result,
> -			    unsigned int origin)
> +SYSCALL_DEFINE5(32_llseek, unsigned long, fd, unsigned long, offset_high,
> +	unsigned long, offset_low, loff_t __user *, result,
> +	unsigned long, origin)
> 
> Here you converted offset_low from unsigned int to unsigned long. Hence
> you lost the clearing of the upper 32 bits. That would explain the bug.
> Any chance the process where the bug was seen was a compat process?

$ file /sbin/e2fsck 
/sbin/e2fsck: ELF 32-bit MSB executable, MIPS, MIPS-I version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.8, with unknown capability 0x41000000 = 0xf676e75, stripped

> Patch below would probably fix it.

This patch works for me on the aforementioned Debian system.

> Btw. there are a lot of int->long conversions in the git commit
> mentioned above. AFAICS all(?) of the conversions are wrong.

> diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
> index 1a86f84..5abcc7f 100644
> --- a/arch/mips/kernel/linux32.c
> +++ b/arch/mips/kernel/linux32.c
> @@ -134,9 +134,9 @@ SYSCALL_DEFINE4(32_ftruncate64, unsigned long, fd, unsigned long, __dummy,
>  	return sys_ftruncate(fd, merge_64(a2, a3));
>  }
>  
> -SYSCALL_DEFINE5(32_llseek, unsigned long, fd, unsigned long, offset_high,
> -	unsigned long, offset_low, loff_t __user *, result,
> -	unsigned long, origin)
> +SYSCALL_DEFINE5(32_llseek, unsigned int, fd, unsigned int, offset_high,
> +		unsigned int, offset_low, loff_t __user *, result,
> +		unsigned int, origin)
>  {
>  	return sys_llseek(fd, offset_high, offset_low, result, origin);
>  }
> 

-- 
dann frazier

