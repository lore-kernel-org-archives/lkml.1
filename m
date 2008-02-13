Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbYBMPGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbYBMPGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYBMPGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:06:46 -0500
Received: from NaN.false.org ([208.75.86.248]:44268 "EHLO nan.false.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbYBMPGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:06:45 -0500
X-Greylist: delayed 1781 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 10:06:45 EST
Date: Wed, 13 Feb 2008 09:37:01 -0500
From: Daniel Jacobowitz <dan@debian.org>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, abelbg@m2grp.com, hpa@zytor.com,
       jkosina@suse.cz, roland@redhat.com, schwab@suse.de, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: + elf-loader-crash-while-zero-filling-bss.patch added to -mm
	tree
Message-ID: <20080213143701.GA21800@caradoc.them.org>
Mail-Followup-To: Daniel Jacobowitz <dan@debian.org>,
	akpm@linux-foundation.org, mm-commits@vger.kernel.org,
	abelbg@m2grp.com, hpa@zytor.com, jkosina@suse.cz, roland@redhat.com,
	schwab@suse.de, stable@kernel.org, linux-kernel@vger.kernel.org
References: <200802130816.m1D8GSep015744@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802130816.m1D8GSep015744@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:15:06AM -0800, akpm@linux-foundation.org wrote:
> Subject: Elf loader crash while zero-filling .bss
> From: "Abel Bernabeu" <abelbg@m2grp.com>
> 
> I've finally found a solution for the crash in load_binary_elf I
> reported last week:
> 
> http://lkml.org/lkml/2008/1/30/171
> 
> The attached patch solves my problem.
> 
> set_brk(start, end) allocs just page aligned regions (by "collapsing" both
> extremes to the start of the page in which they lay)...  That means than
> even if both pointers are not equal there are still some chances that
> set_brk has allocated no space at all because ELF_PAGEALIGN(elf_bss) ==	
> ELF_PAGEALIGN(elf_brk).
> 
> So the condition was not correct.

This patch is wrong.

ELF_PAGEALIGN rounds up to the end of the page, not down to the start
of the page.  If elf_bss is in the middle of a page, set_brk allocates
any additional pages after the one already allocated.  elf_bss is the
start of the area that needs to be zero initialized, elf_brk is its
end.  So if elf_bss != elf_brk then there's garbage mapped in BSS
from the file and if you don't clear it some of your zero-initialized
variables won't be zero initialized at all.

In the linked message, set_brk is passed elf_bss so its actual
arguments are set_brk (0xa3801, 0x000a4ec8).  It should map one
page.  0xa3801 should be an already mapped page, and clear_user should
succeed in clearing it.

-- 
Daniel Jacobowitz
CodeSourcery
