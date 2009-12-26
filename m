Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZLZLNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZLZLNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 06:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZLZLNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 06:13:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZLZLNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 06:13:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: sys_recvmmsg: wire up or not?
Date: Sat, 26 Dec 2009 12:12:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>
References: <10f740e80912260239n17bbbd08w6c3065c12bde9c95@mail.gmail.com>
In-Reply-To: <10f740e80912260239n17bbbd08w6c3065c12bde9c95@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>+
	~ohchhkRGW?|6_qTmkd_t?LZC#Q-`.`Y.a^3zb)+U-JVN]WT%cw#[Yo0&7C&bL12wWGlZi
	~J;\wg;3zRnz,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912261212.14264.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/OSPyBPs1nRp8S57khst2p7FruAYGB/69Aeoa
 R8x5PaEA6BOPOPFPDEwDRBGXaeiCoJIb8Mfq6pJNY/kQbQsh02
 KGxIBtjN8SzXohLlssB1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 December 2009, Geert Uytterhoeven wrote:
> <stdin>:1523:2: warning: #warning syscall recvmmsg not implemented
> 
> so I started to wire up sys_recvmmsg.
> Then I noticed it's already accessible, through sys_socketcall, as m68k defines
> __ARCH_WANT_SYS_SOCKETCALL. So I guess this is a false positive?

Yes.

> Surprisingly, several architectures have both defined __ARCH_WANT_SYS_SOCKETCALL
> and wired up sys_recvmmsg. Is this intentional?

It's also rather inconsistent with the last socket call that was added, sys_accept4.
Some architectures that normally define socket calls (parisc, sh) are missing both
accept4 and recvmmsg, while others that don't have recvmsg now get recvmmsg.

In particular, i386 has recvmmsg now, which caused the warning that you saw.
I guess that one should be removed, and maybe we need a better logic for
determining which syscalls you actually want. Deriving it from asm-generic/unistd.h
instead of arch/x86/include/asm/unistd_32.h is probably better, but would still
give the wrong answer for multiplexed system calls like socketcall or ipc on 
existing architectures.

	Arnd
