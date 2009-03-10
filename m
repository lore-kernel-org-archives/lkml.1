Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZCJNbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZCJNbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZCJNbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:31:21 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33454 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752996AbZCJNbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:31:20 -0400
Date: Tue, 10 Mar 2009 14:31:17 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Greg Banks <gnb@sgi.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: driver-core tree build failure
In-Reply-To: <20090310192440.949884a1.sfr@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.0903101423200.25436@vixen.sonytel.be>
References: <20090310192440.949884a1.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> crypto/zlib.c: In function 'zlib_compress_update':
> crypto/zlib.c:148: warning: initialization makes integer from pointer without a cast
> crypto/zlib.c:148: error: initializer element is not computable at load time
> crypto/zlib.c:148: error: (near initialization for 'descriptor.primary_hash')
> crypto/zlib.c:148: warning: excess elements in struct initializer
> crypto/zlib.c:148: warning: (near initialization for 'descriptor')
> 
> And many more similar.  This line is a pr_debug() statement, so the
> finger points at commit 25b67b75587d43ff3f09ad88c03c70a38372d95d
> ("dynamic debug: combine dprintk and dynamic printk") from the
> driver-core tree.
> 
> The preprocessed code looks like this:
> 
> static int zlib_compress_update(struct crypto_pcomp *tfm,
>     struct comp_request *req)
> {
>  int ret;
>  struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
>  struct z_stream_s *stream = &dctx->comp_stream;
> 
>  do { do { static struct _ddebug descriptor __attribute__((__used__)) __attribute__((section("__verbose"), aligned(8))) = { "zlib", __func__, "/scratch/sfr/next/crypto/zlib.c", "%s: " "avail_in %u, avail_out %u\n", __func__, 55, 33, 148, 0 }; if (({ int __ret = 0; if (__builtin_expect(!!((dynamic_debug_enabled & (1LL << 55)) && (dynamic_debug_enabled2 & (1LL << 33))), 0)) if (__builtin_expect(!!(descriptor.flags), 0)) __ret = 1; __ret; })) printk("<7>" "zlib" ":" "%s: " "avail_in %u, avail_out %u\n", __func__, req->avail_in, req->avail_out); } while (0); } while (0);
> 
> The problem is the line:
> 
> #define pr_fmt(fmt)     "%s: " fmt, __func__
> 
> in crypto/zlib.c which was introduced by commit
> bf68e65ec9ea61e32ab71bef59aa5d24d255241f ("crypto: zlib - New zlib crypto
> module, using pcomp") from the crypto tree.
> 
> For today, I have removed the above line from crypto/zlib.c, but
> something better needs to be done for tomorrow!

I had a closer look. It happens on all archs, if CONFIG_DYNAMIC_DEBUG=y.

crypto/zlib.c has:

    #define pr_fmt(fmt)     "%s: " fmt, __func__

If CONFIG_DYNAMIC_DEBUG is set, include/linux/kernel.h has:

#define pr_debug(fmt, ...) do { \
	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
	} while (0)

include/linux/dynamic_debug.h has:

#define dynamic_pr_debug(fmt, ...) do {					\
	static struct _ddebug descriptor				\
	__used								\
	__attribute__((section("__verbose"), aligned(8))) =		\
	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
	if (__dynamic_dbg_enabled(descriptor))				\
		printk(KERN_DEBUG KBUILD_MODNAME ":" fmt,		\
				##__VA_ARGS__);				\
	} while (0)


So in crypto/zlib.c,

| pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);

is expanded to

| do {
|   do {
|     static struct _ddebug descriptor
|       __attribute__((__used__))
|       __attribute__((section("__verbose"), aligned(8))) = {
|       "zlib",
|       __func__,
|       "crypto/zlib.c",
|       "%s: " "avail_in %u, avail_out %u\n",
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	This is the actual format string

|       __func__,
        ^^^^^^^^^
	But this is the first parameter, which should not be here!!!

|       55,
|       33,
|       150,
|       0
|     };
|     if (({
|       int __ret = 0;
|       if (__builtin_expect(!!((dynamic_debug_enabled & (1LL << 55)) &&
| 			      (dynamic_debug_enabled2 & (1LL << 33))), 0))
| 	if (__builtin_expect(!!(descriptor.flags), 0))
| 	    __ret = 1;
|       __ret;
|     }))
|     printk("<7>" "zlib" ":" "%s: " "avail_in %u, avail_out %u\n", __func__,
| 	   req->avail_in, req->avail_out);
|   } while (0);
| } while (0);

Due the the superfluous `__func__', all field members are shifted by one
position, and compilation breaks.

Apparently inside dynamic_pr_debug(), `fmt' is:

    "avail_in %u, avail_out %u\n", __func__
    
instead of only the part before the comma:

    "avail_in %u, avail_out %u\n"


For the non-CONFIG_DYNAMIC_DEBUG case, pr_debug() is expanded correctly:

DEBUG is defined:

#define pr_debug(fmt, ...) \
	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)

and the line is expanded to:

| printk("<7>" "%s: " "avail_in %u, avail_out %u\n", __func__, req->avail_in, req->avail_out);

DEBUG is not defined:

#define pr_debug(fmt, ...) \
	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })

and the line is expanded to:

| ({ if (0) printk("<7>" "%s: " "avail_in %u, avail_out %u\n", __func__, req->avail_in, req->avail_out); 0; });

Why doesn't it work for dynamic_pr_debug()?

BTW, Martin: Is `#define pr_fmt(fmt)     "%s: " fmt, __func__' a valid and
intended usage of your pr_fmt() infrastructure?

Thanks!

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
