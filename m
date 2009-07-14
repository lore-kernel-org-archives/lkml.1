Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZGNRNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZGNRNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZGNRNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:13:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZGNRN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:13:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: access_ok macor
Date: Tue, 14 Jul 2009 19:13:20 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
References: <4A5C8068.6020203@monstr.eu> <200907141843.05629.arnd@arndb.de> <4A5CB8B4.7050108@monstr.eu>
In-Reply-To: <4A5CB8B4.7050108@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907141913.21240.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18bQnuRaJdHRlpQ37ITcklJnX+mGdG87lNc6z0
 XlLPoFz2c1BAsMkkjCKuXZvq2hC/DbDLwwdzYawsD62rbalSAr
 wsWC98rNygLDy/wZDqhBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 July 2009, Michal Simek wrote:
> when the code tried to read/write from unaligned address (and in cpu is turn on unaligned exception)
> then is caused unaligned exception and asm code assemble/return value which is on that unaligned
> address. (Assemble it that read/write every byte separately). That will be harder to prevent all
> this cases because unaligned exception is in generic code.
> What do you mean add __range_ok? Range checking is ok. The problem is when in case get_user kernel
> try to load unaligned addr - unaligned exception is perform and try to load that value separately.
> If that page is not there, page fault handler is called and not find it, it is performed search
> from exception table and that address is not there of course - because address in pc is generic
> unaligned code. I think that handling this needs more code.
> Maybe if the address with from unaligned exception handler (there are some address which can caused
> it) and find out which aligned address is there and find out proper fixup for it.
> I think that this could work.
> 
> What do you think?

I think the key point is that the kernel should never try an unaligned
access. Other architectures already rely on this, so you can too.
Instead of doing an aligned access from the unaligned exception handler,
you should not access the data at all when you come from kernel mode
but only search the fixup table to see if you should continue anyway.

Sorry for adding confusion by mentioning the __range_ok, which is addressing
a separate problem. I should have made that clearer.

In pseudo-code, I think you should do:

void unaligned_exception(struct pt_regs *regs, unsigned long address)
{
	if (kernel_mode(regs)) {
		/*
		 * unaligned access not allowed in kernel,
		 * but search exception table.
		 */
		bad_page_fault(regs, address, 0);
	} else {
		if (!access_ok(address, 4))
			force_sig(SIGBUS, current);
		else
			fixup_unaligned_access(regs);
	}
}

	Arnd <><
