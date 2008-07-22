Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYGVKva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYGVKva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYGVKvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:51:22 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:53206 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbYGVKvV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:51:21 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 12:51:08 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Samuel Sieb <samuel@sieb.net>,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
References: <48841A92.4020301@sieb.net> <48856BC6.7030308@sieb.net> <20080722102457.GA773@elte.hu>
In-Reply-To: <20080722102457.GA773@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807221251.10843.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 22. Juli 2008, Ingo Molnar wrote:
> * Samuel Sieb <samuel@sieb.net> wrote:
> > Ingo Molnar wrote:
> >> * Rafael C. de Almeida <almeidaraf@gmail.com> wrote:
> >>> Samuel Sieb wrote:
> >>>> I have a computer here with a CPU that the BIOS identifies as:
> >>>> Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B
> >>>>
> >>>> I can't boot any kernel later than 2.6.22 on it.  Anything later
> >>>> either hangs or gives random kernel panics while booting.  I tracked
> >>>> down the problem to a specific commit:
> >>>>
> >>>> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> >>
> >> does the debug patch below (ontop of v2.6.26 or later kernels) make the
> >> system bootable again? Commit f25f64ed5 changed the meaning of that
> >> line. This patch switches back to the old behavior (which essentially
> >> did nothing, due to macro side-effect bugs).
> >
> > Commenting out this line didn't have any effect that I could see.  I was
> > hoping one way or another it would affect the TSC unstable message I
> > get, but it didn't even change that.
>
> could you try to figure out which particular use of getCx86() or
> setCx86() makes the difference? Here are the suspect nested ones, for
> which the macro->inline change can be material:
>
> $ grep -n 'Cx86.*Cx86' arch/x86/kernel/*/*.c > 1
>
> arch/x86/kernel/cpu/cyrix.c:119:	setCx86(CX86_PCR0, getCx86(CX86_PCR0) &
> ~0x80); arch/x86/kernel/cpu/cyrix.c:130:	setCx86(CX86_CCR2,
> getCx86(CX86_CCR2) & ~0x04);
> arch/x86/kernel/cpu/cyrix.c:134:	setCx86(CX86_CCR2, getCx86(CX86_CCR2) |
> 0x14); arch/x86/kernel/cpu/cyrix.c:147:	setCx86(CX86_PCR1,
> getCx86(CX86_PCR1) | 0x02);
> arch/x86/kernel/cpu/cyrix.c:150:	setCx86(CX86_PCR0, getCx86(CX86_PCR0) |
> 0x04); arch/x86/kernel/cpu/cyrix.c:165:	setCx86(CX86_CCR2,
> getCx86(CX86_CCR2) | 0x88);
> arch/x86/kernel/cpu/cyrix.c:172:	setCx86(CX86_CCR4, getCx86(CX86_CCR4) |
> 0x38); arch/x86/kernel/cpu/cyrix.c:289:			setCx86(CX86_CCR7,
> getCx86(CX86_CCR7) | 1);
> arch/x86/kernel/cpu/cyrix.c:312:			setCx86(CX86_CCR7,
> getCx86(CX86_CCR7)|1);
> arch/x86/kernel/cpu/cyrix.c:427:			setCx86(CX86_CCR4, getCx86(CX86_CCR4) |
> 0x80);  /* enable cpuid  */
>
> i've applied the patch below to tip/master:
>
>    http://people.redhat.com/mingo/tip.git/README
>
> could you check whether it boots your system fine, out of box?

Maybe its something system specific. I'm using several Geode-GX1 systems here 
and they are working fine with all these tweaks (but my processors are 
stepping 2).

~ cat /proc/cpuinfo
processor       : 0
vendor_id       : Geode by NSC
cpu family      : 5
model           : 9
model name      : Geode(TM) Integrated Processor by National Semi
stepping        : 2
cache size      : 16 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu msr cx8 cmov mmx cxmmx
bogomips        : 99.94
clflush size    : 32

The only critical tweak I found is the one that changes the "Performance 
Control Incrementer" because its settings depends on the CPU's core 
frequency.
Maybe this tweak should be removed, because the BIOS (hopefully) set it in a 
way the hardware supports.

Regards,
Juergen

-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
