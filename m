Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbZJ2FMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbZJ2FMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 01:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZJ2FMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 01:12:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43305 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZJ2FMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 01:12:07 -0400
Date: Thu, 29 Oct 2009 00:12:11 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 01/25] LSM: Add security_path_chmod() and
	security_path_chown().
Message-ID: <20091029051211.GB11558@us.ibm.com>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp> <20091004125327.105675949@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004125327.105675949@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> This patch allows pathname based LSM modules to check chmod()/chown()
> operations. Since notify_change() does not receive "struct vfsmount *",
> we add security_path_chmod() and security_path_chown() to the caller of
> notify_change().
> 
> These hooks are used by TOMOYO.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  fs/open.c                |   24 ++++++++++++++++++++----
>  include/linux/security.h |   30 ++++++++++++++++++++++++++++++
>  security/capability.c    |   13 +++++++++++++
>  security/security.c      |   15 +++++++++++++++
>  4 files changed, 78 insertions(+), 4 deletions(-)
> 
> --- security-testing-2.6.orig/fs/open.c
> +++ security-testing-2.6/fs/open.c
> @@ -616,6 +616,9 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd
>  	err = mnt_want_write_file(file);
>  	if (err)
>  		goto out_putf;
> +	err = security_path_chmod(dentry, file->f_vfsmnt, mode);
> +	if (err)
> +		goto out_drop_write;
>  	mutex_lock(&inode->i_mutex);

Isn't doing the security check before the mutex_lock racy?

Any reason not to move it into the lock?  (since you had
considered putting a path hook in notify_change() I assume
not?)

-serge
