Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYIJCCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYIJCCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 22:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYIJCCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 22:02:44 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:47198 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYIJCCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 22:02:43 -0400
Message-ID: <48C72A8C.1080102@cs.columbia.edu>
Date: Tue, 09 Sep 2008 22:01:48 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v4][PATCH 8/9] File descriprtors (dump)
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>	 <1220946154-15174-9-git-send-email-orenl@cs.columbia.edu> <19f34abd0809090123y36c51395pfa694799f7a2afb@mail.gmail.com>
In-Reply-To: <19f34abd0809090123y36c51395pfa694799f7a2afb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Vegard Nossum wrote:
> Hi,
> 
> Below are some concerns, I would be grateful for explanations (or
> pointers if I missed them before).

Thanks for the review !

> 
> On Tue, Sep 9, 2008 at 9:42 AM, Oren Laadan <orenl@cs.columbia.edu> wrote:
>> +/* cr_write_fd_data - dump the state of a given file pointer */
>> +static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
>> +{
>> +       struct cr_hdr h;
>> +       struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
>> +       struct dentry *dent = file->f_dentry;
>> +       struct inode *inode = dent->d_inode;
>> +       enum fd_type fd_type;
>> +       int ret;
>> +
>> +       h.type = CR_HDR_FD_DATA;
>> +       h.len = sizeof(*hh);
>> +       h.parent = parent;
>> +
>> +       hh->f_flags = file->f_flags;
>> +       hh->f_mode = file->f_mode;
>> +       hh->f_pos = file->f_pos;
>> +       hh->f_uid = file->f_uid;
>> +       hh->f_gid = file->f_gid;
>> +       hh->f_version = file->f_version;
>> +       /* FIX: need also file->f_owner */
>> +
>> +       switch (inode->i_mode & S_IFMT) {
>> +       case S_IFREG:
>> +               fd_type = CR_FD_FILE;
>> +               break;
>> +       case S_IFDIR:
>> +               fd_type = CR_FD_DIR;
>> +               break;
>> +       case S_IFLNK:
>> +               fd_type = CR_FD_LINK;
>> +               break;
>> +       default:
>> +               return -EBADF;
>> +       }
> 
> Should cr_hbuf_put() come before the return here?
> 
> As far as I've understood, "leaking" the buffer size/data isn't
> critical (1. because it's just some extra space, and/or 2. the buffer
> is discarded on error anyway). The code looks really unbalanced
> without it, though. I guess it should at least be documented?

You are right on the money: the space is allocated on a temporary
buffer that is part of the checkpoint context, and is discarded on
error (and success) anyway.

Although the code may seem somewhat unbalanced, I personally find it
useful in that it simplifies the error paths in the code. "Balancing"
the code by adding cr_hbuf_put() calls is not functionally necessary,
will clobber the code and add to its (source and compiled) size.

Certainly it could use better documentation, probably in sys.c where
they are defined. Will add.

> 
>> +
>> +       /* FIX: check if the file/dir/link is unlinked */
>> +       hh->fd_type = fd_type;
>> +
>> +       ret = cr_write_obj(ctx, &h, hh);
>> +       cr_hbuf_put(ctx, sizeof(*hh));
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       return cr_write_fname(ctx, &file->f_path, ctx->vfsroot);
>> +}
>> +
>> +/**
>> + * cr_write_fd_ent - dump the state of a given file descriptor
>> + * @ctx: checkpoint context
>> + * @files: files_struct pointer
>> + * @fd: file descriptor
>> + *
>> + * Save the state of the file descriptor; look up the actual file pointer
>> + * in the hash table, and if found save the matching objref, otherwise call
>> + * cr_write_fd_data to dump the file pointer too.
>> + */
>> +static int
>> +cr_write_fd_ent(struct cr_ctx *ctx, struct files_struct *files, int fd)
>> +{
>> +       struct cr_hdr h;
>> +       struct cr_hdr_fd_ent *hh = cr_hbuf_get(ctx, sizeof(*hh));
>> +       struct file *file = NULL;
>> +       struct fdtable *fdt;
>> +       int coe, objref, new, ret;
>> +
>> +       rcu_read_lock();
>> +       fdt = files_fdtable(files);
>> +       file = fcheck_files(files, fd);
>> +       if (file) {
>> +               coe = FD_ISSET(fd, fdt->close_on_exec);
>> +               get_file(file);
>> +       }
>> +       rcu_read_unlock();
>> +
>> +       /* sanity check (although this shouldn't happen) */
>> +       if (!file)
>> +               return -EBADF;
>> +
>> +       new = cr_obj_add_ptr(ctx, (void *) file, &objref, CR_OBJ_FILE, 0);
>> +       cr_debug("fd %d objref %d file %p c-o-e %d)\n", fd, objref, file, coe);
>> +
>> +       if (new < 0)
>> +               return new;
> 
> fput() and/or cr_hbuf_put()?

Certainly; and also the "return ret" below, too.

> 
>> +

[...]

Thanks,

Oren.

