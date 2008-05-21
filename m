Return-Path: <linux-kernel-owner+w=401wt.eu-S936595AbYEUSQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936595AbYEUSQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935209AbYEUSQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:16:39 -0400
Received: from pat.uio.no ([129.240.10.15]:55359 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935045AbYEUSQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:16:38 -0400
Subject: Re: [patch 11/14] vfs: move executable checking into ->permission()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080521171557.399850407@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
	 <20080521171557.399850407@szeredi.hu>
Content-Type: text/plain
Date: Wed, 21 May 2008 14:16:33 -0400
Message-Id: <1211393793.7486.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: 49438D10D1FED05E35F2DA7076253CBEBA2A30AB
X-UiO-SR-test: B1DA4A30A031898DC7FBBA984E6FBC92E07CBA39
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 223 total 8520121 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 19:15 +0200, Miklos Szeredi wrote:

> +/**
> + * exec_permission - check for general execute permission on file
> + * @inode:	inode to check access rights for
> + * @mask:	right to check for
> + *
> + * Exec permission on a regular file is denied if none of the execute
> + * bits are set.
> + *
> + * This needs to be called by filesystems which define a
> + * ->permission() method, and don't call generic_permission().
> + */
> +int exec_permission(struct inode *inode, int mask)
> +{
> +	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
> +	    !(inode->i_mode & S_IXUGO))
> +		return -EACCES;
> +
> +	return 0;
> +}

Hmm... What if !(mask & MAY_EXEC)? AFAICS, the above will return 0.
A better approach would be to use something like

	if (!(mask & MAY_EXEC))
		return -EACCES;
	if (S_ISREG(inode->i_mode) && !(inode->i_mode & S_IXUGO))
		return -EACCES;
	return 0;



