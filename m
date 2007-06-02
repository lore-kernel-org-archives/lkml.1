Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbXFBNZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbXFBNZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 09:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbXFBNYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 09:24:53 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:11855 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbXFBNYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 09:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jdWdxE6WuGfwEUAECQw+XHOFWzPsO4S8JSO9CXT/o/ZXb82GxqjJVI/bDL4cEog8aGXnQfwQZXwEZ7KScSVQBWhq7BMMbxZETxowhr6d7nbTPeX22PvCtkZ7nV6OKk54hr40NkBzHpg5Y/Xyct0BHjvuFFsKmIxPkjSIajIieGM=
Subject: Re: Section mismatches in drivers/video/console/promcon
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: jakub@redhat.com, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       daplas@gmail.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070602124255.GA10119@uranus.ravnborg.org>
References: <20070602124255.GA10119@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 02 Jun 2007 21:24:43 +0800
Message-Id: <1180790683.4524.13.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-02 at 14:42 +0200, Sam Ravnborg wrote:
> Building a kernel for sparc64 defconfig gave me following warnings:
> WARNING: drivers/built-in.o(.text+0xb788): Section mismatch: reference to .init.data:promfont_unitable (between 'promcon_init_unimap' and 'promcon_init')
> WARNING: drivers/built-in.o(.text+0xb790): Section mismatch: reference to .init.data:promfont_unitable (between 'promcon_init_unimap' and 'promcon_init')
> WARNING: drivers/built-in.o(.text+0xb794): Section mismatch: reference to .init.data:promfont_unicount (between 'promcon_init_unimap' and 'promcon_init')
> WARNING: drivers/built-in.o(.text+0xb798): Section mismatch: reference to .init.data:promfont_unicount (between 'promcon_init_unimap' and 'promcon_init')
> 
> The warnings happens because the function: promcon_init_unimap()
> references promfont_unitable and promfont_unicount which are marked
> __initdata by the conmakehash command in the drivers/video/console/Makefile
> 
> The function promcon_init_unimap() are referenced in two places:
> 1) In prom_con_init() which is marked __init => no problem.
> 2) In promcon_init() which is not marked __init => warning.
> The actual code is here:
> 	if (!promcon_uni_pagedir[0] && p) {
> 		promcon_init_unimap(conp);
> 	}
> 

>  could not from the code judge if promcon_init_unimap is really
> only used during early init or this is a bug.

promcon_init() can be called again from visual_init() during
vc_allocate().  So anything referenced by promcon_init() should not be
marked __init.

Although, if you want to keep promfont_unitable and promfont_unicount
__init, you can probably use con_copy_unimap() using the default vc as
the source instead of doing a promcon_init_unimap() again.

Tony


