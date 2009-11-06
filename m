Return-Path: <linux-kernel-owner+w=401wt.eu-S1759770AbZKFUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770AbZKFUOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 15:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759700AbZKFUOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 15:14:19 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:49503 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690AbZKFUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:14:18 -0500
Date: Fri, 6 Nov 2009 11:12:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: nir.tzachar@gmail.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, zippel@linux-m68k.org, andi@firstfloor.org
Subject: Re: [PATCH] nconfig v5
Message-Id: <20091106111232.9534f9f7.randy.dunlap@oracle.com>
In-Reply-To: <1257496614-12052-1-git-send-email-nir.tzachar@gmail.com>
References: <1257496614-12052-1-git-send-email-nir.tzachar@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AF4838A.002B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Nov 2009 10:36:54 +0200 nir.tzachar@gmail.com wrote:

> From: Nir Tzachar <nir.tzachar@gmail.com>
> 
> This patch was inspired by the kernel projects page, where an ncurses
> replacement for menuconfig was mentioned (by Sam Ravnborg).
> 
> Building on menuconfig, this patch implements a more modern look interface using
> ncurses and ncurses' satellite libraries (menu, panel, form). The implementation
> does not depend on lxdialog, which is currently distributed with the kernel.
> 
> Attached is a reworked version of nconfig. The old menuconfig navigation scheme
> was dropped, and function keys are used for special choices. Arrows are used in
> a more intuitive fashion for menu navigation.
> 
> 1) The old menuconfig bottom menu was dropped in favor of function keys (which
>    are interchangeable with regular numbers).
> 2) Arrows are used for navigation, such that <left> always goes back one menu
>    and <right> enters a sub-menu.
> 3) The exit sequence has been improved, such that it is possible to cancel the
>    exit if there are pending changes and resume editing.
> 4) All dialog boxes have an <OK> button, which is used to exit the dialog.
> 5) A 'show all symbols' option has been added, similarly to xconfig.
> 
> Please condsider this version as a proper replacement for menuconfig.
> Cheers, Nir.
> 
> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
> 
> ---
>  scripts/kconfig/nconf.c     | 1545 +++++++++++++++++++++++++++++++++++++++++++
>  scripts/kconfig/nconf.gui.c |  613 +++++++++++++++++
>  scripts/kconfig/nconf.h     |   93 +++
>  3 files changed, 2251 insertions(+), 0 deletions(-)
>  create mode 100644 scripts/kconfig/nconf.c
>  create mode 100644 scripts/kconfig/nconf.gui.c
>  create mode 100644 scripts/kconfig/nconf.h


> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> new file mode 100644
> index 0000000..b310a2c
> --- /dev/null
> +++ b/scripts/kconfig/nconf.c
> @@ -0,0 +1,1545 @@
> +/*
> + * Copyright (C) 2008 Nir Tzachar <nir.tzachar@gmail.com?
> + * Released under the terms of the GNU GPL v2.0.
> + *
> + * Derived from menuconfig.
> + *
> + */
> +#define LKC_DIRECT_LINK
> +#include "lkc.h"
> +#include "nconf.h"
> +
> +static const char nconf_readme[] = N_(

> +"Optional personality available\n"
> +"------------------------------\n"
> +"If you prefer to have all of the kernel options listed in a single\n"
> +"menu, rather than the default multimenu hierarchy, run the nconfig\n"
> +"with NCONFIG_MODE environment variable set to single_menu. Example:\n"
> +"\n"
> +"make NCONFIG_MODE = single_menu nconfig\n"

No spaces allowed around the '=' sign.


> +"\n"
> +"<Enter> will then unroll the appropriate category, or enfold it if it\n"
> +"is already unrolled.\n"
> +"\n"
> +"Note that this mode can eventually be a little more CPU expensive\n"
> +"(especially with a larger number of unrolled categories) than the\n"
> +"default mode.\n"
> +"\n"),
> +menu_no_f_instructions[] = N_(
> +" You do not have function keys support. Please follow the\n"
> +" following instructions:\n"
> +" Arrow keys navigate the menu.\n"
> +" <Enter> or <right-arrow> selects submenus --->.\n"
> +" Capital Letters are hotkeys.\n"
> +" Pressing <Y> includes, <N> excludes, <M> modularizes features.\n"
> +" Press <Esc> or <left-arrow> to go back one menu, \n"
> +" <?> or <h> for Help, </> for Search.\n"
> +" <1> is interchangable with <F1>, <2> with <F2>, etc.\n"
> +" Legend: [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
> +" <Esc> allways leaves the current window\n"),


	always

> +menu_instructions[] = N_(
> +" Arrow keys navigate the menu.\n"
> +" <Enter> or <right-arrow> selects submenus --->.\n"
> +" Capital Letters are hotkeys.\n"
> +" Pressing <Y> includes, <N> excludes, <M> modularizes features.\n"
> +" Press <Esc>, <F3> or <left-arrow> to go back one menu, \n"
> +" <?>, <F1> or <h> for Help, </> for Search.\n"
> +" <1> is interchangable with <F1>, <2> with <F2>, etc.\n"
> +" Legend: [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
> +" <Esc> allways leaves the current window\n"),

	always



When I use F7 to exit, the program hangs.  I have to kill it.
I don't see any error messages.
(I'm testing this on a 2.6.32-rc6 kernel source tree).

ncurses-5.6-41
ncurses-devel-5.6-41

---
~Randy
