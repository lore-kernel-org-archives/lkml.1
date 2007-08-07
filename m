Return-Path: <linux-kernel-owner+w=401wt.eu-S936206AbXHGWiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbXHGWiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbXHGWil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:38:41 -0400
Received: from pat.uio.no ([129.240.10.15]:58395 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663AbXHGWij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:38:39 -0400
Subject: Re: file capabilities: clear fcaps on inode change (v3)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Serge E. Hallyn" <sergeh@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070807221727.GA12211@sergelap.austin.ibm.com>
References: <20070807221727.GA12211@sergelap.austin.ibm.com>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 18:38:05 -0400
Message-Id: <1186526285.6625.41.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.051)
X-UiO-Scanned: 03A7EA7077366ABBA5CED2C76BAAB71196080C42
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 248 total 3141985 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 17:17 -0500, Serge E. Hallyn wrote:

> diff --git a/fs/splice.c b/fs/splice.c
> index e36c003..2df95f3 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -827,6 +827,12 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
>  	ssize_t ret;
>  	int err;
>  
> +	mutex_lock(&inode->i_mutex);
> +	err = security_inode_killpriv(out->f_path.dentry);
> +	mutex_unlock(&inode->i_mutex);
> +	if (err)
> +		return err;

You are unconditionally taking the i_mutex whether or not you actually
have any capabilities to remove. Normally, removing capabilities due to
a write is something which occurs once every blue moon. Can't you
introduce a heuristic along the lines of should_remove_suid() in order
to optimise away the common case?

In addition, if you need to remove both the capabilities and the suid
bits, then it should be unnecessary to take the i_mutex twice.

> +
>  	err = should_remove_suid(out->f_path.dentry);
>  	if (unlikely(err)) {
>  		mutex_lock(&inode->i_mutex);

Trond

