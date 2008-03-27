Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYC0Wgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYC0Wgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYC0Wgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:36:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37300 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYC0Wgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:36:39 -0400
Date: Thu, 27 Mar 2008 22:36:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] vfs: mountinfo: add /proc/<pid>/mountinfo
Message-ID: <20080327223624.GZ10722@ZenIV.linux.org.uk>
References: <20080327120619.031944658@szeredi.hu> <20080327122359.210920974@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327122359.210920974@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 01:06:25PM +0100, Miklos Szeredi wrote:
> +36 35 98:0 /mnt1 /mnt2 rw,noatime master:1 - ext3 /dev/root rw,errors=continue

Works for me...

> -static int show_vfsmnt(struct seq_file *m, void *v)
> +struct proc_fs_info {

struct flag_name would be better; will do on merge.

> +static void show_type(struct seq_file *m, struct super_block *sb)
> +{
> +	mangle(m, sb->s_type->name);

BTW, do we really want to bother with quoting?  Anyway, that can live
for now...

> +static int show_mountinfo(struct seq_file *m, void *v)
> +{
> +	struct proc_mounts *p = m->private;
> +	size_t count_save = m->count;

> +		/*
> +		 * Mountpoint is outside root, rewind seq_file. Ugly,
> +		 * but necessary for race-free detection of unreachable
> +		 * mountpoints.
> +		 */
> +		m->count = count_save;
> +		return 0;
> +	}

You know, _if_ we want to go that way, let's do it right; all callers
of ->show() are in seq_file.c and all of them know the previous value
of m->count.  So let's define SEQ_SKIP as 1 and teach these 3 callers
to handle it.  And make this sucker (and anything else that might want
the same kind of things) return SEQ_SKIP instead of playing with m->count
directly.

Again, will do on merge...
