Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYE3PP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYE3PP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYE3PPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:15:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:47918 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYE3PPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=EVVOtyeTFcKl2tQUMnNNoAYThOnzIDVNZQkXKiInNR8l8XZqcM+/1SRPZ0ynYs6g8vGmamvRzFMzGYBQoFBULbSVVLHNMMOvuxCJ/YHWBxlTAAxCSDOeyMf6OuoS1QFNIs/fd7wlKi+DLNob3L8CC00KNyOOLdGX/OZE7LA6vJc=
Message-ID: <900048340805300815u57af94b0i3971b22a9d154d1f@mail.gmail.com>
Date: Fri, 30 May 2008 17:15:46 +0200
From: "Jiri Hladky" <hladky.jiri@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Bug in arch/i386/lib/delay.c file, delay_loop function
Cc: mj@atrey.karlin.mff.cuni.cz
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_14453_14919333.1212160546585"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_14453_14919333.1212160546585
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

when trying to understand how Bogomips are implemented I have found
bug in arch/i386/lib/delay.c file, delay_loop function

/* simple loop based delay: */
static void delay_loop(unsigned long loops)
{
  int d0;

  __asm__ __volatile__(
    "\tjmp 1f\n"
    ".align 16\n"
    "1:\tjmp 2f\n"
    ".align 16\n"
    "2:\tdecl %0\n\tjns 2b"
    :"=&a" (d0)
    :"0" (loops));
}


The function fails for loops > 2^31+1. It because SF is set when dec
returns numbers > 2^31

The fix is to use jnz instruction instead of jns (and add one decl
instruction to the end to have exactly the same number of loops as in
original version):

__asm__ __volatile__(
	"\tjmp 1f\n"
	".align 16\n"
	"1:\tjmp 2f\n"
	".align 16\n"
	"2:\tdecl %0\n\tjnz 2b\n"
	"decl %0"
	:"=&a" (d0)
	:"0" (loops));

IMHO, d0 is not needed at all so that we can further simplify the code:
static void delay_loop(unsigned long loops)
__asm__ __volatile__(
	"\tjmp 1f\n"
	".align 16\n"
	"1:\tjmp 2f\n"
	".align 16\n"
	"2:\tdecl %0\n\tjnz 2b\n"
	"decl %0"
	:/*we don't need output */
	:"a" (loops));
}

I will attach three small C-program to test it
delay-orig.c - original loop from kernel source code
delay-fixed.c - fixed loop
delay-fixed1.c - fixed loop without d0 variable

Outputs:
============== delay-orig.c ==================
time delay-orig 2147483649
loops 2147483649
loops 2147483649
do -2147483648

real    0m0.002s
user    0m0.000s
sys     0m0.000s

================== delay-fixed.c =============
time delay-fixed 2147483649
loops 2147483649
loops 2147483649
do -1

real    0m1.025s
user    0m1.024s
sys     0m0.000s

========== delay-fixed1.c =====================
time delay-fixed1 2147483649
loops 2147483649
loops 2147483649

real    0m1.073s
user    0m1.060s
sys     0m0.004s


and update kernel source file arch/i386/lib/delay.c. Please let me
know if these modifications make sense.

Thanks a lot
Jiri

------=_Part_14453_14919333.1212160546585
Content-Type: application/x-bzip2; name=delay-fix.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgux2ukh0
Content-Disposition: attachment; filename=delay-fix.tar.bz2

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
------=_Part_14453_14919333.1212160546585--
