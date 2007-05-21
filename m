Return-Path: <linux-kernel-owner+w=401wt.eu-S1765336AbXEUX3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765336AbXEUX3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXEUX3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:29:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:56561 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbXEUX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gYSVtBI6hI8d310Q/94Rj/vVEr0S4MhpWE0mN/lzOrsjQrbDTbceAqUcGmNbG8AjDH0p5TH09DX7ifidepwAUnJPIytq/TKpdX51DmiYOMbSLCY7Qox+v3toJcJP8MMLp5uorliXSocoiWGd4N5x7MNAp1JVuqJuLw+kFPRwwvE=
Message-ID: <86802c440705211629u3dce49cak59b69d6b00531e83@mail.gmail.com>
Date: Mon, 21 May 2007 16:29:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH]serial: make early_uart to use early_param instead of console_initcall
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705211642.05620.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705211336h76a3f41ag4847860ea6837485@mail.gmail.com>
	 <200705211642.05620.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> How about just plain "console=8250,io,..."?

then the
__setup("console", setup_console);
setup_console will think their is one ttyS8, and then ...

How about console=uart8250,...?

> I don't want to add asm-ia64/fixmap.h with dummy definitions
> just for this.
>
> Can we add this:
>
>   asm-ia64/io.h:   #define bt_ioremap ioremap
>   asm-x86_64/io.h: #define bt_ioremap early_ioremap
>
> and use bt_ioremap instead?

I will try it.

>
> > new command line will be
> >
> >       earlycon=early8250,io,0x3f8,9600n8
> >       earlycon=early8250,mmio,0xff5e0000,115200n8
> >  or
> >       console=early8250,io,0x3f8,9600n8
> >       console=early8250,mmio,0xff5e0000,115200n8
>
> If you can make "console=early8250" work, we don't need
> "earlycon=early8250", do we?

actually I modify init/main.c
diff --git a/init/main.c b/init/main.c
index 1940fa7..07dad53 100644
--- a/init/main.c
+++ b/init/main.c
@@ -452,7 +452,9 @@ static int __init do_early_param(char *param, char *val)
 	struct obs_kernel_param *p;

 	for (p = __setup_start; p < __setup_end; p++) {
-		if (p->early && strcmp(param, p->str) == 0) {
+		if ((p->early && strcmp(param, p->str) == 0) ||
+		  (strcmp(param,"console")==0 && strcmp(p->str, "earlycon")==0)
+		) {
 			if (p->setup_func(val) != 0)
 				printk(KERN_WARNING
 				       "Malformed early option '%s'\n", param);

so make earlycon early_param setup will check console command line.


>
> Your patch adds trailing whitespace and a few cases of"<space><tab>".
> I use this in my .vimrc to catch these:
>
>   highlight WhitespaceEOL ctermbg=red guibg=red
>   match WhitespaceEOL /\s\+$\| \+\ze\t/
>
I will check it.

YH
