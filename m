Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbZFWWI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbZFWWI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZFWWIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:08:48 -0400
Received: from mail-yx0-f194.google.com ([209.85.210.194]:62263 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022AbZFWWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=rJ+6Esq/APxFL6QmcF4+fTQjOKvxSrI+JE2SUwmA/qH5M2VBfJ1AbX57i8rTp4+o4D
         EU8B2qixPd9GAZNzIKTA4Gc7dbOxM+yp5Bi+p4Ghir/qDdeak1NUaQ4L0LyUcct+HyIG
         3JAOx9I8F6Ord7/0ggJd0wVIzgytB23DAPbaM=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 23 Jun 2009 18:08:29 -0400
Message-ID: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com>
Subject: PREEMPT_ACTIVE too low error with all asm-generic headers for some 
	arches
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after pulling the latest mainline code, Blackfin started hitting a
build failure like so:
  CC      arch/blackfin/kernel/asm-offsets.s
In file included from include/linux/interrupt.h:12,
                 from include/linux/kernel_stat.h:8,
                 from arch/blackfin/kernel/asm-offsets.c:32:
include/linux/hardirq.h:66:2: error: #error PREEMPT_ACTIVE is too low!
make[1]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1

this is because we've converted to asm-generic for most of our headers
(including hardirq.h).  originally we were defining HARDIRQ_BITS
ourselves to 8, but then we dropped that in favor of the
asm-generic/hardirq.h which setup a default of 8.  but then they
dropped it in favor of the linux/hardirq.h default handling ... but it
sets it to MAX_HARDIRQ_BITS by default which is 10.  which pushes
Blackfin over the edge and into this build error.

if we look at linux/hardirq.h, it makes this claim:
 * - bit 28 is the PREEMPT_ACTIVE flag
if that's true, then why are we letting any arch set this define ?  a
quick survey shows that half the arches (11) are using 0x10000000 (bit
28) while the other half (10) are using 0x4000000 (bit 26).  and then
there is the ia64 oddity which uses bit 30.  the exact value here
shouldnt really matter across arches though should it ?

how about adding this to linux/thread_info.h:
#ifndef PREEMPT_ACTIVE
# ifndef PREEMPT_ACTIVE_BIT
#  define PREEMPT_ACTIVE_BIT 28
# endif
# define PREEMPT_ACTIVE (1 << PREEMPT_ACTIVE_BIT)
#endif
-mike
