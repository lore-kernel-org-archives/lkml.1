Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYDDEXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYDDEXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 00:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYDDEWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 00:22:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYDDEWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 00:22:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LP7sILmYamQ7tfH15aqDQ+iyHZ+0K0ZdljAGUVL9sAYhioBbFr6AroJCMORbLDJef
	WqFrqH2jWN2MSrGc1IPew==
Message-ID: <6599ad830804032122w27fcb9e3jdb9259dd73681071@mail.gmail.com>
Date: Thu, 3 Apr 2008 21:22:40 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/1] cgroups: introduce cft->read_seq() (v2)
Cc: lkml <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20080403201318.GA12764@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403201318.GA12764@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 1:13 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> From 973226ae7b5f9343f50fc5fbf132175b6ec815cb Mon Sep 17 00:00:00 2001
>  From: Serge E. Hallyn <serue@us.ibm.com>
>  Date: Thu, 3 Apr 2008 12:55:39 -0700
>  Subject: [PATCH 1/1] cgroups: introduce cft->read_seq() (v2)
>
>  Introduce a read_seq() helper in cftype, which uses
>  seq_file to print out lists.  Use it in the devices
>  cgroup.  Also split devices.allow into two files, so
>  now devices.deny and devices.allow are the ones to
>  use to manipulate the whitelist, while devices.list
>  outputs the cgroup's current whitelist.
>
>  (Patch is against 2.6.25-rc8-mm1)
>
>  Changelog:
>         Apr 3: Incorporate Paul's comments.  Call cft->read_seq()
>                 read_seq_string(), and integrate its use more closely
>                 with read_map().
>
>  Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Acked-by: Paul Menage <menage@google.com>

Looks good. Thanks.

