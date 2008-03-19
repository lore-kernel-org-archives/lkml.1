Return-Path: <linux-kernel-owner+w=401wt.eu-S965943AbYCSVUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965943AbYCSVUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762016AbYCSUAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48863 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761995AbYCSUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:01 -0400
Date: Wed, 19 Mar 2008 12:12:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] vfs: mountinfo: only show mounts under tasks root
Message-ID: <20080319121235.GM10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212739.736781502@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313212739.736781502@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 10:26:47PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> 1. Only show reachable mounts in /proc/<pid>/mountinfo, this makes
> mountpoints unambiguous for chrooted processes.
> 
> 2. Instead of showing mountpoints relative to the current root, always
> show them relative to the queried task's root.
> 
> This means, that a particular mountinfo file will always have the same
> contents, regardless of which process is reading the file.  Which is a
> lot more consistent, than the current behavior of /proc/<pid>/mounts.
> 
> Addressed comments from Jan Blunck and Ram Pai.

>  	return retval;
>  
>  global_root:
> +	if (only_reachable)
> +		return ERR_PTR(-EINVAL);

Humm...  Might make sense to update *root in case we hit that place and
do the rest in callers, instead of playing with extra arguments...
Hell knows, I'd try to massage in that direction and see if anything
clean shows up.

>  static int show_mountinfo(struct seq_file *m, void *v)
>  {
> +	struct proc_mounts *p = m->private;
> +	size_t count_save = m->count;

*UGH*.  Do you really need that?  Frankly, in that case I'd rather
separate the check from __d_path(); unwinds like that are Not Nice(tm).

> +	if (seq_path_root(m, &mnt_path, &p->root, " \t\n\\") == -EINVAL) {
> +		/* path is outside root */
> +		m->count = count_save;
