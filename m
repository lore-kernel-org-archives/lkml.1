Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbYLPF6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYLPF6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 00:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYLPF6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 00:58:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbYLPF6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 00:58:08 -0500
Date: Mon, 15 Dec 2008 21:57:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander Viro <aviro@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs - fix name overwrite in __register_chrdev_region
Message-Id: <20081215215706.7707315c.akpm@linux-foundation.org>
In-Reply-To: <20081213214911.GI16354@localhost>
References: <20081213214911.GI16354@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2008 00:49:11 +0300 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> It's possible to register chdev with a name size
> exactly the same as was allocated in structure.
> It seems it was not intedned behaviour.
> 
> At least chrdev_show does not like it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
>  fs/char_dev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.git/fs/char_dev.c
> ===================================================================
> --- linux-2.6.git.orig/fs/char_dev.c
> +++ linux-2.6.git/fs/char_dev.c
> @@ -120,7 +120,7 @@ __register_chrdev_region(unsigned int ma
>  	cd->major = major;
>  	cd->baseminor = baseminor;
>  	cd->minorct = minorct;
> -	strncpy(cd->name,name, 64);
> +	strncpy(cd->name, name, sizeof(cd->name) - 1);
>  
>  	i = major_to_index(major);
>  

OK.

strlcpy() prodces a more pleasing result:

--- a/fs/char_dev.c~fs-fix-name-overwrite-in-__register_chrdev_region
+++ a/fs/char_dev.c
@@ -120,7 +120,7 @@ __register_chrdev_region(unsigned int ma
 	cd->major = major;
 	cd->baseminor = baseminor;
 	cd->minorct = minorct;
-	strncpy(cd->name,name, 64);
+	strlcpy(cd->name, name, sizeof(cd->name));
 
 	i = major_to_index(major);
 
_

