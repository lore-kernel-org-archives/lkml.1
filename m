Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbYETOWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbYETOWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYETOV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:21:58 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:65011 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYETOV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=Kvbf9LvJA0gIuz28ZxxM0ThNbVuIn2jdPkSkzCqTB+xBhEyx0Wk67/3XXLWARvCcyy65LPxd2Cs7tw18v94723Dp2htcrF+MmQV8450buYKlr3rQXCcQTIpUDCWhkOYSzflBWcTtTgWUV7ACQ/dJTavOPRzC6FFMQ3qrOcTbrJI=
Message-ID: <3efb10970805200721u6a837a2ap94ead54f7eb7bf89@mail.gmail.com>
Date: Tue, 20 May 2008 16:21:53 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: 2.6.25.4-rt2 compile errors on ARM due to cmpxchg() problems.
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       lvcargnini@gmail.com, "Thomas Gleixner" <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 6e9a9bd824777dc9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

I want to test 2.6.25.4-rt2 on ARM, but unfortunately I run into
several compile errors.
All errors seem to be related to cmpxchg routines -> duplicate
definitions or missing BUILD_BUG_ON() or typecheck() macros.
I already figured out the missing BUILD_BUG_ON() + typecheck() problem
which is caused by including a header
'include/asm-generic/cmpxchg-local.h' in linux/kernel.h before these
macros are defined in linux/kernel.h. See below for a piece/snippet of
the compiler output.

Looking deeper into this, things look quite messy around cmpxchg() on ARM...

Any ideas what has been changed here, and why these things can go
wrong so badly?


Kind Regards,

Remy

---- 8-< ----
In file included from include/linux/rt_lock.h:14,
                 from include/linux/spinlock.h:117,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/percpu.h:5,
                 from include/linux/kernel_stat.h:7,
                 from arch/arm/kernel/irq.c:24:
include/asm/atomic.h:241:1: warning: "cmpxchg" redefined
In file included from include/asm/system.h:378,
                 from include/asm/bitops.h:27,
                 from include/linux/bitops.h:17,
                 from include/linux/kernel.h:32,
                 from include/linux/cpumask.h:84,
                 from include/linux/smp.h:10,
                 from include/linux/kernel_stat.h:5,
                 from arch/arm/kernel/irq.c:24:
include/asm-generic/cmpxchg.h:19:1: warning: this is the location of
the previous definition
In file included from include/asm/system.h:366,
                 from include/linux/list.h:9,
                 from include/linux/module.h:9,
                 from arch/arm/kernel/process.c:13:
include/asm-generic/cmpxchg-local.h: In function '__cmpxchg_local_generic':
include/asm-generic/cmpxchg-local.h:23: error: implicit declaration of
function 'BUILD_BUG_ON'
include/asm-generic/cmpxchg-local.h:23: error: implicit declaration of
function 'typecheck'
include/asm-generic/cmpxchg-local.h:23: error: expected expression
before 'unsigned'
include/asm-generic/cmpxchg-local.h:44: error: expected expression
before 'unsigned'
include/asm-generic/cmpxchg-local.h: In function '__cmpxchg64_local_generic':
include/asm-generic/cmpxchg-local.h:57: error: expected expression
before 'unsigned'
include/asm-generic/cmpxchg-local.h:61: error: expected expression
before 'unsigned'
---- 8-< ----
