Return-Path: <linux-kernel-owner+w=401wt.eu-S1767112AbXEBVzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767112AbXEBVzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767125AbXEBVzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:55:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767112AbXEBVzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:55:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] tty add compat_ioctl method
Date: Wed, 2 May 2007 23:55:38 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1177620717.5060.11.camel@amdx2.microgate.com> <200704270008.58811.arnd@arndb.de> <1178128321.9430.14.camel@amdx2.microgate.com>
In-Reply-To: <1178128321.9430.14.camel@amdx2.microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705022355.38975.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX181nfUX/buXYjgiunTNuoAVx7LRUwbzpDPFZSw
 OZAjTBGi5YBLDVNOZZ+eOV3+IWx2ESAstaNq5hnZLE2WqQrKBY
 f0nsaEC+NCF5rLgZzowPQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007, Paul Fulghum wrote:
> Add compat_ioctl method for tty code to allow processing
> of 32 bit ioctl calls on 64 bit systems by tty core,
> tty drivers, and line disciplines.

Looks ok mostly. Just some details:

> --- a/include/linux/tty_driver.h	2006-11-29 15:57:37.000000000 -0600
> +++ b/include/linux/tty_driver.h	2007-04-30 14:05:02.000000000 -0500
> @@ -132,6 +132,10 @@ struct tty_operations {
>  	int  (*chars_in_buffer)(struct tty_struct *tty);
>  	int  (*ioctl)(struct tty_struct *tty, struct file * file,
>  		    unsigned int cmd, unsigned long arg);
> +#ifdef CONFIG_COMPAT
> +	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
> +			     unsigned int cmd, unsigned long arg);
> +#endif
>  	void (*set_termios)(struct tty_struct *tty, struct termios * old);
>  	void (*throttle)(struct tty_struct * tty);
>  	void (*unthrottle)(struct tty_struct * tty);
> @@ -193,6 +197,10 @@ struct tty_driver {
>  	int  (*chars_in_buffer)(struct tty_struct *tty);
>  	int  (*ioctl)(struct tty_struct *tty, struct file * file,
>  		    unsigned int cmd, unsigned long arg);
> +#ifdef CONFIG_COMPAT
> +	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
> +			     unsigned int cmd, unsigned long arg);
> +#endif
>  	void (*set_termios)(struct tty_struct *tty, struct termios * old);
>  	void (*throttle)(struct tty_struct * tty);
>  	void (*unthrottle)(struct tty_struct * tty);

I wouldn't hide this inside of an #ifdef. The structures are all static
and therefore a single field per driver doesn't add much bload, but
being able to always assign the .compat_ioctl pointer makes the code
somewhat nicer

> --- a/drivers/char/tty_io.c	2006-11-29 15:57:37.000000000 -0600
> +++ b/drivers/char/tty_io.c	2007-04-30 14:51:01.000000000 -0500
> @@ -151,6 +151,9 @@ static int tty_open(struct inode *, stru
>  static int tty_release(struct inode *, struct file *);
>  int tty_ioctl(struct inode * inode, struct file * file,
>  	      unsigned int cmd, unsigned long arg);
> +#ifdef CONFIG_COMPAT
> +long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg);
> +#endif
>  static int tty_fasync(int fd, struct file * filp, int on);
>  static void release_mem(struct tty_struct *tty, int idx);

declarations should never be hidden inside of an #ifdef. If you want to be
extra clever here, you can do

#ifdef CONFIG_COMPAT
long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg);
#else
#define tty_compat_ioctl NULL
#endif

then you don't need an #ifdef in the code setting the function pointers.

> @@ -3284,6 +3299,32 @@ int tty_ioctl(struct inode * inode, stru
>  	return retval;
>  }
>  
> +#ifdef CONFIG_COMPAT
> +long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg)
> +{
> +	struct inode *inode = file->f_dentry->d_inode;
> +	struct tty_struct *tty;
> +	struct tty_ldisc *ld;
> +	int retval = -ENOIOCTLCMD;
> +
> +	tty = (struct tty_struct *)file->private_data;

no need for the cast, ->private_data is void*.

	Arnd <><
