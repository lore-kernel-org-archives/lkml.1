Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbXIHPCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbXIHPCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 11:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXIHPCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 11:02:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:61477 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXIHPCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 11:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ch4xB6nbbxcFM+5iTB+ou+13TJtB4ahpOcPgEFpSjdyseCDByK4SDEfPhdOglmPUP8TLgpYmtZTEzvbjfxtduC6m4Apn8fz1PpXkFmvG1/FnGJFtRTG5GxANRYj6ZcSR+JRb3R41rR2IZvOp2EbGd2qlKg7RHdsBsqArRjY+S8E=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] build system: section garbage collection for vmlinux
Date: Sat, 8 Sep 2007 16:02:28 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709051447.00774.vda.linux@googlemail.com> <20070905200750.GA30812@uranus.ravnborg.org>
In-Reply-To: <20070905200750.GA30812@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081602.28216.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2007 21:07, Sam Ravnborg wrote:
> On Wed, Sep 05, 2007 at 02:47:00PM +0100, Denys Vlasenko wrote:
> > On Wednesday 05 September 2007 14:43, Denys Vlasenko wrote:
> > > These patches fix section names and add
> > > CONFIG_DISCARD_UNUSED_SECTIONS. It is not enabled
> > > unconditionally because only newest binutils have
> > > ld --gc-sections which is stable enough for kernel use.
> > > IOW: this is an experimental feature for now.
> > 
> > Part 1: fix section names over entire source (all arches).
> > 
> > Patch is big and boring global s/.text.lock/.text_lock/
> > type thing.
> 
> The normal naming scheme seems to be:
> .<usage>.text so in your example it would be: .lock.text
> See the naming of init and exit sections (that was renamed
> during 2.5 to be compatible with -ffunction-sections).

Well, there seems to be a problem at least with .bss:

http://sourceware.org/bugzilla/show_bug.cgi?id=5006

With __attribute__((section(".bss.page_aligned")))
gcc will produce .bss.page_aligned section
with NOBITS attribute, purely on the basis
of section name starting by '.bss.'

With __attribute__((section(".bss_page_aligned"))),
section will get PROGBITS attribute instead.

Combining NOBITS and PROGBITS sections into one .bss
section is not funny.

IOW: at least for bss, we _must_ use ".bss.xxx" names.

I propose (and will implement in next round of patches)
.bss.k.page_aligned ('k' for 'kernel').

Lickily, we alctually have only one special bss section
on kernel today.

Sam, my question - should I also do the same for text/rodata/data,
just for paranoid reasons?
--
vda
