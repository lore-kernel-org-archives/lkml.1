Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbYBWI0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbYBWI0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933283AbYBWIJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:51 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765916AbYBWIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:06 -0500
Date: Sat, 23 Feb 2008 00:04:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, yamamoto@valinux.co.jp,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
Subject: Re: [PATCH 1/2] cgroup map files: Add cgroup map data type
Message-Id: <20080223000419.d446ac74.akpm@linux-foundation.org>
In-Reply-To: <20080221213444.898896000@menage.corp.google.com>
References: <20080221212854.408662000@menage.corp.google.com>
	<20080221213444.898896000@menage.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 13:28:55 -0800 menage@google.com wrote:

> Adds a new type of supported control file representation, a map from
> strings to u64 values.
> 
> The map type is printed in a similar format to /proc/meminfo or
> /proc/<pid>/status, i.e. "$key: $value\n"
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
>  include/linux/cgroup.h |   19 +++++++++++++++
>  kernel/cgroup.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 77 insertions(+), 1 deletion(-)
> 
> Index: cgroupmap-2.6.25-rc2-mm1/include/linux/cgroup.h
> ===================================================================
> --- cgroupmap-2.6.25-rc2-mm1.orig/include/linux/cgroup.h
> +++ cgroupmap-2.6.25-rc2-mm1/include/linux/cgroup.h
> @@ -166,6 +166,16 @@ struct css_set {
>  
>  };
>  
> +/*
> + * cgroup_map_cb is an abstract callback API for reporting map-valued
> + * control files
> + */
> +
> +struct cgroup_map_cb {
> +	int (*fill)(struct cgroup_map_cb *cb, const char *key, u64 value);
> +	void *state;
> +};
> +
>  /* struct cftype:
>   *
>   * The files in the cgroup filesystem mostly have a very simple read/write
> @@ -194,6 +204,15 @@ struct cftype {
>  	 * single integer. Use it in place of read()
>  	 */
>  	u64 (*read_uint) (struct cgroup *cont, struct cftype *cft);
> +	/*
> +	 * read_map() is used for defining a map of key/value
> +	 * pairs. It should call cb->fill(cb, key, value) for each
> +	 * entry. The key/value pairs (and their ordering) should not
> +	 * change between reboots.
> +	 */
> +	int (*read_map) (struct cgroup *cont, struct cftype *cft,
> +			 struct cgroup_map_cb *cb);
> +
>  	ssize_t (*write) (struct cgroup *cont, struct cftype *cft,
>  			  struct file *file,
>  			  const char __user *buf, size_t nbytes, loff_t *ppos);
> Index: cgroupmap-2.6.25-rc2-mm1/kernel/cgroup.c
> ===================================================================
> --- cgroupmap-2.6.25-rc2-mm1.orig/kernel/cgroup.c
> +++ cgroupmap-2.6.25-rc2-mm1/kernel/cgroup.c
> @@ -1487,6 +1487,46 @@ static ssize_t cgroup_file_read(struct f
>  	return -EINVAL;
>  }
>  
> +/*
> + * seqfile ops/methods for returning structured data. Currently just
> + * supports string->u64 maps, but can be extended in future.
> + */
> +
> +struct cgroup_seqfile_state {
> +	struct cftype *cft;
> +	struct cgroup *cgroup;
> +};
> +
> +static int cgroup_map_add(struct cgroup_map_cb *cb, const char *key, u64 value)
> +{
> +	struct seq_file *sf = cb->state;
> +	return seq_printf(sf, "%s %llu\n", key, value);
> +}

We don't know what type the architecture uses to implement u64.  This will
warn on powerpc, sparc64, maybe others.

> +static int cgroup_seqfile_show(struct seq_file *m, void *arg)
> +{
> +	struct cgroup_seqfile_state *state = m->private;
> +	struct cftype *cft = state->cft;
> +	if (cft->read_map) {
> +		struct cgroup_map_cb cb = {
> +			.fill = cgroup_map_add,
> +			.state = m,
> +		};
> +		return cft->read_map(state->cgroup, cft, &cb);
> +	} else {
> +		BUG();

That's not really needed.  Just call cft->read_map unconditionally.  if
it's zero we'll get a null-pointer deref which will have just the same
effect as a BUG.

> +	}
> +}
> +
> +int cgroup_seqfile_release(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *seq = file->private_data;
> +	kfree(seq->private);
> +	return single_release(inode, file);
> +}
> +
> +static struct file_operations cgroup_seqfile_operations;

afaict you can just move the definition of cgroup_seqfile_operations here
and avoid the forward decl.

>  static int cgroup_file_open(struct inode *inode, struct file *file)
>  {
>  	int err;
> @@ -1499,7 +1539,18 @@ static int cgroup_file_open(struct inode
>  	cft = __d_cft(file->f_dentry);
>  	if (!cft)
>  		return -ENODEV;
> -	if (cft->open)
> +	if (cft->read_map) {

But above a NULL value is illegal.  Why are we testing it here?

> +		struct cgroup_seqfile_state *state =
> +			kzalloc(sizeof(*state), GFP_USER);
> +		if (!state)
> +			return -ENOMEM;
> +		state->cft = cft;
> +		state->cgroup = __d_cgrp(file->f_dentry->d_parent);
> +		file->f_op = &cgroup_seqfile_operations;
> +		err = single_open(file, cgroup_seqfile_show, state);
> +		if (err < 0)
> +			kfree(state);
> +	} else if (cft->open)
>  		err = cft->open(inode, file);
>  	else
>  		err = 0;
> @@ -1538,6 +1589,12 @@ static struct file_operations cgroup_fil
>  	.release = cgroup_file_release,
>  };
>  
> +static struct file_operations cgroup_seqfile_operations = {
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = cgroup_seqfile_release,
> +};
> +
>  static struct inode_operations cgroup_dir_inode_operations = {
>  	.lookup = simple_lookup,
>  	.mkdir = cgroup_mkdir,
> 
> --
