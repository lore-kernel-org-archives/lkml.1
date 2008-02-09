Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYBIP3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYBIP3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYBIP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:29:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48360 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbYBIP3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:29:15 -0500
Date: Sat, 9 Feb 2008 16:29:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] kgdb: core API and gdb protocol handler
Message-ID: <20080209152920.GA7492@uranus.ravnborg.org>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason.

> --- /dev/null
> +++ b/kernel/kgdb.c
> +
> +struct debuggerinfo_struct {
> +	void			*debuggerinfo;
> +	struct task_struct	*task;
> +} kgdb_info[NR_CPUS];
static?

> +
> +/* Is a host GDB connected to us? */
> +int				kgdb_connected;
> +EXPORT_SYMBOL_GPL(kgdb_connected);
Drop additional spaces.
Add kernel-doc comments explaining the usage.

> +/* All the KGDB handlers are installed */
> +int				kgdb_io_module_registered;
static? drop spaces.

> +
> +/* Guard for recursive entry */
> +static int			exception_level;
drop spaces. In more places below - but they are obvious.

> +struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
> +	[0 ... KGDB_MAX_BREAKPOINTS-1] = { .state = BP_UNDEFINED }
> +};
static?

> +
> +extern int pid_max;

extern must be moved to a .h file.

> +atomic_t			kgdb_setting_breakpoint;
static?
Many more variables are static candidates. I will not repeat it.
Did you run this through sparse?

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
small helper function?

> +	} else if ((count == 4) && (((long)mem & 3) == 0)) {
> +		u32 tmp_l;
> +		if (kgdb_mem_cpy(&tmp_l, mem, count))
> +			return ERR_PTR(-EINVAL);
> +
> +		mem += 4;
> +#ifdef __BIG_ENDIAN
> +		*buf++ = hexchars[(tmp_l >> 28) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 24) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 20) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 16) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 12) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 8) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 4) & 0xf];
> +		*buf++ = hexchars[tmp_l & 0xf];
> +#else
> +		*buf++ = hexchars[(tmp_l >> 4) & 0xf];
> +		*buf++ = hexchars[tmp_l & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 12) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 8) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 20) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 16) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 28) & 0xf];
> +		*buf++ = hexchars[(tmp_l >> 24) & 0xf];
> +#endif
that could be used here too.
And again below.

> + * Convert the hex array pointed to by buf into binary to be placed in mem.
> + * Return a pointer to the character AFTER the last byte written.
> + * May return an error.
> + */
> +char *kgdb_hex2mem(char *buf, char *mem, int count)
> +{
> +	if ((count == 2) && (((long)mem & 1) == 0)) {
> +		u16 tmp_s = 0;
> +
> +#ifdef __BIG_ENDIAN
> +		tmp_s |= hex(*buf++) << 12;
> +		tmp_s |= hex(*buf++) << 8;
> +		tmp_s |= hex(*buf++) << 4;
> +		tmp_s |= hex(*buf++);
> +#else
> +		tmp_s |= hex(*buf++) << 4;
> +		tmp_s |= hex(*buf++);
> +		tmp_s |= hex(*buf++) << 12;
> +		tmp_s |= hex(*buf++) << 8;
> +#endif
small helper function again.

> +int kgdb_isremovedbreak(unsigned long addr)
> +{
> +	int i;
> +
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if ((kgdb_break[i].state == BP_REMOVED) &&
> +					(kgdb_break[i].bpt_addr == addr))
> +			return 1;
> +	}
> +	return 0;
> +}
static?

> +
> +int remove_all_break(void)
> +{
> +	unsigned long addr;
> +	int error;
> +	int i;
> +
> +	/* Clear memory breakpoints. */
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if (kgdb_break[i].state != BP_SET)
> +			continue;
> +		addr = kgdb_break[i].bpt_addr;
> +		error = kgdb_arch_remove_breakpoint(addr,
> +				kgdb_break[i].saved_instr);
> +		if (error)
> +			return error;
> +		kgdb_break[i].state = BP_REMOVED;
> +	}
> +
> +	/* Clear hardware breakpoints. */
> +	if (arch_kgdb_ops.remove_all_hw_break)
> +		arch_kgdb_ops.remove_all_hw_break();
> +
> +	return 0;
> +}
static?

> +/*
> + * Return true if there is a valid kgdb I/O module.  Also if no
> + * debugger is attached a message can be printed to the console about
> + * waiting for the debugger to attach.
> + *
> + * The print_wait argument is only to be true when called from inside
> + * the core kgdb_handle_exception, because it will wait for the
> + * debugger to attach.
> + */
> +int kgdb_io_ready(int print_wait)
> +{
> +	if (!kgdb_io_ops)
> +		return 0;
> +	if (kgdb_connected)
> +		return 1;
> +	if (atomic_read(&kgdb_setting_breakpoint))
> +		return 1;
> +	if (print_wait)
> +		printk(KERN_CRIT "KGDB: Waiting for remote debugger\n");
> +	return 1;
> +}
static?
Please review the rest of the code-base for static candidates.

> new file mode 100644
> index 0000000..afa61bb
> --- /dev/null
> +++ b/lib/Kconfig.kgdb
> @@ -0,0 +1,32 @@
> +
> +menuconfig KGDB
> +	bool "KGDB: kernel debugging with remote gdb"
> +	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
> +	select DEBUG_INFO
> +	select FRAME_POINTER
> +	depends on DEBUG_KERNEL && ADD_A_KGDB_ARCH

Replace ADD_A_...
with
HAVE_KGDB

and then let arch do:
	select HAVE_KGDB if they support KGDB

See Documentation/kbuild/kconfig-language.txt

	Sam
