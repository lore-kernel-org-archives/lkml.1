Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZCOOXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZCOOXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 10:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZCOOXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 10:23:30 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:61221 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZCOOXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 10:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=l3tvD2ftSTa3bRql+gfXTZcEb6XSlDY7Z7nAlgjlQA3U879KW4Xr4s6CQF+f0aN5bD
         TEGM9D/5T/dpjD1mWWgXZrDTa3WTtecV3EfM0FxqiA/JYeS9g4cJrBA3dK3YDr6Uedl7
         YYT0sM6+5s9NaOLNapfbTkYDulXwwZ70dtYp0=
MIME-Version: 1.0
Date: Sun, 15 Mar 2009 11:16:24 -0300
Message-ID: <ce0170d90903150716t14033a9dr3b3bf028933dde7c@mail.gmail.com>
Subject: x86: asm doubt
From: Sergio Luis <eeeesti@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

taking a look at arch/x86/power/cpu_(32|64).c, I saw the 32.c one
using the following macros

#define savesegment(seg, value)                         \
        asm("mov %%" #seg ",%0":"=r" (value) : : "memory")


#define loadsegment(seg, value)                 \
        asm volatile("\n"                       \
                     "1:\t"                     \
                     "movl %k0,%%" #seg "\n"    \
                     "2:\n"                     \
                     ".section .fixup,\"ax\"\n" \
                     "3:\t"                     \
                     "movl %k1, %%" #seg "\n\t" \
                     "jmp 2b\n"                 \
                     ".previous\n"              \
                     _ASM_EXTABLE(1b,3b)        \
                     : :"r" (value), "r" (0) : "memory")


saving and loading segment registers as in

savesegment(es, ctxt->es);
loadsegment(es, ctxt->es);

the code in cpu_64.c doesn't make use of such macros, doing the following:

saving:
 asm volatile ("movw %%es, %0" : "=m" (ctxt->es));

loading:
asm volatile ("movw %0, %%es" :: "r" (ctxt->es));

So, my question is... what's the actual difference between both
versions? Aren't the macros suitable for the 64 version as well?

Thanks,
Sergio.
