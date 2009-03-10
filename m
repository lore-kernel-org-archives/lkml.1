Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZCJPaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZCJPaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZCJP3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:29:54 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35745 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751535AbZCJP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:29:53 -0400
Date: Tue, 10 Mar 2009 16:29:50 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Greg Banks <gnb@sgi.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: driver-core tree build failure
In-Reply-To: <20090310145311.6bf9d9e9@skybase>
Message-ID: <alpine.LRH.2.00.0903101626450.25436@vixen.sonytel.be>
References: <20090310192440.949884a1.sfr@canb.auug.org.au> <alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be> <20090310145311.6bf9d9e9@skybase>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Martin Schwidefsky wrote:
> On Tue, 10 Mar 2009 14:31:17 +0100 (CET)
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> > crypto/zlib.c has:
> > 
> >     #define pr_fmt(fmt)     "%s: " fmt, __func__
> > 
> > If CONFIG_DYNAMIC_DEBUG is set, include/linux/kernel.h has:
> > 
> > #define pr_debug(fmt, ...) do { \
> > 	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
> > 	} while (0)
> > 
> > include/linux/dynamic_debug.h has:
> > 
> > #define dynamic_pr_debug(fmt, ...) do {					\
> > 	static struct _ddebug descriptor				\
> > 	__used								\
> > 	__attribute__((section("__verbose"), aligned(8))) =		\
> > 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
> > 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
> > 	if (__dynamic_dbg_enabled(descriptor))				\
> > 		printk(KERN_DEBUG KBUILD_MODNAME ":" fmt,		\
> > 				##__VA_ARGS__);				\
> > 	} while (0)
> 
> The dynamic_pr_debug macro currently works only with pr_fmt definitions
> that do not add additional parameters. The way how we use the pr_fmt
> macro is:
> 
> #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> 
> The same could be done with the problematic pr_fmt definition:
> 
> #define pr_fmt(fmt)     __func__ ": " fmt

No, that also doesn't work:

| crypto/zlib.c:150: error: expected '}' before string constant
| crypto/zlib.c:150: error: expected ')' before '__func__'
| crypto/zlib.c:162: error: expected '}' before string constant
| crypto/zlib.c:162: error: expected ')' before '__func__'
| crypto/zlib.c:166: error: expected '}' before string constant
| crypto/zlib.c:166: error: expected ')' before '__func__'
| crypto/zlib.c:170: error: expected '}' before string constant
| crypto/zlib.c:170: error: expected ')' before '__func__'

> > BTW, Martin: Is `#define pr_fmt(fmt)     "%s: " fmt, __func__' a valid and
> > intended usage of your pr_fmt() infrastructure?
> 
> The indended use is a simple prefix to the format string. To paste an
> additional parameter is an interesting use of the pr_fmt macro ..

Bummer, I was so happy I could do things like

| #define pr_fmt(fmt)	"%s:%u: " fmt, __func__, __LINE__

...

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
