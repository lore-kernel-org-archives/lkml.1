Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbXFBMmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbXFBMmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 08:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXFBMlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 08:41:55 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51429 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbXFBMly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 08:41:54 -0400
Date: Sat, 2 Jun 2007 14:42:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: jakub@redhat.com, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       daplas@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Section mismatches in drivers/video/console/promcon
Message-ID: <20070602124255.GA10119@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Building a kernel for sparc64 defconfig gave me following warnings:
WARNING: drivers/built-in.o(.text+0xb788): Section mismatch: reference to .init.data:promfont_unitable (between 'promcon_init_unimap' and 'promcon_init')
WARNING: drivers/built-in.o(.text+0xb790): Section mismatch: reference to .init.data:promfont_unitable (between 'promcon_init_unimap' and 'promcon_init')
WARNING: drivers/built-in.o(.text+0xb794): Section mismatch: reference to .init.data:promfont_unicount (between 'promcon_init_unimap' and 'promcon_init')
WARNING: drivers/built-in.o(.text+0xb798): Section mismatch: reference to .init.data:promfont_unicount (between 'promcon_init_unimap' and 'promcon_init')

The warnings happens because the function: promcon_init_unimap()
references promfont_unitable and promfont_unicount which are marked
__initdata by the conmakehash command in the drivers/video/console/Makefile

The function promcon_init_unimap() are referenced in two places:
1) In prom_con_init() which is marked __init => no problem.
2) In promcon_init() which is not marked __init => warning.
The actual code is here:
	if (!promcon_uni_pagedir[0] && p) {
		promcon_init_unimap(conp);
	}

I could not from the code judge if promcon_init_unimap is really
only used during early init or this is a bug.
If promcon_init_unimap() is only used during early init it
should be marked __init_refok (with a proper comment)
to silence the warning.

A few people in to: that I hope can help out (thanks to git blame)...

	Sam
