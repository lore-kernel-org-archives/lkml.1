Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYKZNeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYKZNeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYKZNeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:34:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbYKZNeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:34:12 -0500
Date: Wed, 26 Nov 2008 14:33:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 15/24] perfmon: context creation
Message-ID: <20081126133353.GA6562@elte.hu>
References: <492d0bfd.0af6660a.37d8.4b8b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0bfd.0af6660a.37d8.4b8b@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* eranian@googlemail.com <eranian@googlemail.com> wrote:

> +/**
> + * pfm_undo_create -- undo context creation
> + * @fd: file descriptor to close
> + * @ctx: newly created context
> + *
> + * upon return neither fd nor ctx are useable
> + */
> +void pfm_undo_create(int fd, struct pfm_context *ctx)
> +{
> +       struct files_struct *files = current->files;
> +       struct file *file;
> +       int fput_needed;
> +
> +       file = fget_light(fd, &fput_needed);
> +       /*
> +	* there is no fd_uninstall(), so we do it
> +	* here. put_unused_fd() does not remove the
> +	* effect of fd_install().
> +	*/
> +
> +       spin_lock(&files->file_lock);
> +       files->fd_array[fd] = NULL;
> +       spin_unlock(&files->file_lock);
> +
> +       fput_light(file, fput_needed);
> +
> +       /*
> +	* decrement ref count and kill file
> +	*/
> +       put_filp(file);
> +
> +       put_unused_fd(fd);
> +
> +       pfm_free_context(ctx);
> +}

This function is superfluous.

The only place where this is used is when a fresh sys_pfm_create() 
fails to do a user-copy of the sif:

+       if (ureq && copy_to_user(ureq, &sif, sizeof(sif))) {
+               pfm_undo_create(ret, new_ctx);
+               ret  = -EFAULT;
+       }

but this code should be calling sys_close(fd) instead - the fd is 
already set up with pfm_fs so it will tear down the context if this 
was the last user of the perfmon context.

So basically pfm_undo_create() is an open-coded sys_close(fd).

	Ingo
