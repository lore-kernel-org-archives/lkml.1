Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXCPJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXCPJQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbXCPJQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:16:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37664 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXCPJQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:16:40 -0400
Date: Fri, 16 Mar 2007 10:15:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 17/26] Xen-paravirt_ops: Add nosegneg capability to the vsyscall page notes
Message-ID: <20070316091552.GH23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232528.407996939@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232528.407996939@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i've Cc:-ed Roland and Ulrich, who should make the call on this one.

* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Add the "nosegneg" fake capabilty to the vsyscall page notes. This is
> used by the runtime linker to select a glibc version which then
> disables negative-offset accesses to the thread-local segment via
> %gs. These accesses require emulation in Xen (because segments are
> truncated to protect the hypervisor address space) and avoiding them
> provides a measurable performance boost.
>
> Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
> Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Acked-by: Zachary Amsden <zach@vmware.com>
> 
> ---
>  arch/i386/kernel/vsyscall-note.S |   28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> ===================================================================
> --- a/arch/i386/kernel/vsyscall-note.S
> +++ b/arch/i386/kernel/vsyscall-note.S
> @@ -23,3 +24,31 @@ 3:	.balign 4;		/* pad out section */			 
>  	ASM_ELF_NOTE_BEGIN(".note.kernel-version", "a", UTS_SYSNAME, 0)
>  	.long LINUX_VERSION_CODE
>  	ASM_ELF_NOTE_END
> +
> +#ifdef CONFIG_XEN
> +/*
> + * Add a special note telling glibc's dynamic linker a fake hardware
> + * flavor that it will use to choose the search path for libraries in the
> + * same way it uses real hardware capabilities like "mmx".
> + * We supply "nosegneg" as the fake capability, to indicate that we
> + * do not like negative offsets in instructions using segment overrides,
> + * since we implement those inefficiently.  This makes it possible to
> + * install libraries optimized to avoid those access patterns in someplace
> + * like /lib/i686/tls/nosegneg.  Note that an /etc/ld.so.conf.d/file
> + * corresponding to the bits here is needed to make ldconfig work right.
> + * It should contain:
> + *	hwcap 0 nosegneg
> + * to match the mapping of bit to name that we give here.
> + */
> +#define NOTE_KERNELCAP_BEGIN(ncaps, mask) \
> +	ASM_ELF_NOTE_BEGIN(".note.kernelcap", "a", "GNU", 2) \
> +	.long ncaps, mask
> +#define NOTE_KERNELCAP(bit, name) \
> +	.byte bit; .asciz name
> +#define NOTE_KERNELCAP_END ASM_ELF_NOTE_END
> +
> +NOTE_KERNELCAP_BEGIN(1, 1)
> +NOTE_KERNELCAP(1, "nosegneg")
> +NOTE_KERNELCAP_END
> +#endif
> +
> 
> -- 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