>  ---
>   include/linux/cgroup.h   |    6 ++++
>   kernel/cgroup.c          |   15 +++++----
>   security/device_cgroup.c |   74 ++++++++++++++-------------------------------
>   3 files changed, 38 insertions(+), 57 deletions(-)
>
>  diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>  index 2d1d151..b39d964 100644
>  --- a/include/linux/cgroup.h
>  +++ b/include/linux/cgroup.h
>  @@ -227,6 +227,12 @@ struct cftype {
>          */
>         int (*read_map) (struct cgroup *cont, struct cftype *cft,
>                          struct cgroup_map_cb *cb);
>  +       /*
>  +        * read_seq_string() is used for outputting a simple sequence
>  +        * using seqfile.
>  +        */
>  +       int (*read_seq_string) (struct cgroup *cont, struct cftype *cft,
>  +                        struct seq_file *m);
>
>         ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
>                           struct file *file,
>  diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>  index 85f31ad..4abd845 100644
>  --- a/kernel/cgroup.c
>  +++ b/kernel/cgroup.c
>  @@ -1522,11 +1522,14 @@ static int cgroup_seqfile_show(struct seq_file *m, void *arg)
>   {
>         struct cgroup_seqfile_state *state = m->private;
>         struct cftype *cft = state->cft;
>  -       struct cgroup_map_cb cb = {
>  -               .fill = cgroup_map_add,
>  -               .state = m,
>  -       };
>  -       return cft->read_map(state->cgroup, cft, &cb);
>  +       if (cft->read_map) {
>  +               struct cgroup_map_cb cb = {
>  +                       .fill = cgroup_map_add,
>  +                       .state = m,
>  +               };
>  +               return cft->read_map(state->cgroup, cft, &cb);
>  +       }
>  +       return cft->read_seq_string(state->cgroup, cft, m);
>   }
>
>   int cgroup_seqfile_release(struct inode *inode, struct file *file)
>  @@ -1554,7 +1557,7 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
>         cft = __d_cft(file->f_dentry);
>         if (!cft)
>                 return -ENODEV;
>  -       if (cft->read_map) {
>  +       if (cft->read_map || cft->read_seq_string) {
>                 struct cgroup_seqfile_state *state =
>                         kzalloc(sizeof(*state), GFP_USER);
>                 if (!state)
>  diff --git a/security/device_cgroup.c b/security/device_cgroup.c
>  index 4237b19..4ea5836 100644
>  --- a/security/device_cgroup.c
>  +++ b/security/device_cgroup.c
>  @@ -9,6 +9,7 @@
>   #include <linux/ctype.h>
>   #include <linux/list.h>
>   #include <linux/uaccess.h>
>  +#include <linux/seq_file.h>
>
>   #define ACC_MKNOD 1
>   #define ACC_READ  2
>  @@ -201,11 +202,15 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
>
>   #define DEVCG_ALLOW 1
>   #define DEVCG_DENY 2
>  +#define DEVCG_LIST 3
>  +
>  +#define MAJMINLEN 10
>  +#define ACCLEN 4
>
>   static void set_access(char *acc, short access)
>   {
>         int idx = 0;
>  -       memset(acc, 0, 4);
>  +       memset(acc, 0, ACCLEN);
>         if (access & ACC_READ)
>                 acc[idx++] = 'r';
>         if (access & ACC_WRITE)
>  @@ -225,70 +230,33 @@ static char type_to_char(short type)
>         return 'X';
>   }
>
>  -static void set_majmin(char *str, int len, unsigned m)
>  +static void set_majmin(char *str, unsigned m)
>   {
>  -       memset(str, 0, len);
>  +       memset(str, 0, MAJMINLEN);
>         if (m == ~0)
>                 sprintf(str, "*");
>         else
>  -               snprintf(str, len, "%d", m);
>  +               snprintf(str, MAJMINLEN, "%d", m);
>   }
>
>  -static char *print_whitelist(struct dev_cgroup *devcgroup, int *len)
>  +static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
>  +                               struct seq_file *m)
>   {
>  -       char *buf, *s, acc[4];
>  +       struct dev_cgroup *devcgroup = cgroup_to_devcgroup(cgroup);
>         struct dev_whitelist_item *wh;
>  -       int ret;
>  -       int count = 0;
>  -       char maj[10], min[10];
>  -
>  -       buf = kmalloc(4096, GFP_KERNEL);
>  -       if (!buf)
>  -               return ERR_PTR(-ENOMEM);
>  -       s = buf;
>  -       *s = '\0';
>  -       *len = 0;
>  +       char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
>
>         spin_lock(&devcgroup->lock);
>         list_for_each_entry(wh, &devcgroup->whitelist, list) {
>                 set_access(acc, wh->access);
>  -               set_majmin(maj, 10, wh->major);
>  -               set_majmin(min, 10, wh->minor);
>  -               ret = snprintf(s, 4095-(s-buf), "%c %s:%s %s\n",
>  -                       type_to_char(wh->type), maj, min, acc);
>  -               if (s+ret >= buf+4095) {
>  -                       kfree(buf);
>  -                       buf = ERR_PTR(-ENOMEM);
>  -                       break;
>  -               }
>  -               s += ret;
>  -               *len += ret;
>  -               count++;
>  +               set_majmin(maj, wh->major);
>  +               set_majmin(min, wh->minor);
>  +               seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
>  +                          maj, min, acc);
>         }
>         spin_unlock(&devcgroup->lock);
>
>  -       return buf;
>  -}
>  -
>  -static ssize_t devcgroup_access_read(struct cgroup *cgroup,
>  -                       struct cftype *cft, struct file *file,
>  -                       char __user *userbuf, size_t nbytes, loff_t *ppos)
>  -{
>  -       struct dev_cgroup *devcgroup = cgroup_to_devcgroup(cgroup);
>  -       int filetype = cft->private;
>  -       char *buffer;
>  -       int uninitialized_var(len);
>  -       int retval;
>  -
>  -       if (filetype != DEVCG_ALLOW)
>  -               return -EINVAL;
>  -       buffer = print_whitelist(devcgroup, &len);
>  -       if (IS_ERR(buffer))
>  -               return PTR_ERR(buffer);
>  -
>  -       retval = simple_read_from_buffer(userbuf, nbytes, ppos, buffer, len);
>  -       kfree(buffer);
>  -       return retval;
>  +       return 0;
>   }
>
>   /*
>  @@ -501,7 +469,6 @@ out1:
>   static struct cftype dev_cgroup_files[] = {
>         {
>                 .name = "allow",
>  -               .read = devcgroup_access_read,
>                 .write  = devcgroup_access_write,
>                 .private = DEVCG_ALLOW,
>         },
>  @@ -510,6 +477,11 @@ static struct cftype dev_cgroup_files[] = {
>                 .write = devcgroup_access_write,
>                 .private = DEVCG_DENY,
>         },
>  +       {
>  +               .name = "list",
>  +               .read_seq_string = devcgroup_seq_read,
>  +               .private = DEVCG_LIST,
>  +       },
>   };
>
>   static int devcgroup_populate(struct cgroup_subsys *ss,
>  --
>  1.5.3.6
>
>
