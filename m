Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYETH25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYETH25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 03:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYETH2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 03:28:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbYETH2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 03:28:46 -0400
Date: Tue, 20 May 2008 00:28:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Michael A. Halcrow" <mhalcrow@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] eCryptFS: fix missed mutex_unlock
Message-Id: <20080520002832.89e74522.akpm@linux-foundation.org>
In-Reply-To: <20080518142611.GA18000@cvg>
References: <20080518142611.GA18000@cvg>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008 18:26:11 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> ---
> 
> Ingo, could you please apply it and test? Actually I really doubt if it help
> with the locking problem you pointed. There are two procedures
> in miscrev.c - ecryptfs_miscdev_poll() and ecryptfs_miscdev_read()
> which takes/releases mutexes in a bit strange way... investigating,
> but this patch is needed anyway.
> 
> Index: linux-2.6.git/fs/ecryptfs/crypto.c
> ===================================================================
> --- linux-2.6.git.orig/fs/ecryptfs/crypto.c	2008-05-18 16:44:20.000000000 +0400
> +++ linux-2.6.git/fs/ecryptfs/crypto.c	2008-05-18 17:56:12.000000000 +0400
> @@ -1903,6 +1903,7 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
>  		if (rc) {
>  			printk(KERN_ERR "Error adding new key_tfm to list; "
>  					"rc = [%d]\n", rc);
> +			mutex_unlock(&key_tfm_list_mutex);
>  			goto out;
>  		}
>  	}

Better to do it this way, I think:

--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-missed-mutex_unlock
+++ a/fs/ecryptfs/crypto.c
@@ -1906,9 +1906,9 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 			goto out;
 		}
 	}
-	mutex_unlock(&key_tfm_list_mutex);
 	(*tfm) = key_tfm->key_tfm;
 	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
 out:
+	mutex_unlock(&key_tfm_list_mutex);
 	return rc;
 }
_

Holding the lock for an additional few instructions may not be strictly
needed, but we might avoid the reintroduction of such bugs?

