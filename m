Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYBIR1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYBIR1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbYBIR1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:27:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbYBIR1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:27:14 -0500
Date: Sat, 9 Feb 2008 12:27:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] kgdb: core API and gdb protocol handler
Message-ID: <20080209172713.GD15568@infradead.org>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 07:35:07AM -0600, jason.wessel@windriver.com wrote:
> index 0000000..24e0b6c
> --- /dev/null
> +++ b/include/asm-generic/kgdb.h
> @@ -0,0 +1,105 @@
> +/*
> + * include/asm-generic/kgdb.h

Please don't mention the file name in the top-of-file comments.  This
information is redundant and will easily get out of date when moving
files around or copying them.  Note that this applies to basically
any file in this patch.

> +#ifdef CONFIG_X86
> +/**
> + *	kgdb_skipexception - Bail of of KGDB when we've been triggered.
> + *	@exception: Exception vector number
> + *	@regs: Current &struct pt_regs.
> + *
> + *	On some architectures we need to skip a breakpoint exception when
> + *	it occurs after a breakpoint has been removed.
> + */
> +int kgdb_skipexception(int exception, struct pt_regs *regs);
> +#else
> +static inline int kgdb_skipexception(int exception, struct pt_regs *regs)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#if defined(CONFIG_X86)

arch ifdefs don't belong into an asm-generic/ file.  Please have a
proper asm-x86/kgdb.h that defines these things.

> +/**
> + *	kgdb_post_master_code - Save error vector/code numbers.
> + *	@regs: Original pt_regs.
> + *	@e_vector: Original error vector.
> + *	@err_code: Original error code.
> + *
> + *	This is needed on architectures which support SMP and KGDB.
> + *	This function is called after all the slave cpus have been put
> + *	to a know spin state and the master CPU has control over KGDB.
> + */
> +extern void kgdb_post_master_code(struct pt_regs *regs, int e_vector,
> +				  int err_code);

Kerneldoc comments don't belong above the prototype of a function but
the function body.

> +#ifdef CONFIG_KGDB_ARCH_HAS_SHADOW_INFO
> +/**
> + *	kgdb_shadowinfo - Get shadowed information on @threadid.
> + *	@regs: The &struct pt_regs of the current process.
> + *	@buffer: A buffer of %BUFMAX size.
> + *	@threadid: The thread id of the shadowed process to get information on.
> + */
> +extern void kgdb_shadowinfo(struct pt_regs *regs, char *buffer,
> +			    unsigned threadid);

I don't really thing this belongs into an asm-generic header, again.
ARchitectures having shadow info should just provide this in their
own asm-foo/kgdb.h.  Or better yet just kill it for the first
submission.

> +struct debuggerinfo_struct {
> +	void			*debuggerinfo;
> +	struct task_struct	*task;
> +} kgdb_info[NR_CPUS];

shouldn't this use per-cpu data?  Or is that in some way to
fragile for a debugger?

> +/* reboot notifier block */
> +static struct notifier_block kgdb_reboot_notifier = {
> +	.notifier_call		= kgdb_notify_reboot,
> +	.next			= NULL,
> +	.priority		= INT_MAX,
> +};

No need to initialize fields to 0 or NULL in static variables.

> +{
> +	if ((ch >= 'a') && (ch <= 'f'))
> +		return ch - 'a' + 10;
> +	if ((ch >= '0') && (ch <= '9'))
> +		return ch - '0';
> +	if ((ch >= 'A') && (ch <= 'F'))
> +		return ch - 'A' + 10;

lots of superflous braces.  More of them later in this file
in the same style.

> +#ifdef __BIG_ENDIAN
> +		*buf++ = hexchars[(tmp_s >> 12) & 0xf];
> +		*buf++ = hexchars[(tmp_s >> 8) & 0xf];
> +		*buf++ = hexchars[(tmp_s >> 4) & 0xf];
> +		*buf++ = hexchars[tmp_s & 0xf];
> +#else
> +		*buf++ = hexchars[(tmp_s >> 4) & 0xf];
> +		*buf++ = hexchars[tmp_s & 0xf];
> +		*buf++ = hexchars[(tmp_s >> 12) & 0xf];
> +		*buf++ = hexchars[(tmp_s >> 8) & 0xf];
> +#endif

This is really ugly, but I don't really know a good way around it
either.

> +	if (arch_kgdb_ops.shadowth &&
> +			ks->kgdb_usethreadid >= pid_max + num_online_cpus()) {

	if (arch_kgdb_ops.shadowth &&
	    ks->kgdb_usethreadid >= pid_max + num_online_cpus()) {

similar odd indentation in a few other spots.

> +menuconfig KGDB
> +	bool "KGDB: kernel debugging with remote gdb"
> +	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64

Why can't this be set in the X86_64 config?

> +	select DEBUG_INFO
> +	select FRAME_POINTER

I think these two would be better as depends on

