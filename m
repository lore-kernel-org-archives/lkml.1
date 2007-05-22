Return-Path: <linux-kernel-owner+w=401wt.eu-S966194AbXEVRnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966194AbXEVRnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXEVRnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:43:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:61560 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561AbXEVRno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=anl3UUZkqtzoNkeMpRtdfMTdu0hsUr7gqofQOC1uPRw+M3tpchu1EEe+Vg3J9h6jsMGQtxdoajChBnuk14GMPoQIXKTmcLJH3o/j0H/psiO8j0+C/23QOnhFTaayNGVidflLF8OOY0wj401CzSIfswz3GotNJgr99cLo3+nGZPg=
Date: Tue, 22 May 2007 21:43:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, xiaosuo@gmail.com
Subject: Re: + procfs-directory-entry-cleanup.patch added to -mm tree
Message-ID: <20070522174348.GA5689@martell.zuzino.mipt.ru>
References: <200705210341.l4L3f1BH001692@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705210341.l4L3f1BH001692@shell0.pdx.osdl.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 08:41:02PM -0700, akpm@linux-foundation.org wrote:
> Subject: procfs directory entry cleanup
> From: "Changli Gao" <xiaosuo@gmail.com>
>
> Function proc_register() will assign proc_dir_operations and
> proc_dir_inode_operations to ent's members proc_fops and proc_iops
> correctly if ent is a directory. So the early assignment isn't
> necessary.

> --- a/fs/proc/generic.c~procfs-directory-entry-cleanup
> +++ a/fs/proc/generic.c
> @@ -649,9 +649,6 @@ struct proc_dir_entry *proc_mkdir_mode(c
>  
>  	ent = proc_create(&parent, name, S_IFDIR | mode, 2);
>  	if (ent) {
> -		ent->proc_fops = &proc_dir_operations;
> -		ent->proc_iops = &proc_dir_inode_operations;
> -
>  		if (proc_register(parent, ent) < 0) {
>  			kfree(ent);
>  			ent = NULL;
> @@ -686,10 +683,6 @@ struct proc_dir_entry *create_proc_entry
>  
>  	ent = proc_create(&parent,name,mode,nlink);
>  	if (ent) {
> -		if (S_ISDIR(mode)) {
> -			ent->proc_fops = &proc_dir_operations;
> -			ent->proc_iops = &proc_dir_inode_operations;
> -		}
>  		if (proc_register(parent, ent) < 0) {
>  			kfree(ent);
>  			ent = NULL;

This should add race because new PDE for directory will be glued to tree
with NULL ->proc_iops and, at least, vfs_getattr() doesn't check for
NULL ->i_op.

I've tried to reproduce this scenario with udelay() inserted before
S_ISDIR checks in proc_register() but got some panic while in X,
so no cookie for me. Maybe it's impossible, indeed.

Anyway, this patch + moving ->proc_fops and ->proc_iops initialization
before gluing is OK with me.

