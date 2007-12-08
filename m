Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbXLHRPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbXLHRPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXLHRPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:15:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:63568 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXLHRPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SvDzgwpm2dpLksx0FSykrQGVBmzmb2NSMunXQRjBbPAZBxw9nwA6CKk1AGU8YB/0wK2QnqLPwxZKqdSluJttWAnjPZI58mn1aPWOQ1n3OYhJhlOFCty+AJ8Gfr+mFvFaeJH1bjlo79mZcBiz9kNhw5y1BvFe+8lXR5VAvlUQDpY=
Message-ID: <fa4052ef0712080915o5e76363dvbda41d9394db4b77@mail.gmail.com>
Date: Sat, 8 Dec 2007 12:15:44 -0500
From: Shane <gnome42@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2.6.24-rc4] proc: Remove/Fix proc generic d_revalidate
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, rjw@sisk.pl,
       trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org,
       bfields@fieldses.org, den@openvz.org,
       "Pavel Emelyanov" <xemul@openvz.org>
In-Reply-To: <m1lk85q0cw.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	 <1197067918.10831.13.camel@heimdal.trondhjem.org>
	 <20071207151444.af5d8e11.akpm@linux-foundation.org>
	 <200712080043.29292.rjw@sisk.pl>
	 <20071208000043.GC1951@martell.zuzino.mipt.ru>
	 <20071207161508.afe8fdf1.akpm@linux-foundation.org>
	 <m1lk85q0cw.fsf_-_@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 11:25 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Ultimately to implement /proc perfectly we need an implementation
> of d_revalidate because files and directories can be removed behind
> the back of the VFS, and d_revalidate is the only way we can let
> the VFS know that this has happened.
>
> Unfortunately the linux VFS can not cope with anything in the path
> to a mount point going away.  So a proper d_revalidate method that
> calls d_drop also needs to call have_submounts which is moderately
> expensive, so you really don't want a d_revalidate method that
> unconditionally calls it, but instead only calls it when the
> backing object has really gone away.
>
> proc generic entries only disappear on module_unload (when
> not counting the fledgling network namespace) so it is quite rare
> that we actually encounter that case and has not actually caused
> us real world trouble yet.
>
> So until we get a proper test for keeping dentries in the dcache
> fix the current d_revalidate method by completely removing it.  This
> returns us to the current status quo.
>
> So with CONFIG_NETNS=n things should look as they have always looked.
>
> For CONFIG_NETNS=y things work most of the time but there are a few
> rare corner cases that don't behave properly.  As the network namespace
> is barely present in 2.6.24 this should not be a problem.
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/proc/generic.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
>
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 8d49838..6a2fe51 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -374,16 +374,9 @@ static int proc_delete_dentry(struct dentry * dentry)
>         return 1;
>  }
>
> -static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
> -{
> -       d_drop(dentry);
> -       return 0;
> -}
> -
>  static struct dentry_operations proc_dentry_operations =
>  {
>         .d_delete       = proc_delete_dentry,
> -       .d_revalidate   = proc_revalidate_dentry,
>  };
>
>  /*
> --
> 1.5.3.rc6.17.g1911

Confirmed. This patch fixes the problem for me.

Shane
