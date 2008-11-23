Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYKWBdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYKWBdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 20:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYKWBcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 20:32:53 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40769
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbYKWBcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 20:32:52 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: frans <fransmeulenbroeks@gmail.com>
Subject: Re: [PATCH] create option to compress initramfs within the kernel
Date: Sat, 22 Nov 2008 19:32:11 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
References: <alpine.DEB.1.00.0811221817560.3675@frans-desktop>
In-Reply-To: <alpine.DEB.1.00.0811221817560.3675@frans-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811221932.12518.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008 11:30:13 frans wrote:
> Below is a patch to make compression of the initramfs image optional.
> Sumbitted to LKML as there is no MAINTAINER listed for initramfs.
>
> Rationale is that if you create a compressed kernel image (e.g. by
> make bzImage) it is not very efficient and useful to compress initramfs
> as the initramfs will be compressed anyway when the kernel image is
> compressed.

Actually it saves intermediate space (the cpio archive and the decompressed 
ramfs coexist during the decompression, until the kernel can free the cpio 
archive), so it does serve a purpose.  (Given cache effects leaving it 
compressed may actually wind up being faster on modern CPUs because it dirties 
fewer pages.)

It also eats CPU, which is at more of a premium than memory on some little 
battery powered wind-up boxes.  But I'd be happier seeing some actual 
benchmark numbers on a device that would actually _notice_ this change.

> @@ -257,6 +258,9 @@ while [ $# -gt 0 ]; do
>  			default_list="$arg"
>  			${dep_list}default_initramfs
>  			;;
> +		"-c")	# compress
> +			compress=1
> +			;;

You're changing the default behavior for people who run this script directly.  
Just FYI.

> --- a/usr/Kconfig
> +++ b/usr/Kconfig
> @@ -44,3 +44,14 @@ config INITRAMFS_ROOT_GID
>  	  owned by group root in the initial ramdisk image.
>
>  	  If you are not sure, leave it set to "0".
> +
> +config INITRAMFS_COMPRESS
> +	bool "Compress initramfs image"
> +	default y
> +	help
> +	  If you want a compressed initramfs image in your kernel say y
> +	  If you do not want your initramfs image to be compressed say n.
> +	  A compressed initramfs is generally not useful if you also have a
> +	  compressed kernel (vmlinuz, bzImage).

This should probably be in the CONFIG_EMBEDDED menu.

Rob
