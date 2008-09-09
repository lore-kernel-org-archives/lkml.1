Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYIIIXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYIIIXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYIIIX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:23:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31368 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbYIIIX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a1FBGsddMLvtbqdKN/y1UNJMF7l1yhOScEDbTxz/ZwCgJiRH4DF0XolZby1MLLF3Ry
         0XLlRl+KRThTj0xfgEN2Cf6h4GOMdX9pf6yZp1FxiM7v1abeSIRrGJlI4zu/KRaURqBt
         PazJpktG5M/fdTzNpPRKtnN9w1clEJY0565RA=
Message-ID: <19f34abd0809090123y36c51395pfa694799f7a2afb@mail.gmail.com>
Date: Tue, 9 Sep 2008 10:23:25 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Oren Laadan" <orenl@cs.columbia.edu>
Subject: Re: [RFC v4][PATCH 8/9] File descriprtors (dump)
Cc: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <1220946154-15174-9-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-9-git-send-email-orenl@cs.columbia.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Below are some concerns, I would be grateful for explanations (or
pointers if I missed them before).

On Tue, Sep 9, 2008 at 9:42 AM, Oren Laadan <orenl@cs.columbia.edu> wrote:
> +/* cr_write_fd_data - dump the state of a given file pointer */
> +static int cr_write_fd_data(struct cr_ctx *ctx, struct file *file, int parent)
> +{
> +       struct cr_hdr h;
> +       struct cr_hdr_fd_data *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +       struct dentry *dent = file->f_dentry;
> +       struct inode *inode = dent->d_inode;
> +       enum fd_type fd_type;
> +       int ret;
> +
> +       h.type = CR_HDR_FD_DATA;
> +       h.len = sizeof(*hh);
> +       h.parent = parent;
> +
> +       hh->f_flags = file->f_flags;
> +       hh->f_mode = file->f_mode;
> +       hh->f_pos = file->f_pos;
> +       hh->f_uid = file->f_uid;
> +       hh->f_gid = file->f_gid;
> +       hh->f_version = file->f_version;
> +       /* FIX: need also file->f_owner */
> +
> +       switch (inode->i_mode & S_IFMT) {
> +       case S_IFREG:
> +               fd_type = CR_FD_FILE;
> +               break;
> +       case S_IFDIR:
> +               fd_type = CR_FD_DIR;
> +               break;
> +       case S_IFLNK:
> +               fd_type = CR_FD_LINK;
> +               break;
> +       default:
> +               return -EBADF;
> +       }

Should cr_hbuf_put() come before the return here?

As far as I've understood, "leaking" the buffer size/data isn't
critical (1. because it's just some extra space, and/or 2. the buffer
is discarded on error anyway). The code looks really unbalanced
without it, though. I guess it should at least be documented?

> +
> +       /* FIX: check if the file/dir/link is unlinked */
> +       hh->fd_type = fd_type;
> +
> +       ret = cr_write_obj(ctx, &h, hh);
> +       cr_hbuf_put(ctx, sizeof(*hh));
> +       if (ret < 0)
> +               return ret;
> +
> +       return cr_write_fname(ctx, &file->f_path, ctx->vfsroot);
> +}
> +
> +/**
> + * cr_write_fd_ent - dump the state of a given file descriptor
> + * @ctx: checkpoint context
> + * @files: files_struct pointer
> + * @fd: file descriptor
> + *
> + * Save the state of the file descriptor; look up the actual file pointer
> + * in the hash table, and if found save the matching objref, otherwise call
> + * cr_write_fd_data to dump the file pointer too.
> + */
> +static int
> +cr_write_fd_ent(struct cr_ctx *ctx, struct files_struct *files, int fd)
> +{
> +       struct cr_hdr h;
> +       struct cr_hdr_fd_ent *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +       struct file *file = NULL;
> +       struct fdtable *fdt;
> +       int coe, objref, new, ret;
> +
> +       rcu_read_lock();
> +       fdt = files_fdtable(files);
> +       file = fcheck_files(files, fd);
> +       if (file) {
> +               coe = FD_ISSET(fd, fdt->close_on_exec);
> +               get_file(file);
> +       }
> +       rcu_read_unlock();
> +
> +       /* sanity check (although this shouldn't happen) */
> +       if (!file)
> +               return -EBADF;
> +
> +       new = cr_obj_add_ptr(ctx, (void *) file, &objref, CR_OBJ_FILE, 0);
> +       cr_debug("fd %d objref %d file %p c-o-e %d)\n", fd, objref, file, coe);
> +
> +       if (new < 0)
> +               return new;

fput() and/or cr_hbuf_put()?

> +
> +       h.type = CR_HDR_FD_ENT;
> +       h.len = sizeof(*hh);
> +       h.parent = 0;
> +
> +       hh->objref = objref;
> +       hh->fd = fd;
> +       hh->close_on_exec = coe;
> +
> +       ret = cr_write_obj(ctx, &h, hh);
> +       cr_hbuf_put(ctx, sizeof(*hh));
> +       if (ret < 0)
> +               return ret;
> +
> +       /* new==1 if-and-only-if file was newly added to hash */
> +       if (new)
> +               ret = cr_write_fd_data(ctx, file, objref);
> +
> +       fput(file);
> +       return ret;
> +}
> +
> +int cr_write_files(struct cr_ctx *ctx, struct task_struct *t)
> +{
> +       struct cr_hdr h;
> +       struct cr_hdr_files *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +       struct files_struct *files;
> +       int *fdtable;
> +       int nfds, n, ret;
> +
> +       h.type = CR_HDR_FILES;
> +       h.len = sizeof(*hh);
> +       h.parent = task_pid_vnr(t);
> +
> +       files = get_files_struct(t);
> +
> +       hh->objref = 0; /* will be meaningful with multiple processes */
> +
> +       nfds = cr_scan_fds(files, &fdtable);
> +       if (nfds < 0) {
> +               ret = nfds;

cr_hbuf_put()?

> +               goto out;
> +       }
> +
> +       hh->nfds = nfds;
> +
> +       ret = cr_write_obj(ctx, &h, hh);
> +       cr_hbuf_put(ctx, sizeof(*hh));
> +       if (ret < 0)
> +               goto clean;
> +
> +       cr_debug("nfds %d\n", nfds);
> +       for (n = 0; n < nfds; n++) {
> +               ret = cr_write_fd_ent(ctx, files, n);
> +               if (ret < 0)
> +                       break;
> +       }
> +
> + clean:
> +       kfree(fdtable);
> + out:
> +       put_files_struct(files);
> +
> +       return ret;
> +}


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
