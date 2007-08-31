Return-Path: <linux-kernel-owner+w=401wt.eu-S1762410AbXHaU1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762410AbXHaU1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759450AbXHaU06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:26:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43908 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbXHaU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:26:57 -0400
Date: Fri, 31 Aug 2007 13:24:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bill Nottingham <notting@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add CONFIG_VT_UNICODE
Message-Id: <20070831132440.43f98b73.randy.dunlap@oracle.com>
In-Reply-To: <20070831201820.GF31970@nostromo.devel.redhat.com>
References: <20070831201820.GF31970@nostromo.devel.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 16:18:20 -0400 Bill Nottingham wrote:

> As of now, the kernel defaults to non-unicode and XLATE for the keyboard.
> We've been changing this in Fedora, but that requires patching the defaults
> in the kernel.
> 
> The attached introduces CONFIG_VT_UNICODE, which sets the console in unicode
> mode by default on boot, including both the virtual terminal and the keyboard
> driver.
> 
> Signed-off-by: Bill Nottingham <notting@redhat.com>

Hi,

A diffstat would be nice.

Please document 'default_utf8=' in Documentation/kernel-parameters.txt.


> diff -up linux-2.6.22.noarch/drivers/char/keyboard.c.foo linux-2.6.22.noarch/drivers/char/keyboard.c
> --- linux-2.6.22.noarch/drivers/char/keyboard.c.foo	2007-08-30 17:18:54.000000000 -0400
> +++ linux-2.6.22.noarch/drivers/char/keyboard.c	2007-08-30 17:27:13.000000000 -0400
> @@ -1366,7 +1366,7 @@ int __init kbd_init(void)
>  		kbd_table[i].lockstate = KBD_DEFLOCK;
>  		kbd_table[i].slockstate = 0;
>  		kbd_table[i].modeflags = KBD_DEFMODE;
> -		kbd_table[i].kbdmode = VC_XLATE;
> +		kbd_table[i].kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
>  	}
>  
>  	error = input_register_handler(&kbd_handler);
> diff -up linux-2.6.22.noarch/drivers/char/vt_ioctl.c.foo linux-2.6.22.noarch/drivers/char/vt_ioctl.c
> --- linux-2.6.22.noarch/drivers/char/vt_ioctl.c.foo	2007-08-30 17:15:45.000000000 -0400
> +++ linux-2.6.22.noarch/drivers/char/vt_ioctl.c	2007-08-30 17:27:35.000000000 -0400
> @@ -1070,7 +1070,7 @@ int vt_waitactive(int vt)
>  void reset_vc(struct vc_data *vc)
>  {
>  	vc->vc_mode = KD_TEXT;
> -	kbd_table[vc->vc_num].kbdmode = VC_XLATE;
> +	kbd_table[vc->vc_num].kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
>  	vc->vt_mode.mode = VT_AUTO;
>  	vc->vt_mode.waitv = 0;
>  	vc->vt_mode.relsig = 0;
> diff -up linux-2.6.22.noarch/drivers/char/Kconfig.foo linux-2.6.22.noarch/drivers/char/Kconfig
> --- linux-2.6.22.noarch/drivers/char/Kconfig.foo	2007-08-30 17:33:41.000000000 -0400
> +++ linux-2.6.22.noarch/drivers/char/Kconfig	2007-08-30 17:33:46.000000000 -0400
> @@ -36,6 +36,23 @@ config VT
>  	  If unsure, say Y, or else you won't be able to do much with your new
>  	  shiny Linux system :-)
>  
> +config VT_UNICODE
> +	bool "Virtual console is Unicode by default"
> +	depends on VT
> +	default n
> +	---help---
> +	  If you say Y here, the virtual terminal will be in UTF-8 by default,
> +	  and the keyboard will run in unicode mode.
> +
> +	  If you say N here, the virtual terminal will not be in UTF-8 by
> +	  default, and the keyboard will run in XLATE mode.
> +
> +	  This can also be changed by passing 'default_utf8=<0|1>' on the
> +	  kernel command line.
> +
> +	  Historically, the kernel has defaulted to non-UTF8 and XLATE mode.
> +	  If unsure, say N here.
> +
>  config VT_CONSOLE
>  	bool "Support for console on virtual terminal" if EMBEDDED
>  	depends on VT
> diff -up linux-2.6.22.noarch/drivers/char/vt.c.foo linux-2.6.22.noarch/drivers/char/vt.c
> --- linux-2.6.22.noarch/drivers/char/vt.c.foo	2007-08-30 17:20:02.000000000 -0400
> +++ linux-2.6.22.noarch/drivers/char/vt.c	2007-08-30 17:26:05.000000000 -0400
> @@ -158,7 +158,11 @@ static void blank_screen_t(unsigned long
>  static void set_palette(struct vc_data *vc);
>  
>  static int printable;		/* Is console ready for printing? */
> -static int default_utf8;
> +#ifdef CONFIG_VT_UNICODE
> +int default_utf8 = 1;
> +#else
> +int default_utf8;
> +#endif
>  module_param(default_utf8, int, S_IRUGO | S_IWUSR);
>  
>  /*
> diff -up linux-2.6.22.noarch/drivers/char/sysrq.c.foo linux-2.6.22.noarch/drivers/char/sysrq.c
> --- linux-2.6.22.noarch/drivers/char/sysrq.c.foo	2007-08-30 17:16:20.000000000 -0400
> +++ linux-2.6.22.noarch/drivers/char/sysrq.c	2007-08-30 17:26:52.000000000 -0400
> @@ -107,12 +107,12 @@ static void sysrq_handle_unraw(int key, 
>  	struct kbd_struct *kbd = &kbd_table[fg_console];
>  
>  	if (kbd)
> -		kbd->kbdmode = VC_XLATE;
> +		kbd->kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
>  }
>  static struct sysrq_key_op sysrq_unraw_op = {
>  	.handler	= sysrq_handle_unraw,
>  	.help_msg	= "unRaw",
> -	.action_msg	= "Keyboard mode set to XLATE",
> +	.action_msg	= "Keyboard mode set to system default",
>  	.enable_mask	= SYSRQ_ENABLE_KEYBOARD,
>  };
>  #else
> diff -up linux-2.6.22.x86_64/include/linux/vt_kern.h.foo linux-2.6.22.x86_64/include/linux/vt_kern.h
> --- linux-2.6.22.x86_64/include/linux/vt_kern.h.foo	2007-08-30 19:35:29.000000000 -0400
> +++ linux-2.6.22.x86_64/include/linux/vt_kern.h	2007-08-30 19:35:29.000000000 -0400
> @@ -87,6 +87,7 @@ extern int unbind_con_driver(const struc
>  extern char con_buf[CON_BUF_SIZE];
>  extern struct mutex con_buf_mtx;
>  extern char vt_dont_switch;
> +extern int default_utf8;
>  
>  struct vt_spawn_console {
>  	spinlock_t lock;
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
