Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZCYLd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZCYLd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZCYLdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:33:49 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:39539 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZCYLds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:33:48 -0400
Date: Wed, 25 Mar 2009 12:33:44 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       dann frazier <dannf@dannf.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 1/2] fs: Fix sign extension problem in sys_llseek
Message-ID: <20090325123344.409090a3@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090325001303.GB24026@linux-mips.org>
References: <20090325001303.GB24026@linux-mips.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 01:13:03 +0100
Ralf Baechle <ralf@linux-mips.org> wrote:

> In fs/read_write.c:
> 
> SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
>                 unsigned long, offset_low, loff_t __user *, result,
>                 unsigned int, origin)
> ...
>    	offset = vfs_llseek(file, ((loff_t) offset_high << 32) | offset_low,
>                         origin);
> 
> On a 64-bit system that define CONFIG_HAVE_SYSCALL_WRAPPERS SYSCALL_DEFINEx
> will truncate long arguments to 32-bit and on some architectures such as
> MIPS sign-extended to 64-bit again.  On such architectures passing a
> value with bit 31 in offset_low set will result in a huge 64-bit offset
> being passed to vfs_llseek() and it failiing with EINVAL.

How is that possible? If you have CONFIG_HAVE_SYSCALL_WRAPPERS defined
then the wrapper will (in this case) cast offset_low from long to
unsigned long. It won't truncate or sign extend anything here.
The whole operation should be a NOP.

This is what you get after macro expansion (BUILD_BUG_ON removed):

long sys_llseek(unsigned int fd, unsigned long offset_high, unsigned long offset_low, loff_t * result, unsigned int origin);

static inline __attribute__((always_inline))
long SYSC_llseek(unsigned int fd, unsigned long offset_high, unsigned long offset_low, loff_t * result, unsigned int origin);

long SyS_llseek(long fd, long offset_high, long offset_low, long result, long origin)
{
	return (long) SYSC_llseek((unsigned int) fd, (unsigned long) offset_high, (unsigned long) offset_low, (loff_t *) result, (unsigned int) origin);
}

asm ("\t.globl " "sys_llseek" "\n\t.set " "sys_llseek" ", " "SyS_llseek");

static inline __attribute__((always_inline))
long SYSC_llseek(unsigned int fd, unsigned long offset_high, unsigned long offset_low, loff_t * result, unsigned int origin)
{
	[...]
}
