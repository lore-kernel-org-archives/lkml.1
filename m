Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbXBEAPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbXBEAPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 19:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXBEAPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 19:15:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:43078 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbXBEAPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 19:15:52 -0500
From: Neil Brown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 5 Feb 2007 11:15:21 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17862.30489.694079.138765@notabene.brown>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Tony Jones <tonyj@suse.de>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
In-Reply-To: message from Andreas Gruenbacher on Friday February 2
References: <200702021923.02491.agruen@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday February 2, agruen@suse.de wrote:
> Hello,
> 
> here is a bugfix to d_path. Please apply (after 2.6.20).

Looks good!  Just a couple of little comments (to prove that I have
really read it and thought about it :-)

> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Reviewed-by: NeilBrown <neilb@suse.de>

> 
> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c
> +++ linux-2.6/fs/dcache.c
> @@ -1739,45 +1739,43 @@ shouldnt_be_hashed:
>   * @rootmnt: vfsmnt to which the root dentry belongs
>   * @buffer: buffer to return value in
>   * @buflen: buffer length
> + * @fail_deleted: what to return for deleted files
>   *
> - * Convert a dentry into an ASCII path name. If the entry has been deleted
> - * the string " (deleted)" is appended. Note that this is ambiguous.
> + * Convert a dentry into an ASCII path name. If the entry has been deleted,
> + * then if @fail_deleted is true, ERR_PTR(-ENOENT) is returned. Otherwise,
> + * the the string " (deleted)" is appended. Note that this is ambiguous.

The behaviour in the face of a lazy unmount should be clarified in
this comment.

And I cannot help wondering if that behaviour should - in some cases -
be 'fail'.

i.e. if sys_getcwd is called on a directory that is no longer
connected to the root, it isn't clear to me that it should return
without an error.
Without your patch it can return garbage which is clearly wrong.
With you patch it will return a relative path name, which is also
wrong (it isn't a valid path that leads to the current working directory).
I would suggest that 'fail_deleted' be (e.g.) changed to
'fail_condition' where two conditions are defined
#define DPATH_FAIL_DELETED 1
#define DPATH_FAIL_DISCONNECTED 2

and both these are passed in by sys_getcwd.


> @@ -1791,33 +1789,49 @@ static char * __d_path( struct dentry *d
>  		parent = dentry->d_parent;
>  		prefetch(parent);
>  		namelen = dentry->d_name.len;
> -		buflen -= namelen + 1;
> -		if (buflen < 0)
> +		if (buflen <= namelen)
>  			goto Elong;

This bothers me.  You appear to be comparing buflen with namelen, but
are about the change buflen by 'namelen + 1'.  It looks like a bug.

In reality, you are comparing "buflen < namelen+1" but spelling it as
"buflen <= namelen".  I would prefer the full spelling with least room
for confusion.


> -		end -= namelen;
> -		memcpy(end, dentry->d_name.name, namelen);
> -		*--end = '/';
> -		retval = end;
> +		buflen -= namelen + 1;
> +		buffer -= namelen;
> +		memcpy(buffer, dentry->d_name.name, namelen);
> +		*--buffer = '/';

This wouldn't be my preference either.  It is important that 'buflen'
and 'buffer' move in step, but when I see
		buflen -= namelen + 1;
		buffer -= namelen;
it looks like they aren't.  Maybe:
> +		buflen -= namelen + 1;
> +		buffer -= namelen + 1;
> +		memcpy(buffer+1, dentry->d_name.name, namelen);
> +		*buffer = '/';

or am I being too picky?

NeilBrown
