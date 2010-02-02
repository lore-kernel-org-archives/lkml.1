Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0BBOh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:37:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab0BBOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:37:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] improve sys_personality for compat architectures
Date: Tue, 2 Feb 2010 15:36:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, davem@davemloft.net, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
References: <20100201185607.GD11045@lst.de>
In-Reply-To: <20100201185607.GD11045@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021536.51928.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19JkMq72sjrHEaBE+h+Y/LBm2t3W10Xc9s9/Uf
 CDS1WsfgU37FfsD2nSIXPY70LasdQHznnmrqafWQdaz5SrhJKP
 3ZHbjUF8PQNsMr/QgAVXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Christoph Hellwig wrote:
> +/*
> + * Get/set the personality.
> + *
> + * Note that we simply return PER_LINUX even if we actually have a 32-bit
> + * task (PER_LINUX32) as this is expected by 32-bit userland.
> + */
>  SYSCALL_DEFINE1(personality, u_long, personality)
>  {
>         u_long old = current->personality;
>  
>         if (personality != 0xffffffff) {
> +               if (personality(old) == PER_LINUX32 &&
> +                   personality == PER_LINUX)
> +                       personality = PER_LINUX32;
>                 set_personality(personality);
>                 if (current->personality != personality)
>                         return -EINVAL;
>         }
>  
> -       return (long)old;
> +       return (long)(old == PER_LINUX32 ? PER_LINUX : old);
>  }

What does this do for a native 64 bit process setting PER_LINUX32?
It looks to me like it could never set it back to the original
value, or am I missing something here?

It's what the arch specific code does already, but it seems a bit
strange anyway.

	Arnd
