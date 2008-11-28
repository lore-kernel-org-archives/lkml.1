Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYK1L2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYK1L2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYK1L14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:27:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42557 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYK1L1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:27:55 -0500
Date: Fri, 28 Nov 2008 11:27:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v10][PATCH 09/13] Restore open file descriprtors
Message-ID: <20081128112745.GR28946@ZenIV.linux.org.uk>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu> <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 08:04:40PM -0500, Oren Laadan wrote:

> +/**
> + * cr_attach_get_file - attach (and get) lonely file ptr to a file descriptor
> + * @file: lonely file pointer
> + */
> +static int cr_attach_get_file(struct file *file)
> +{
> +	int fd = get_unused_fd_flags(0);
> +
> +	if (fd >= 0) {
> +		fsnotify_open(file->f_path.dentry);
> +		fd_install(fd, file);
> +		get_file(file);
> +	}
> +	return fd;
> +}

What happens if another thread closes the descriptor in question between
fd_install() and get_file()?

> +	fd = cr_attach_file(file);	/* no need to cleanup 'file' below */
> +	if (fd < 0) {
> +		filp_close(file, NULL);
> +		ret = fd;
> +		goto out;
> +	}
> +
> +	/* register new <objref, file> tuple in hash table */
> +	ret = cr_obj_add_ref(ctx, file, parent, CR_OBJ_FILE, 0);
> +	if (ret < 0)
> +		goto out;

Who said that file still exists at that point?

BTW, there are shitloads of races here - references to fd and struct file *
are mixed in a way that breaks *badly* if descriptor table is played with
by another thread.
