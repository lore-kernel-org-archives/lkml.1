Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbXIOIje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbXIOIje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXIOIj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:39:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbXIOIjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:39:25 -0400
Date: Sat, 15 Sep 2007 01:39:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com (Paul Menage)
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add a refcount check in dput()
Message-Id: <20070915013913.880b4c70.akpm@linux-foundation.org>
In-Reply-To: <20070910221319.302473D66CF@localhost>
References: <20070910221319.302473D66CF@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 15:13:19 -0700 (PDT) menage@google.com (Paul Menage) wrote:

> Add a BUG_ON() to check for passing an unreferenced dentry to dput().
> 
> This is analogous to the similar check in dget(), and will make
> reference-counting bugs in filesystems more immediately obvious. (I
> just spent a while debugging an oops that turned out to be due to
> broken fs reference counting.)
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
>  fs/dcache.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: container-2.6.23-rc3-mm1/fs/dcache.c
> ===================================================================
> --- container-2.6.23-rc3-mm1.orig/fs/dcache.c
> +++ container-2.6.23-rc3-mm1/fs/dcache.c
> @@ -176,6 +176,7 @@ void dput(struct dentry *dentry)
>  	if (!dentry)
>  		return;
>  
> +	BUG_ON(!atomic_read(&dentry->d_count));
>  repeat:
>  	if (atomic_read(&dentry->d_count) == 1)
>  		might_sleep();

eek, much too aggressive.

I added this:

--- a/fs/dcache.c~add-a-refcount-check-in-dput
+++ a/fs/dcache.c
@@ -176,6 +176,7 @@ void dput(struct dentry *dentry)
 	if (!dentry)
 		return;
 
+	WARN_ON_ONCE(!atomic_read(&dentry->d_count));
 repeat:
 	if (atomic_read(&dentry->d_count) == 1)
 		might_sleep();
_

to the -mm-only-debugging-patches section of the -mm tree.
