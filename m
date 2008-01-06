Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbYAFAsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbYAFAsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYAFAsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:48:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYAFAsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:48:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Subject: Re: [PATCH] x86: ioport_{32|64}.c unification
Date: Sun, 6 Jan 2008 01:47:47 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
References: <200801060059.48333.mboton@gmail.com>
In-Reply-To: <200801060059.48333.mboton@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801060147.48185.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uoaOgi9EAqnQ6sNWznpnxOBQb2TCjO5YrmZR
 2X6UJ2OZw58lCxzdA02AISClU2qacFxVAzdMgscbTBsgIohH/V
 Im/A3hkY09Z5vGvuodsJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 January 2008, Miguel Botón wrote:
> +#ifdef CONFIG_X86_32
> +asmlinkage long sys_iopl(unsigned long regsp)
> +#else
> +asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
> +#endif
> +{
> +#ifdef CONFIG_X86_32
> +       volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
> +       unsigned int level = regs->bx;
> +#endif

This #ifdef overload could probably be avoided if you just move
the body of this function into an extra place and do

static int do_iopl(unsigned int level, unsigned long *flags)
{
        unsigned int old = (*flags >> 12) & 3;
	...
        *flags = (*flags & ~X86_EFLAGS_IOPL) | (level << 12);;
}

#ifdef CONFIG_X86_32
asmlinkage long sys_iopl(unsigned long regsp)
{
	/* why is this volatle anyway? */
	volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
	unsigned int level = regs->bx;
	return do_iopl(regs->bx, &regs->flags);
}
#else
asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
{
	return do_iopl(level, &regs->flags);
}
#endif

	Arnd <><
