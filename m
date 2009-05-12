Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbZELLeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbZELLeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759653AbZELLdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:33:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZELLds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:33:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v3] x86: fix ktermios-termio conversion
Date: Tue, 12 May 2009 13:33:44 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <20090511222702.352192505@arndb.de> <20090512092601.GB29796@elte.hu> <20090512110527.5352cd0e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090512110527.5352cd0e@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905121333.45484.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18j86JT2dd8/4Tm1SovmtXKWtFbCHqa3WeGCAa
 8npmSuxdBa01+EVCj7cMO7uCiehxBLHnArhQXJGuGck4uKBhNR
 BpD2+wBpiI+LyiDDZvG1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy TCSETA{,W,F} ioctls failed to set the termio->c_line field
on x86. This adds a missing get_user.

The same ioctls also fail to report faulting user pointers, which
we keep ignoring.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

On Tuesday 12 May 2009, Alan Cox wrote:
> Arnd - can you send me a diff that keeps the existing horrible macro
> version, the existing __put_user usage and just fixes c_line ? It's
> worked for 15 years, its not worth the time being fancy with it.

I should probably have made my intention clearer. I'm sitting on a
series of patches [1] that generalize a lot of headers by making an
asm-generic version and falling back on this in all architectures that
have the same code.

The x86 SET_LOW_TERMIOS_BITS macro, besides its own stylistic problems,
only works on little-endian architectures and generates compiler warnings
on architectures on which get_user returns 'int __must_check'.
My asm-generic version fixes this by using the architecture independent
code I posted in this thread.

One of my later patches removes all x86 specific headers that are identical
to the asm-generic version. The termios.h header is almost identical,
so I first wanted to submit the patch to make it actually the same.

	Arnd <><

[1] git.kernel.org:/pub/scm/linux/kernel/git/arnd/asm-generic.git

diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
index f729563..c4ee805 100644
--- a/arch/x86/include/asm/termios.h
+++ b/arch/x86/include/asm/termios.h
@@ -67,6 +67,7 @@ static inline int user_termio_to_kernel_termios(struct ktermios *termios,
 	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
 	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
 	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
+	get_user(termios->c_line, &termio->c_line);
 	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
 }
 
