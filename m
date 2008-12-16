Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYLPDSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYLPDSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYLPDSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:18:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:63980 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbYLPDSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:18:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BAPmVEE3EC6WvXlHRi1cvzUKDImsWnZvoVnjZhxpvWi6HN6bhe/Ekdvsi1VMmx87b+
         LEHkjy7RP16Ugy8gGTb8HjUJ45E163J0zbOcdiC8YGE0A58z/q2kXL/EplPVHWZ8VP9t
         leTbKEbYPDcxDO1n8MWLQl2DYaDiWppSU9xxY=
Message-ID: <524f69650812151918u1a0a7d20o39cbcb7f04b87af@mail.gmail.com>
Date: Mon, 15 Dec 2008 21:18:29 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: make sure that DFS pathnames are properly formed
Cc: niallain@gmail.com, smfrench@austin.rr.com,
       linux-cifs-client@lists.samba.org, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1229389344-26790-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229389344-26790-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix looks correct and urgent, although if we have time I would
like to try it for another day before requesting merge to linux-2.6

The dfs documentation does state that we should be sending \ rather
than \\ (although earlier places in the document stated the reverse,
it is more clear later in the network documentation).
On Mon, Dec 15, 2008 at 7:02 PM, Jeff Layton <jlayton@redhat.com> wrote:
> The paths in a DFS request are supposed to only have a single preceding
> backslash, but we are sending them with a double backslash. This is
> exposing a bug in Windows where it also sends a path in the response
> that has a double backslash.
>
> The existing code that builds the mount option string however expects a
> double backslash prefix in a couple of places when it tries to use the
> path returned by build_path_from_dentry. Fix compose_mount_options to
> expect properly formed DFS paths (single backslash at front).
>
> Also clean up error handling in that function. There was a possible
> NULL pointer dereference and situations where a partially built option
> string would be returned.
>
> Tested against Samba 3.0.28-ish server and Win2k8.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/cifs_dfs_ref.c |   48 ++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 36 insertions(+), 12 deletions(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index e1c1836..85c0a74 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -122,7 +122,7 @@ static char *compose_mount_options(const char *sb_mountdata,
>                                   char **devname)
>  {
>        int rc;
> -       char *mountdata;
> +       char *mountdata = NULL;
>        int md_len;
>        char *tkn_e;
>        char *srvIP = NULL;
> @@ -136,10 +136,9 @@ static char *compose_mount_options(const char *sb_mountdata,
>        *devname = cifs_get_share_name(ref->node_name);
>        rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
>        if (rc != 0) {
> -               cERROR(1, ("%s: Failed to resolve server part of %s to IP",
> -                         __func__, *devname));
> -               mountdata = ERR_PTR(rc);
> -               goto compose_mount_options_out;
> +               cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
> +                         __func__, *devname, rc));;
> +               goto compose_mount_options_err;
>        }
>        /* md_len = strlen(...) + 12 for 'sep+prefixpath='
>         * assuming that we have 'unc=' and 'ip=' in
> @@ -149,8 +148,8 @@ static char *compose_mount_options(const char *sb_mountdata,
>                strlen(ref->node_name) + 12;
>        mountdata = kzalloc(md_len+1, GFP_KERNEL);
>        if (mountdata == NULL) {
> -               mountdata = ERR_PTR(-ENOMEM);
> -               goto compose_mount_options_out;
> +               rc = -ENOMEM;
> +               goto compose_mount_options_err;
>        }
>
>        /* copy all options except of unc,ip,prefixpath */
> @@ -197,18 +196,32 @@ static char *compose_mount_options(const char *sb_mountdata,
>
>        /* find & copy prefixpath */
>        tkn_e = strchr(ref->node_name + 2, '\\');
> -       if (tkn_e == NULL) /* invalid unc, missing share name*/
> -               goto compose_mount_options_out;
> +       if (tkn_e == NULL) {
> +               /* invalid unc, missing share name*/
> +               rc = -EINVAL;
> +               goto compose_mount_options_err;
> +       }
>
> +       /*
> +        * this function gives us a path with a double backslash prefix. We
> +        * require a single backslash for DFS. Temporarily increment fullpath
> +        * to put it in the proper form and decrement before freeing it.
> +        */
>        fullpath = build_path_from_dentry(dentry);
> +       if (!fullpath) {
> +               rc = -ENOMEM;
> +               goto compose_mount_options_err;
> +       }
> +       ++fullpath;
>        tkn_e = strchr(tkn_e + 1, '\\');
> -       if (tkn_e || strlen(fullpath) - (ref->path_consumed)) {
> +       if (tkn_e || (strlen(fullpath) - ref->path_consumed)) {
>                strncat(mountdata, &sep, 1);
>                strcat(mountdata, "prefixpath=");
>                if (tkn_e)
>                        strcat(mountdata, tkn_e + 1);
> -               strcat(mountdata, fullpath + (ref->path_consumed));
> +               strcat(mountdata, fullpath + ref->path_consumed);
>        }
> +       --fullpath;
>        kfree(fullpath);
>
>        /*cFYI(1,("%s: parent mountdata: %s", __func__,sb_mountdata));*/
> @@ -217,6 +230,11 @@ static char *compose_mount_options(const char *sb_mountdata,
>  compose_mount_options_out:
>        kfree(srvIP);
>        return mountdata;
> +
> +compose_mount_options_err:
> +       kfree(mountdata);
> +       mountdata = ERR_PTR(rc);
> +       goto compose_mount_options_out;
>  }
>
>
> @@ -309,13 +327,19 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
>                goto out_err;
>        }
>
> +       /*
> +        * The MSDFS spec states that paths in DFS referral requests and
> +        * responses must be prefixed by a single '\' character instead of
> +        * the double backslashes usually used in the UNC. This function
> +        * gives us the latter, so we must adjust the result.
> +        */
>        full_path = build_path_from_dentry(dentry);
>        if (full_path == NULL) {
>                rc = -ENOMEM;
>                goto out_err;
>        }
>
> -       rc = get_dfs_path(xid, ses , full_path, cifs_sb->local_nls,
> +       rc = get_dfs_path(xid, ses , full_path + 1, cifs_sb->local_nls,
>                &num_referrals, &referrals,
>                cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
>
> --
> 1.5.5.1
>
>



-- 
Thanks,

Steve
