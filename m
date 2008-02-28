Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYB1TYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYB1TYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762234AbYB1TYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:24:10 -0500
Received: from xspect.dk ([212.97.129.87]:45076 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762015AbYB1TYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:24:06 -0500
Date: Thu, 28 Feb 2008 20:24:04 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080228192404.GH17932@hjernemadsen.org>
References: <20080227221033.GR17932@hjernemadsen.org> <20080228091639.GB1133@elte.hu> <20080228092846.GC17932@hjernemadsen.org> <20080228094000.GA2987@elte.hu> <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C6F4F9.90700@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 09:52:57 -0800, H. Peter Anvin wrote:
> Klaus S. Madsen wrote:
> >
> >Hope this helps. 
> >
> 
> What this seems to indicate is a segfault inside VM mode that causes it 
> to exit to deliver the SIGSEGV, so without more information, such as 
> signal context, there isn't much to know about it.
> 
> It looks like the fault happens inside the VESA BIOS, specifically VBE 
> function 3:
> 
> --------V-104F03-----------------------------
> INT 10 - VESA SuperVGA BIOS - GET CURRENT VIDEO MODE
>         AX = 4F03h
> Return: AL = 4Fh if function supported
>         AH = status
>             00h successful
>                 BX = video mode (see #00083,#00084)
>                     bit 13: VBE/AF v1.0P accelerated video mode
>                     bit 14: linear frame buffer enabled (VBE v2.0+)
>                     bit 15: don't clear video memory
>             01h failed
> SeeAlso: AH=0Fh,AX=4E04h,AX=4F02h
> 
> ... which normally would be a trivial function which only reads a couple 
> of status words out of internal state and returns.
> 
> ****
> 
> Typically, when the kernel reflects an error in VM86 mode it will update 
> the structure in memory (in your case, the vm86plus_struct) to reflect 
> the context.  Would it be possible for you to read it out?
Hmm. As far as I can tell, its actually using the vm86old system call?
That's at least what the comment in libx86 states.

However the contents of struct vm86_struct after the segfault is:

(gdb) print context.vm
$2 = {regs = {ebx = 0, ecx = 0, edx = 0, esi = 0, edi = 0, ebp = 0, 
    eax = 20227, __null_ds = 0, __null_es = 0, __null_fs = -1071579136, 
    __null_gs = 0, orig_eax = -1, eip = 6326, cs = 49152, __csh = 0, 
    eflags = 209410, esp = 4090, ss = 256, __ssh = 0, es = 0, __esh = 0, 
    ds = 64, __dsh = 0, fs = 0, __fsh = 0, gs = 0, __gsh = 0}, flags = 0, 
  screen_bitmap = 0, cpu_type = 0, int_revectored = {__map = {0, 0, 0,0, 0, 
      0, 0, 2147483648}}, int21_revectored = {__map = {0, 0, 0, 0, 0, 0, 0, 
      0}}}

My version of glibc does not seem to have vm86old declared, so I haven't
tried to remove the assembly code.

Should I try to change it to use vm86, instead of vm86old?

-- 
Kind regards
	Klaus S. Madsen
