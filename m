Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYA1Swv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYA1Swv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYA1Swo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:52:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37293 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYA1Swn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:52:43 -0500
Date: Mon, 28 Jan 2008 19:52:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix usage of .section .sched.text in assembler code
Message-ID: <20080128185236.GA2391@uranus.ravnborg.org>
References: <20080126225306.GA27215@uranus.ravnborg.org> <20080128101333.GB24010@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128101333.GB24010@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 11:13:34AM +0100, Ingo Molnar wrote:
> 
> > It would be better to have a definition we could use from assembler 
> > code but I did not find a suitable header file for it.
> 
> hm, include/asm-x86/linkage.h?
No - it is for general use so it should live in include/linux/*
Suggestion:

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index ff203dd..4ac87bf 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -48,6 +48,15 @@
   END(name);		 \
   .popsection
 
+#define SCHED_ENTRY(name)				\
+	.pushsection .sched.text, "ax", %progbits;	\
+	ENTRY(name)
+
+#define SCHED_END(name)	\
+	END(name);	\
+	.popsection
+
+
 #ifndef END
 #define END(name) \
   .size name, .-name

Note - the use of '%' is due to '@' is a comment identifier on arm
and '%' seems to works across all arch's assemblers.

> 
> btw., i guess this in include/linux/linkage.h:
> 
> #ifndef __ALIGN
> #define __ALIGN         .align 4,0x90
> #define __ALIGN_STR     ".align 4,0x90"
> #endif
> 
> is an x86-ism (0x90 is the x86 NOP instruction) that should move into 
> include/asm-x86/linkge.h and the default filler should be 0x00 instead?
To specialized for my knowledge..

	Sam
