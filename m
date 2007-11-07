Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXKFUKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXKFUKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbXKFUKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 15:10:24 -0500
Received: from [212.12.190.150] ([212.12.190.150]:48186 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754314AbXKFUKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:10:24 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: Introduce rootdir bootparm to select which dir to sys_chroot
Date: Wed, 7 Nov 2007 23:10:20 +0300
User-Agent: KMail/1.5
Cc: hpa@zytor.com, akpm@linux-foundation.org
References: <200711061340.26112.a1426z@gawab.com>
In-Reply-To: <200711061340.26112.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711072310.20715.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> This patch introduces a rootdir kernel boot parameter, which specifies the
> path to the kernel sys_chroot boot dir.
>
> This is useful for systems that have more than one distribution installed
> on the same fs/partition.
>
>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Al Boldi <a1426z@gawab.com>
>
> ---
>
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -252,6 +252,15 @@ __setup("rootflags=", root_data_setup);
>  __setup("rootfstype=", fs_names_setup);
>  __setup("rootdelay=", root_delay_setup);
>
> +static char * __initdata root_dir;
> +static int __init root_dir_setup(char *str)
> +{
> +	root_dir = strcat("./",str);

This line is probably using an overloaded function that does not exist.
Use this instead:

static char __initdata root_dir[128];
static int __init root_dir_setup(char *str)
{
	strcpy(root_dir, "./");
	strlcat(root_dir, str, sizeof(root_dir) - strlen(root_dir) - 1);
	return 1;
}

> +__setup("rootdir=", root_dir_setup);
> +
>  static void __init get_fs_names(char *page)
>  {
>  	char *s = page;
> @@ -469,6 +478,10 @@ void __init prepare_namespace(void)
>  	mount_root();
>  out:
>  	sys_mount(".", "/", NULL, MS_MOVE, NULL);
> +
> +	if(root_dir)
> +		sys_chdir(root_dir);
> +
>  	sys_chroot(".");
>  	security_sb_post_mountroot();
>  }


Thanks!

--
Al

