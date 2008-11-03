Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYKCU57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYKCU57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYKCU5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:57:50 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:46107 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYKCU5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:57:49 -0500
Date: Mon, 3 Nov 2008 14:57:41 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v8][PATCH 09/12] Dump open file descriptors
Message-ID: <20081103205741.GA27841@us.ibm.com>
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu> <1225374675-22850-10-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225374675-22850-10-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still trying to figure out the cause of my BUG at dcache.c:666,
so as I walk through the code a few more nitpicks:

Quoting Oren Laadan (orenl@cs.columbia.edu):
> +int cr_scan_fds(struct files_struct *files, int **fdtable)
> +{
> +	struct fdtable *fdt;
> +	int *fds;
> +	int i, n = 0;
> +	int tot = CR_DEFAULT_FDTABLE;
> +
> +	fds = kmalloc(tot * sizeof(*fds), GFP_KERNEL);
> +	if (!fds)
> +		return -ENOMEM;
> +
> +	/*
> +	 * We assume that the target task is frozen (or that we checkpoint
> +	 * ourselves), so we can safely proceed after krealloc() from where
> +	 * we left off; in the worst cases restart will fail.
> +	 */
> +
> +	spin_lock(&files->file_lock);
> +	rcu_read_lock();
> +	fdt = files_fdtable(files);
> +	for (i = 0; i < fdt->max_fds; i++) {
> +		if (!fcheck_files(files, i))
> +			continue;
> +		if (n == tot) {
> +			/*
> +			 * fcheck_files() is safe with drop/re-acquire
> +			 * of the lock, because it tests:  fd < max_fds
> +			 */
> +			spin_unlock(&files->file_lock);
> +			rcu_read_unlock();
> +			tot *= 2;	/* won't overflow: kmalloc will fail */
> +			fds = krealloc(fds, tot * sizeof(*fds), GFP_KERNEL);
> +			if (!fds) {
> +				kfree(fds);

If !fds kfree(fds)  :)

> +				return -ENOMEM;
> +			}
> +			rcu_read_lock();
> +			spin_lock(&files->file_lock);
> +		}
> +		fds[n++] = i;
> +	}
> +	rcu_read_unlock();
> +	spin_unlock(&files->file_lock);
> +
> +	*fdtable = fds;
> +	return n;
> +}
> +static int
> +cr_write_fd_ent(struct cr_ctx *ctx, struct files_struct *files, int fd)
> +{
> +	struct cr_hdr h;
> +	struct cr_hdr_fd_ent *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +	struct file *file = NULL;
> +	struct fdtable *fdt;
> +	int objref, new, ret;
> +	int coe = 0;	/* avoid gcc warning */
> +
> +	rcu_read_lock();
> +	fdt = files_fdtable(files);
> +	file = fcheck_files(files, fd);
> +	if (file) {
> +		coe = FD_ISSET(fd, fdt->close_on_exec);
> +		get_file(file);
> +	}
> +	rcu_read_unlock();
> +
> +	/* sanity check (although this shouldn't happen) */
> +	if (!file) {
> +		ret = -EBADF;

(As mentioned on irc - and probably already fixed in your v9 - you to an
fput(NULL) in this case which will bomb)

> +		goto out;
> +	}
> +
> +	new = cr_obj_add_ptr(ctx, file, &objref, CR_OBJ_FILE, 0);
> +	cr_debug("fd %d objref %d file %p c-o-e %d)\n", fd, objref, file, coe);
> +
> +	if (new < 0) {
> +		ret = new;
> +		goto out;
> +	}
> +
> +	h.type = CR_HDR_FD_ENT;
> +	h.len = sizeof(*hh);
> +	h.parent = 0;
> +
> +	hh->objref = objref;
> +	hh->fd = fd;
> +	hh->close_on_exec = coe;
> +
> +	ret = cr_write_obj(ctx, &h, hh);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* new==1 if-and-only-if file was newly added to hash */
> +	if (new)
> +		ret = cr_write_fd_data(ctx, file, objref);
> +
> +out:
> +	cr_hbuf_put(ctx, sizeof(*hh));
> +	fput(file);
> +	return ret;
> +}
> +
> +int cr_write_files(struct cr_ctx *ctx, struct task_struct *t)
> +{
> +	struct cr_hdr h;
> +	struct cr_hdr_files *hh = cr_hbuf_get(ctx, sizeof(*hh));
> +	struct files_struct *files;
> +	int *fdtable;
> +	int nfds, n, ret;
> +
> +	h.type = CR_HDR_FILES;
> +	h.len = sizeof(*hh);
> +	h.parent = task_pid_vnr(t);
> +
> +	files = get_files_struct(t);
> +
> +	nfds = cr_scan_fds(files, &fdtable);
> +	if (nfds < 0) {
> +		put_files_struct(files);

need a cr_hbuf_put()

> +		return nfds;
> +	}
> +

(Cause of my BUG() doesn't appear to be here :( )

thanks,
-serge
