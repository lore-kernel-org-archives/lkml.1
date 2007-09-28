Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbXI1Hbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbXI1Hbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 03:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXI1HbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 03:31:25 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:35068 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXI1HbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 03:31:24 -0400
Date: Fri, 28 Sep 2007 09:31:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Holzheu <holzheu@linux.vnet.ibm.com>,
       Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>,
       Jesse Barnes <jesse.barnes@intel.com>, Arnd Bergmann <arnd@arndb.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Emil Medve <Emilian.Medve@freescale.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
Subject: Re: [RFC] New kernel-message logging API (take 2)
In-Reply-To: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709280922230.32185@anakin>
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Vegard Nossum wrote:
>   It should be possible to optimize out multi-line (block) entries
> based on log-level filtering even though the log-level is only given
> in the first call (the initializer). It may take the shape of an
> if-block that spans several macros. This is not very elegant or robust
> if the macros are used incorrectly, however. Aborting a message can
> also be hard this way (since the abort would usually appear inside an
> if-statement that tests for some abnormal condition, thus appear in a
> different block, and thoroughly mess up the bracket order).
> 
> Example: {
> 	#define kprint_block_init(block, loglevel)		\
> 		if(loglevel > CONFIG_KPRINT_LOGLEVEL_MAX) {	\
> 			kprint_real_block_init(block, loglevel);
> 
> 	#define kprint_block(block, fmt, ...)			\
> 		kprint_real_block(block, fmt, ## __VA_ARGS__);
> 
> 	#define kprint_block_flush(block)			\
> 			kprint_real_block_flush(block);		\
> 		}
> 
> 	/* Thus, this C code: */
> 	kprint_block_init(&block, KPRINT_INFO);
> 	kprint_block(&block, "Hello world");
> 	kprint_block_flush(&block);
> 
> 	/* Would pre-process into this: */
> 	if(6 < 4) {
> 		kprint_real_block_init(&block, 6);
> 		kprint_real_block(&block, "Hello world");
> 		kprint_block_flush(&block);
> 	}
> }

If-blocks spanning macros are really dangerous!

E.g. an Ethernet driver may want to do:

	kprint_block(&block, "MAC ");
	for (i = 0; i < 6; i++) {
		card->mac[i] = obtain_mac_byte_from_hw(i);
		kprint_block(&block, "%02x", card->mac[i]);
	}

This looks (and should be) innocent, but the actual MAC addres retrieval
would never be executed if loglevel <= CONFIG_KPRINT_LOGLEVEL_MAX.

Can't you store the loglevel in the kprint_block and check it in all
successive kprint_*() macros? If gcc knows it's constant, it can optimize
the non-wanted code away. As other fields in struct kprint_block cannot be
constant (they store internal state), you have to split it like:

    struct kprint_block {
	    int loglevel;
	    struct real_kprint_block real;  /* internal state */
    }

and pass &block.real() instead of &block to all successive internal functions.
I haven't tried this, so let's hope gcc is actually smart enough...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
