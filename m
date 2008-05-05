Return-Path: <linux-kernel-owner+w=401wt.eu-S932322AbYEESva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbYEESva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765057AbYEESrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:47:43 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:44260 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762406AbYEESrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:47:41 -0400
Message-ID: <00db01c8aee0$78e7bea0$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <Linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, <jsimmons@infradead.org>,
       <adaplas@gmail.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       <matan@svgalib.org>, <edward@debian.org>,
       "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: [PATCH] mdacon messing up default vc's, set default to vc13-16 again
Date: Mon, 5 May 2008 20:47:29 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX198LmF/fy0skXWwX7GaSAwqT05uFzD3lT/DxlnY
	P7gZs456xVEyhzvQo4z4fmgHyjxL00H/xoWkLr0uv5yCfBTcmu
	1nnEZRurU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mdacon incorrectly detects MDA hardware on systems without such graphics 
> card.
>
> one may load this module by chance, for example when doing some 
> systematical
> module-testing, and if there is no Monochrome Display Adapter attached , 
> module init
> renders vc1-16 completely unusable.
>
> me and others have run into this more than once. see [Bug 224522 - 
> modprobe mdacon
> freezes machine -> https://bugzilla.novell.com/show_bug.cgi?id=224522 ] 
> for example


or somebody may accidentally link it statically with the kernel.....and have 
some fun then....

http://marc.info/?l=linux-kernel&m=112550081223569&w=2
-> http://marc.info/?l=linux-kernel&m=112550983822140&w=2






>
> apparently, proper MDA detection seems to be broken for a long time - 
> seems to be
> related to those #ifdef TEST_MDA_B statements added by Edward Betts.
>
> this commit back in 2002 made things even worse :
> http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=c72757b49c88914433244757fb4967fc63546685
>
> it changed default vc allocation from 13-16 to 1-16  for no apparent 
> reason (!?) , and
> with that (and without X), mdacon grabs the vc you`re currently sitting on 
> and locks you out.
>
> this is from Kconfig :
> >config MDA_CONSOLE
> >        depends on !M68K && !PARISC && ISA
> >        tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
> >        ---help---
> >          Say Y here if you have an old MDA or monochrome Hercules 
> > graphics
> >          adapter in your system acting as a second head ( = video card). 
> > You
> >          will then be able to use two monitors with your Linux system. 
> > Do not
> >          say Y here if your MDA card is the primary card in your system; 
> > the
> >          normal VGA driver will handle it.
>
> As we can see mdacon is just meant as an additional driver for dual-head 
> setup,
> and since kernel 2.4.36 still defaults to vc13-16 ,  setting the default 
> back to that value
> again shouldn`t  do any harm.
>
> hereby i`m reverting that change, setting default back to to vc13-16 
> again.
>
> Besides the fact that mdacon may be rarely or never be used these days and 
> could
> perhaps put to trash anyway (pre-dinosaur hardware!), indeed this is not a 
> real solution,
> but at least it removes the unfortunate side-effect of messing up the vc 
> you`re working on.
>
>
> Signed-off-by: Roland Kletzing <devzero@web.de>
>
> --- drivers/video/console/mdacon.c.orig 2008-05-03 15:47:20.000000000 
> +0200
> +++ drivers/video/console/mdacon.c      2008-05-03 15:55:27.000000000 
> +0200
> @@ -71,13 +71,15 @@
>
>  /* console information */
>
> -static int     mda_first_vc = 1;
> +static int     mda_first_vc = 13;
>  static int     mda_last_vc  = 16;
>
>  static struct vc_data  *mda_display_fg = NULL;
>
>  module_param(mda_first_vc, int, 0);
> +MODULE_PARM_DESC(mda_first_vc, "First virtual console. Default: 13");
>  module_param(mda_last_vc, int, 0);
> +MODULE_PARM_DESC(mda_last_vc, "Last virtual console. Default: 16");
>
>  /* MDA register values
>   */
>


