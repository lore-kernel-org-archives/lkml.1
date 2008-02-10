Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbYBJMrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYBJMrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYBJMr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:47:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:44816 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYBJMr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:47:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FgZqHk8RJGV8Q+352/AxEpPctsj7n6kbwX9o42kr9EBUZJTntwtQHko0DT0KgZosifYCqTzaHHnJfaA61ha+n6f9+6EUB9/AVP1kEcUQzKAsbuyR2zYReOJ72OGMtADOVlbvk1hY1AVgFbq6kWn7/jyKT27GHPaHJHvNt9gCrw8=
Date: Sun, 10 Feb 2008 13:46:45 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210124629.GA12200@joi>
References: <20080210071331.GC3851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210071331.GC3851@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 08:13:31AM +0100, Ingo Molnar wrote:
> +	} else {
> +		while (count-- > 0) {
> +			unsigned char ch;
> +
> +			if (probe_kernel_address(mem, ch)) {
> +				kgdb_may_fault = 0;
> +				return ERR_PTR(-EINVAL);
> +			}
> +			mem++;
> +			*buf++ = hexchars[ch >> 4];
> +			*buf++ = hexchars[ch & 0xf];
use pack_hex_byte?

> +/*
> + * While we find nice hex chars, build a long_val.
> + * Return number of chars processed.
> + */
> +int kgdb_hex2long(char **ptr, long *long_val)
> +{
> +	int hex_val;
> +	int num = 0;
> +
> +	*long_val = 0;
> +
> +	while (**ptr) {
> +		hex_val = hex(**ptr);
> +		if (hex_val >= 0) {
> +			*long_val = (*long_val << 4) | hex_val;
> +			num++;
> +		} else
> +			break;
> +
> +		(*ptr)++;
> +	}
if (hex_val < 0)
	break;
*long_val = (*long_val << 4) | hex_val;
num++;
(*ptr)++;

> +/*
> + * SW breakpoint management:
> + */
> +static int kgdb_activate_sw_breakpoints(void)
> +{
> +	unsigned long addr;
> +	int error = 0;
> +	int i;
> +
> +	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +		if (kgdb_break[i].state != BP_SET)
> +			continue;
> +
> +		addr = kgdb_break[i].bpt_addr;
> +		error = kgdb_arch_set_breakpoint(addr,
> +				kgdb_break[i].saved_instr);
> +		if (error)
> +			return error;
> +
> +		if (CACHE_FLUSH_IS_SAFE) {
> +			if (current->mm && addr < TASK_SIZE) {
> +				flush_cache_range(current->mm->mmap_cache,
> +						addr, addr + BREAK_INSTR_SIZE);
> +			} else {
> +				flush_icache_range(addr, addr +
> +						BREAK_INSTR_SIZE);
> +			}
> +		}
unneeded braces (here and in many other places)

> +/* Handle the '?' status packets */
> +static void gdb_cmd_status(struct kgdb_state *ks)
> +{
> +	/*
> +	 * We know that this packet is only sent
> +	 * during initial connect.  So to be safe,
> +	 * we clear out our breakpoints now in case
> +	 * GDB is reconnecting.
> +	 */
> +	remove_all_break();
> +
> +	/*
> +	 * Also, if we haven't been able to roundup all
> +	 * CPUs, send an 'O' packet informing the user
> +	 * as much.  Only need to do this once.
> +	 */
> +	if (!ks->all_cpus_synced)
> +		kgdb_msg_write("Not all CPUs have been synced for KGDB\n", 39);
> +
> +	remcom_out_buffer[0] = 'S';
> +	remcom_out_buffer[1] = hexchars[ks->signo >> 4];
> +	remcom_out_buffer[2] = hexchars[ks->signo % 16];
use pack_hex_byte or & 0xf

> +		if (ks->threadid < pid_max) {
> +			kgdb_mem2hex(getthread(ks->linux_regs,
> +					ks->threadid)->comm,
> +					remcom_out_buffer, 16);
> +		} else {
> +			if (ks->threadid >= pid_max + num_online_cpus()) {
> +				kgdb_shadowinfo(ks->linux_regs,
> +					remcom_out_buffer,
> +					ks->threadid - pid_max -
> +					num_online_cpus());
> +			} else {
> +				static char tmpstr[23 + BUF_THREAD_ID_SIZE];
> +				sprintf(tmpstr, "Shadow task %d for pid 0",
> +						(int)(ks->threadid - pid_max));
> +				kgdb_mem2hex(tmpstr, remcom_out_buffer,
> +							 strlen(tmpstr));
> +			}
> +		}
if ()
else if ()
else

will look better

> +	if (*(ptr++) != ',') {
> +		error_packet(remcom_out_buffer, -EINVAL);
> +		return;
> +	} else {
no else needed

> +		if (kgdb_hex2long(&ptr, &addr)) {
> +			if (*(ptr++) != ',' ||
> +				!kgdb_hex2long(&ptr, &length)) {
> +				error_packet(remcom_out_buffer, -EINVAL);
> +				return;
> +			}
> +		} else {
> +			error_packet(remcom_out_buffer, -EINVAL);
> +			return;
> +		}
> +	}
if (!kgdb_hex2long()) {
	error_packet();
	return;
}

if (*(ptr++) (...))
(...)

Marcin
