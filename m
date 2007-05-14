Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbXENKnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbXENKnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbXENKnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:43:45 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:2216 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbXENKno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l3uPOMqBQ/FhHTvUx9ceSxP+zpXvqWHDnrvo0CK1CVcVhgh/iHap5Lq5q9yau1eUu0YPt7ukT6MenpOp1mQ/Y1a9BwrRgcs8oajXo6lg0NctE3i6niv6RChRJQlOlwqKG8yWQLDj4I90NZIjknaU5dO9xq2dCl4tN7ESVtEziS4=
Message-ID: <5c77e7070705140343q51208efdk2746b4d80db353ba@mail.gmail.com>
Date: Mon, 14 May 2007 12:43:43 +0200
From: "Carsten Otte" <cotte.de@gmail.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 9/14] Union-mount readdir
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Jan Blunck" <j.blunck@tu-harburg.de>
In-Reply-To: <20070514094249.GK4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094249.GK4139@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> +/* This is a copy from fs/readdir.c */
> +struct getdents_callback {
> +       struct linux_dirent __user *current_dir;
> +       struct linux_dirent __user *previous;
> +       int count;
> +       int error;
> +};
This should go into a header file.

> +static int union_cache_find_entry(struct list_head *uc_list,
> +                                 const char *name, int namelen)
> +{
> +       struct union_cache_entry *p;
> +       int ret = 0;
> +
> +       list_for_each_entry(p, uc_list, list) {
> +               if (p->name.len != namelen)
> +                       continue;
> +               if (strncmp(p->name.name, name, namelen) == 0) {
> +                       ret = 1;
> +                       break;
> +               }
> +       }
> +       return ret;
> +}
Why not use strlen instead of having both string and length as parameter?

> +static struct file * __dentry_open_read(struct dentry *dentry,
> +                                       struct vfsmount *mnt, int flags)
> +{
> +       struct file *f;
> +       struct inode *inode;
> +       int error;
> +
> +       error = -ENFILE;
> +       f = get_empty_filp();
> +       if (!f)
> +               goto out;
This is the only case where error is not explicitly set to a different
value before hitting out/cleanup => consider setting conditionally.

so long,
Carsten
