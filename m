Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYBNKEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYBNKEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYBNKDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:03:55 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:59247 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYBNKDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:03:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lxwXUpoSNk8+Dpkg5EtEcmnd891FC3QwHk1DnwAqLDSGp7jMco462hEv8K5wLqcrFeHSoRb84f+/UsHj056gnZPobdraAZzd7c+8cA9o3NrR5vQLvmEgTwMUwSFCyPNsirqqTpKHeDeaqKsqF0t47eDCrDFWHEYA/9ZxyrFZgXs=
Message-ID: <15577be70802140203r4f33e7ebg3c2fc8ebc2c428c@mail.gmail.com>
Date: Thu, 14 Feb 2008 11:03:51 +0100
From: "Abel Bernabeu" <abelbg@m2grp.com>
Reply-To: abelbg@m2grp.com
To: "Daniel Jacobowitz" <dan@debian.org>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, abelbg@m2grp.com, hpa@zytor.com,
       jkosina@suse.cz, roland@redhat.com, schwab@suse.de, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: + elf-loader-crash-while-zero-filling-bss.patch added to -mm tree
In-Reply-To: <20080213143701.GA21800@caradoc.them.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802130816.m1D8GSep015744@imap1.linux-foundation.org>
	 <20080213143701.GA21800@caradoc.them.org>
X-Google-Sender-Auth: 55f54fd1731ddf7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/13, Daniel Jacobowitz <dan@debian.org>:
> On Wed, Feb 13, 2008 at 12:15:06AM -0800, akpm@linux-foundation.org wrote:
>  > Subject: Elf loader crash while zero-filling .bss
>  > From: "Abel Bernabeu" <abelbg@m2grp.com>
>  >
>  > I've finally found a solution for the crash in load_binary_elf I
>  > reported last week:
>  >
>  > http://lkml.org/lkml/2008/1/30/171
>  >
>  > The attached patch solves my problem.
>  >
>  > set_brk(start, end) allocs just page aligned regions (by "collapsing" both
>  > extremes to the start of the page in which they lay)...  That means than
>  > even if both pointers are not equal there are still some chances that
>  > set_brk has allocated no space at all because ELF_PAGEALIGN(elf_bss) ==
>  > ELF_PAGEALIGN(elf_brk).
>  >
>  > So the condition was not correct.
>
>  This patch is wrong.
>
>  ELF_PAGEALIGN rounds up to the end of the page, not down to the start
>  of the page.  If elf_bss is in the middle of a page, set_brk allocates
>  any additional pages after the one already allocated.  elf_bss is the
>  start of the area that needs to be zero initialized, elf_brk is its
>  end.  So if elf_bss != elf_brk then there's garbage mapped in BSS
>  from the file and if you don't clear it some of your zero-initialized
>  variables won't be zero initialized at all.
>
>  In the linked message, set_brk is passed elf_bss so its actual
>  arguments are set_brk (0xa3801, 0x000a4ec8).  It should map one
>  page.  0xa3801 should be an already mapped page, and clear_user should
>  succeed in clearing it.

The bad news... Dan is rigth and I've made you loss your time because
of my initial missunderstanding of that piece of code.

Having your boss and the client continously asking if does Linux
already run on our board doesn't help to keep your mind clearness X)

The call to clear_user produced a page fault (it's true), but it was a
benign one (the some sort of page fault with permits load-on-demand of
the binary).

Then Rusell King's page fault handler
(arch/arm/mm/fault.c:do_DataAbort) manages to finally call the correct
non-architecture specific handler for load-on-demand.

This non-architecture specific handler allocs a physical page in which
clear_user can retry to write at a second try when the program
execution is restarted.

The "funny" thing is that now I am almost sure that I was playing with
Rusell's code and I accidentally left commented some of the code that
finally  calls this non architecture specific code.

The good news for "the community" is that now I am very sure I can
refactor the overpatched (but correct) portion of code I
missunderstood and send it back to you when is already tested. There
are some easy clean ups I can do in order to make Adrian Bunk happy :D

Yours, Abel.
