Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbXJDWpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbXJDWpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbXJDWpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:45:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758242AbXJDWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:45:05 -0400
Date: Thu, 4 Oct 2007 15:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, jakub.bogusz@gemius.pl
Subject: Re: [patch 02/12] fuse: fix race between getattr and write
Message-Id: <20071004154348.71535f47.akpm@linux-foundation.org>
In-Reply-To: <20071002155213.312599553@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
	<20071002155213.312599553@szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 17:50:28 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> @@ -228,6 +243,7 @@ static struct dentry *fuse_lookup(struct
>  	struct fuse_conn *fc = get_fuse_conn(dir);
>  	struct fuse_req *req;
>  	struct fuse_req *forget_req;
> +	u64 attr_version;
>  
>  	if (entry->d_name.len > FUSE_NAME_MAX)
>  		return ERR_PTR(-ENAMETOOLONG);
> @@ -242,6 +258,10 @@ static struct dentry *fuse_lookup(struct
>  		return ERR_PTR(PTR_ERR(forget_req));
>  	}
>  
> +	spin_lock(&fc->lock);
> +	attr_version = fc->attr_version;
> +	spin_unlock(&fc->lock);

You might want to do this (oft-repeated) operation in a little helper
function.

Because I suspect that the lock isn't needed if CONFIG_64BIT=y.
