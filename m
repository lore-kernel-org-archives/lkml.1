Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZGATTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZGATTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZGATTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:19:42 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:47672 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbZGATTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:19:42 -0400
Date: Wed, 1 Jul 2009 20:19:34 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Yong Zhang <yong.zhang@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: o32 application running on 64bit kernel core dump
Message-ID: <20090701191934.GE23121@linux-mips.org>
References: <16bd35f2910f585740f4764fa1e80bf31c80d576.1242178813.git.yong.zhang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16bd35f2910f585740f4764fa1e80bf31c80d576.1242178813.git.yong.zhang@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 09:35:39AM +0800, Yong Zhang wrote:

> +/* These MUST be defined before elf.h gets included */

This sort of ordering bug seems to become a tradition.  I think it may be
a good idea to insert a check like this:

#ifdef ELF_CORE_COPY_REGS
#error ELF_CORE_COPY_REGS should not be defined yet!
#endif

> +extern void elf32_core_copy_regs(elf_gregset_t grp, struct pt_regs *regs);
> +#define ELF_CORE_COPY_REGS(_dest, _regs) elf32_core_copy_regs(_dest, _regs);
> +#define ELF_CORE_COPY_TASK_REGS(_tsk, _dest)				\
> +({									\
> +	int __res = 1;							\
> +	elf32_core_copy_regs((*_dest), (task_pt_regs(_tsk)));		\

Be very careful with parentheses in macros.  This line should probably
become:

	elf32_core_copy_regs(*(_dest), task_pt_regs(_tsk));		\

The changes to the first argument to bullet prof the macro and the change
to the second one for cosmetic reasons.

  Ralf
