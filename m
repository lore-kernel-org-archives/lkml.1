Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYCMOo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYCMOo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYCMOou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:44:50 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:59261 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYCMOou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:44:50 -0400
Date: Thu, 13 Mar 2008 10:42:21 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/4] ptrace: compat_ptrace_request siginfo
Message-ID: <20080313144221.GA10328@c2.user-mode-linux.org>
References: <20080313083107.8BDE926F992@magilla.localdomain> <20080313083243.E551A26F992@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313083243.E551A26F992@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 01:32:43AM -0700, Roland McGrath wrote:
> On powerpc, this fixes a longstanding regression of 32-bit ptrace
> calls on 64-bit kernels vs native calls (64-bit calls or 32-bit
> kernels).  This can be seen in a 32-bit call using PTRACE_GETSIGINFO
> to examine e.g. siginfo_t.si_addr from a signal that sets it.
> (This was broken as of 2.6.24 and, I presume, many or all prior versions.)

BTW, this also fixes a long-standing bug in x86_64 ptrace32_siginfo:

	ret = sys_ptrace(request, pid, addr, (unsigned long)si);
	if (ret)
		return ret;
	if (request == PTRACE_GETSIGINFO) {
		if (copy_from_user(&ssi, si, sizeof(siginfo_t)))
			return -EFAULT;
		ret = copy_siginfo_to_user32(si32, &ssi);
	}

si comes back with the upper bits of si_code missing, courtesy of
copy_siginfo_to_user:

	err |= __put_user((short)from->si_code, &to->si_code);

causing copy_siginfo_to_user32 to not copy any fields of the union
past the first word because the upper 16 bits are used to figure out
what needs copying.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
