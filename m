Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYIKGif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYIKGif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 02:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYIKGiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 02:38:22 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:51108 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYIKGiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 02:38:21 -0400
Message-ID: <48C8BC8C.8080704@cs.columbia.edu>
Date: Thu, 11 Sep 2008 02:37:00 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: MinChan Kim <minchan.kim@gmail.com>
CC: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v4][PATCH 8/9] File descriprtors (dump)
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>	 <1220946154-15174-9-git-send-email-orenl@cs.columbia.edu> <28c262360809102202t73c12a09uc6edd5ce93ce36d3@mail.gmail.com>
In-Reply-To: <28c262360809102202t73c12a09uc6edd5ce93ce36d3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



MinChan Kim wrote:
> On Tue, Sep 9, 2008 at 4:42 PM, Oren Laadan <orenl@cs.columbia.edu> wrote:

[...]

>> +#define CR_DEFAULT_FDTABLE  256                /* an initial guess */
>> +
>> +/**
>> + * cr_scan_fds - scan file table and construct array of open fds
>> + * @files: files_struct pointer
>> + * @fdtable: (output) array of open fds
>> + * @return: the number of open fds found
>> + *
>> + * Allocates the file descriptors array (*fdtable), caller should free
>> + */
>> +int cr_scan_fds(struct files_struct *files, int **fdtable)
>> +{
>> +       struct fdtable *fdt;
>> +       int *fdlist;
>> +       int i, n, max;
>> +
>> +       n = 0;
>> +       max = CR_DEFAULT_FDTABLE;
> 
> max is read-only variable so that you don't need to declare local variable.
> You can use macro.

It's actually used below - track size in case of krealloc()

> 
>> +       fdlist = kmalloc(max * sizeof(*fdlist), GFP_KERNEL);
>> +       if (!fdlist)
>> +               return -ENOMEM;
>> +
>> +       spin_lock(&files->file_lock);
>> +       fdt = files_fdtable(files);
>> +       for (i = 0; i < fdt->max_fds; i++) {
>> +               if (!fcheck_files(files, i))
>> +                       continue;
>> +               if (n == max) {
>> +                       /* fcheck_files() is safe with drop/re-acquire
>> +                        * of the lock, as it tests:  fd < max_fds */
>> +                       spin_unlock(&files->file_lock);
>> +                       max *= 2;
>> +                       if (max < 0) {  /* overflow ? */
>> +                               n = -EMFILE;
>> +                               goto out;
>> +                       }
>> +                       fdlist = krealloc(fdlist, max, GFP_KERNEL);
>> +                       if (!fdlist) {
>> +                               n = -ENOMEM;
>> +                               goto out;
>> +                       }
>> +                       spin_lock(&files->file_lock);
>> +               }
>> +               fdlist[n++] = i;
>> +       }
>> +       spin_unlock(&files->file_lock);
>> +
>> +       *fdtable = fdlist;
>> + out:
>> +       return n;
>> +}

[...]

>> +int cr_write_files(struct cr_ctx *ctx, struct task_struct *t)
>> +{
>> +       struct cr_hdr h;
>> +       struct cr_hdr_files *hh = cr_hbuf_get(ctx, sizeof(*hh));
>> +       struct files_struct *files;
>> +       int *fdtable;
>> +       int nfds, n, ret;
>> +
>> +       h.type = CR_HDR_FILES;
>> +       h.len = sizeof(*hh);
>> +       h.parent = task_pid_vnr(t);
>> +
>> +       files = get_files_struct(t);
>> +
>> +       hh->objref = 0; /* will be meaningful with multiple processes */
>> +
>> +       nfds = cr_scan_fds(files, &fdtable);
>> +       if (nfds < 0) {
>> +               ret = nfds;
>> +               goto out;
>> +       }
>> +
>> +       hh->nfds = nfds;
>> +
>> +       ret = cr_write_obj(ctx, &h, hh);
>> +       cr_hbuf_put(ctx, sizeof(*hh));
>> +       if (ret < 0)
>> +               goto clean;
>> +
>> +       cr_debug("nfds %d\n", nfds);
>> +       for (n = 0; n < nfds; n++) {
>> +               ret = cr_write_fd_ent(ctx, files, n);
> 
> I think your intention is not 'n' but 'fdtable[n]' in argument.

Oops ... yes. Thanks.

[...]

Oren.


