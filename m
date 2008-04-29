Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYD2POy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYD2POy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbYD2POi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:14:38 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:23774 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbYD2POf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PBfIJbiiL2lKKYEJldm3QAUVRq1Wyd8iFWKSJh2szETgTEmtO6fmZ/7VrD5XKMezHnEA9BQKoagR9UmQZkjHZNeJre5bK8PLQyLxMwFztldDX7pLuJIQHtuS9ceth6gGviNqY/FgqVgBoumeCA8+I5nd5n+O13haBzlUEEH1obM=
Message-ID: <84144f020804290814o18f4868tf6536cc7f16cb8d7@mail.gmail.com>
Date: Tue, 29 Apr 2008 18:14:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux 2.6
Cc: "Henry Nestler" <Henry.Ne@arcor.de>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Alexander Viro" <viro@ftp.linux.org.uk>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <20080429143314.GG26461@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480E6BB4.5080902@henry.nestler.gmail.com>
	 <480E8069.20502@henry.ne.arcor.de> <20080428164634.GC18210@elte.hu>
	 <48164E29.4080409@henry.ne.arcor.de> <20080429143314.GG26461@elte.hu>
X-Google-Sender-Auth: b2a880ca5a5bd00d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 5:33 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  btw., i have a kmemcheck-reported bug fixed in this same area with the
>  patch below. I dont remember the details anymore, but the root mount
>  code did something really, really weird here.
>
>  Subject: init: root mount fix
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Tue Apr 29 16:31:50 CEST 2008
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  ---
>   init/do_mounts.c |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
>  Index: linux/init/do_mounts.c
>  ===================================================================
>  --- linux.orig/init/do_mounts.c
>  +++ linux/init/do_mounts.c
>  @@ -201,9 +201,13 @@ static int __init do_mount_root(char *na
>         return 0;
>   }
>
>  +#if PAGE_SIZE < PATH_MAX
>  +# error increase the fs_names allocation size here
>  +#endif
>
> +
>   void __init mount_block_root(char *name, int flags)
>   {
>  -       char *fs_names = __getname();
>  +       char *fs_names = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
>
>         char *p;
>   #ifdef CONFIG_BLOCK
>         char b[BDEVNAME_SIZE];
>  @@ -251,7 +255,7 @@ retry:
>
>  #endif
>         panic("VFS: Unable to mount root fs on %s", b);
>   out:
>  -       putname(fs_names);
>  +       free_pages((unsigned long)fs_names, 1);
>   }
>
>   #ifdef CONFIG_ROOT_NFS

It could have been a bug in early kmemcheck too. We don't check memory
allocated with the page allocator, only slab, so this shouldn't
trigger anything.
