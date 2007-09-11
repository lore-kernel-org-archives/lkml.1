Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXIKObc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXIKObc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbXIKObX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:31:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:42764 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbXIKObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:31:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MqTQoCwMbA9pNwjnSP0SRjpmPsN4IWiYms6RT3eHPH5zBL0qzQHlZ0BfWetGvkNGLNq5HmMmYmHDzbGl8ySmFSbZdMBjgwpXZlpRzMdg1vmZBCIiIJ7SZB28Qh3dd8wBMr0U8wXbDrVxiB/6w9HHNF7PufB/itbQ4NT9whRzon8=
Message-ID: <a4e6962a0709110731i416c7d98nc81b9f6a50a1377c@mail.gmail.com>
Date: Tue, 11 Sep 2007 09:31:19 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Subject: Re: [V9fs-developer] [PATCH] 9p: attach-per-user
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
In-Reply-To: <20070903201806.GA21504@ionkov.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070903201806.GA21504@ionkov.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
>
> This patch improves the 9P2000 support by allowing every user to attach
> separately. The patch defines three modes of access (new mount option
> 'access'):
>

nit picks:
   * you added/changed options without updated Documentation/filesystems/9p.txt
   * you changed v9fs->extended to be part of a flags structure, that
should have been
       a separate patch
   * rename of options should have been done in a separate patch

> - attach-per-user (access=user)
>  If a user tries to access a file served by v9fs for the first time, v9fs
>  sends an attach command to the server (Tattach) specifying the user. If
>  the attach succeeds, the user can access the v9fs tree.
>  As there is no uname->uid (string->integer) mapping yet, this mode works
>  only with the 9P2000.u dialect.
>
> - allow only one user to access the tree (access=<uid>)
>  Only the user with uid can access the v9fs tree. Other users that attempt
>  to access it will get EPERM error.
>
> - do all operations as a single user (access=any)
>  V9fs does a single attach and all operations are done as a single user.
>  If this mode is selected, the v9fs behavior is identical with the current
>  one.
>

Which option is default?

>
>  /**
> - * v9fs_fid_insert - add a fid to a dentry
> + * v9fs_fid_add - add a fid to a dentry
> + * @dentry: dentry that the fid is being added to
>   * @fid: fid to add
> - * @dentry: dentry that it is being added to
>   *
>   */
>
> @@ -66,52 +67,144 @@ int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid)
>  }

Even small cleanups like this should probably be confined to a
separate patch if they are unrelated.

>
> -struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
> +static struct p9_fid *v9fs_fid_find(struct dentry *dentry, u32 uid, int any)
>  {
...
>
> -struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
> +struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
>  {
...
> +
> +struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
> +{

The way the patch got formatted, these look like compulsive
renames..but there's an added function and then changes to the other
two.  I think it might be because of the way you ordered the
functions.  Put new functions after the old functions and maybe this
won't happen.  And clone seems to have lost his function header.  The
code is pretty inconsistent about those these days, but I'd like to do
an audit soon and make sure we have proper comment blocks where
appropriate.

scripts/checkpatch.pl reports:

ERROR: need a space before the open parenthesis '('
#244: FILE: fs/9p/fid.c:147:
+               for(ds = dentry; !IS_ROOT(ds); ds = ds->d_parent)

ERROR: need a space before the open parenthesis '('
#275: FILE: fs/9p/fid.c:178:
+       for(d = dentry, i = n; i >= 0; i--, d = d->d_parent)

Please fix up these small bits and resubmit.

                 -eric


Also, go ahead and cc: me directly on patches, for some reason this
one missed my normal filters and got lost.  If I'm directly cc:'d it
will pop to the top of my inbox.

           -eric
