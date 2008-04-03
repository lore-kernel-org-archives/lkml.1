Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbYDCBv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbYDCBv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760958AbYDCBvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:51:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50652 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760925AbYDCBvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:51:06 -0400
Message-ID: <47F4378A.2000008@cn.fujitsu.com>
Date: Thu, 03 Apr 2008 09:48:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Paul Menage <menage@google.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] cgroups: introduce cft->read_seq()
References: <20080403010130.GA20543@sergelap.austin.ibm.com>
In-Reply-To: <20080403010130.GA20543@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Hi Paul,
> 
> the following (against 2.6.25-rc8-mm1) is a first attempt
> at a simple seq_file usage in cgroups.  Comments much
> appreciated.
> 
> thanks,
> -serge
> 
>>From bd0977a5819dc43866fff325ae1e2726e747e2f4 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Wed, 2 Apr 2008 17:54:21 -0700
> Subject: [PATCH 1/1] cgroups: introduce cft->read_seq()
> 
> Introduce a read_seq() helper in cftype, which uses
> seq_file to print out lists.  Use it in the devices
> cgroup.  Also split devices.allow into two files, so
> now devices.deny and devices.allow are the ones to
> use to manipulate the whitelist, while devices.list
> outputs the cgroup's current whitelist.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  include/linux/cgroup.h   |    6 ++++
>  kernel/cgroup.c          |   22 ++++++++++++-
>  security/device_cgroup.c |   74 ++++++++++++++-------------------------------
>  3 files changed, 49 insertions(+), 53 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 2d1d151..feb83dd 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -227,6 +227,12 @@ struct cftype {
>  	 */
>  	int (*read_map) (struct cgroup *cont, struct cftype *cft,
>  			 struct cgroup_map_cb *cb);
> +	/*
> +	 * read_seq() is used for outputting a simple sequence
> +	 * using seqfile.
> +	 */
> +	int (*read_seq) (struct cgroup *cont, struct cftype *cft,
> +			 struct seq_file *m);
>  

Can't we remove read_map() ?

btw: s/cont/cgrp

>  	ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
>  			  struct file *file,
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 85f31ad..61dc509 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1518,7 +1518,7 @@ static int cgroup_map_add(struct cgroup_map_cb *cb, const char *key, u64 value)
>  	return seq_printf(sf, "%s %llu\n", key, (unsigned long long)value);
>  }
>  
> -static int cgroup_seqfile_show(struct seq_file *m, void *arg)
> +static int cgroup_map_seqfile_show(struct seq_file *m, void *arg)
>  {
>  	struct cgroup_seqfile_state *state = m->private;
>  	struct cftype *cft = state->cft;
> @@ -1529,6 +1529,13 @@ static int cgroup_seqfile_show(struct seq_file *m, void *arg)
>  	return cft->read_map(state->cgroup, cft, &cb);
>  }
>  
> +static int cgroup_simple_seqfile_show(struct seq_file *m, void *arg)
> +{
> +	struct cgroup_seqfile_state *state = m->private;
> +	struct cftype *cft = state->cft;
> +	return cft->read_seq(state->cgroup, cft, m);
> +}
> +
>  int cgroup_seqfile_release(struct inode *inode, struct file *file)
>  {
>  	struct seq_file *seq = file->private_data;
> @@ -1562,7 +1569,18 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
>  		state->cft = cft;
>  		state->cgroup = __d_cgrp(file->f_dentry->d_parent);
>  		file->f_op = &cgroup_seqfile_operations;
> -		err = single_open(file, cgroup_seqfile_show, state);
> +		err = single_open(file, cgroup_map_seqfile_show, state);
> +		if (err < 0)
> +			kfree(state);
> +	} else if (cft->read_seq) {
> +		struct cgroup_seqfile_state *state =
> +			kzalloc(sizeof(*state), GFP_USER);
> +		if (!state)
> +			return -ENOMEM;
> +		state->cft = cft;
> +		state->cgroup = __d_cgrp(file->f_dentry->d_parent);
> +		file->f_op = &cgroup_seqfile_operations;
> +		err = single_open(file, cgroup_simple_seqfile_show, state);
>  		if (err < 0)
>  			kfree(state);
>  	} else if (cft->open)
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 4237b19..68a247c 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -9,6 +9,7 @@
>  #include <linux/ctype.h>
>  #include <linux/list.h>
>  #include <linux/uaccess.h>
> +#include <linux/seq_file.h>
>  
>  #define ACC_MKNOD 1
>  #define ACC_READ  2
> @@ -201,11 +202,15 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
>  
>  #define DEVCG_ALLOW 1
>  #define DEVCG_DENY 2
> +#define DEVCG_LIST 3
> +
> +#define MAJMINLEN 10
> +#define ACCLEN 4
>  
>  static void set_access(char *acc, short access)
>  {
>  	int idx = 0;
> -	memset(acc, 0, 4);
> +	memset(acc, 0, ACCLEN);
>  	if (access & ACC_READ)
>  		acc[idx++] = 'r';
>  	if (access & ACC_WRITE)
> @@ -225,70 +230,33 @@ static char type_to_char(short type)
>  	return 'X';
>  }
>  
> -static void set_majmin(char *str, int len, unsigned m)
> +static void set_majmin(char *str, unsigned m)
>  {
> -	memset(str, 0, len);
> +	memset(str, 0, MAJMINLEN);
>  	if (m == ~0)
>  		sprintf(str, "*");
>  	else
> -		snprintf(str, len, "%d", m);
> +		snprintf(str, MAJMINLEN, "%d", m);
>  }
>  
> -static char *print_whitelist(struct dev_cgroup *devcgroup, int *len)
> +static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
> +				struct seq_file *m)
>  {
> -	char *buf, *s, acc[4];
> +	struct dev_cgroup *devcgroup = cgroup_to_devcgroup(cgroup);
>  	struct dev_whitelist_item *wh;
> -	int ret;
> -	int count = 0;
> -	char maj[10], min[10];
> -
> -	buf = kmalloc(4096, GFP_KERNEL);
> -	if (!buf)
> -		return ERR_PTR(-ENOMEM);
> -	s = buf;
> -	*s = '\0';
> -	*len = 0;
> +	char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
>  
>  	spin_lock(&devcgroup->lock);
>  	list_for_each_entry(wh, &devcgroup->whitelist, list) {
>  		set_access(acc, wh->access);
> -		set_majmin(maj, 10, wh->major);
> -		set_majmin(min, 10, wh->minor);
> -		ret = snprintf(s, 4095-(s-buf), "%c %s:%s %s\n",
> -			type_to_char(wh->type), maj, min, acc);
> -		if (s+ret >= buf+4095) {
> -			kfree(buf);
> -			buf = ERR_PTR(-ENOMEM);
> -			break;
> -		}
> -		s += ret;
> -		*len += ret;
> -		count++;
> +		set_majmin(maj, wh->major);
> +		set_majmin(min, wh->minor);
> +		seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
> +			   maj, min, acc);
>  	}
>  	spin_unlock(&devcgroup->lock);
>  
> -	return buf;
> -}
> -
> -static ssize_t devcgroup_access_read(struct cgroup *cgroup,
> -			struct cftype *cft, struct file *file,
> -			char __user *userbuf, size_t nbytes, loff_t *ppos)
> -{
> -	struct dev_cgroup *devcgroup = cgroup_to_devcgroup(cgroup);
> -	int filetype = cft->private;
> -	char *buffer;
> -	int uninitialized_var(len);
> -	int retval;
> -
> -	if (filetype != DEVCG_ALLOW)
> -		return -EINVAL;
> -	buffer = print_whitelist(devcgroup, &len);
> -	if (IS_ERR(buffer))
> -		return PTR_ERR(buffer);
> -
> -	retval = simple_read_from_buffer(userbuf, nbytes, ppos, buffer, len);
> -	kfree(buffer);
> -	return retval;
> +	return 0;
>  }
>  
>  /*
> @@ -501,7 +469,6 @@ out1:
>  static struct cftype dev_cgroup_files[] = {
>  	{
>  		.name = "allow",
> -		.read = devcgroup_access_read,
>  		.write  = devcgroup_access_write,
>  		.private = DEVCG_ALLOW,
>  	},
> @@ -510,6 +477,11 @@ static struct cftype dev_cgroup_files[] = {
>  		.write = devcgroup_access_write,
>  		.private = DEVCG_DENY,
>  	},
> +	{
> +		.name = "list",
> +		.read_seq = devcgroup_seq_read,
> +		.private = DEVCG_LIST,
> +	},
>  };
>  
>  static int devcgroup_populate(struct cgroup_subsys *ss,

