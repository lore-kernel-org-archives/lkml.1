Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYLPDb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYLPDb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYLPDbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:31:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56966 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbYLPDbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:31:05 -0500
Date: Mon, 15 Dec 2008 22:30:05 -0500
From: Jeff Layton <jlayton@redhat.com>
To: "Steve French" <smfrench@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-cifs-client@lists.samba.org,
       niallain@gmail.com, smfrench@austin.rr.com
Subject: Re: [linux-cifs-client] Re: [PATCH] cifs: make sure that DFS
 pathnames are properly formed
Message-ID: <20081215223005.00d3ee23@tupile.poochiereds.net>
In-Reply-To: <524f69650812151918u1a0a7d20o39cbcb7f04b87af@mail.gmail.com>
References: <1229389344-26790-1-git-send-email-jlayton@redhat.com>
	<524f69650812151918u1a0a7d20o39cbcb7f04b87af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 21:18:29 -0600
"Steve French" <smfrench@gmail.com> wrote:

> This fix looks correct and urgent, although if we have time I would
> like to try it for another day before requesting merge to linux-2.6
> 

I think it's correct. I'm not sure if I'd term it urgent. It only means
that DFS referrals (which are still labeled experimental) aren't working,
and only in the case of samba servers (AFAICT). Windows DFS referrals
still seem to work OK without this path.

Still, it's probably safe enough if you do want to push it for 2.6.28.

> The dfs documentation does state that we should be sending \ rather
> than \\ (although earlier places in the document stated the reverse,
> it is more clear later in the network documentation).
> On Mon, Dec 15, 2008 at 7:02 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > The paths in a DFS request are supposed to only have a single preceding
> > backslash, but we are sending them with a double backslash. This is
> > exposing a bug in Windows where it also sends a path in the response
> > that has a double backslash.
> >
> > The existing code that builds the mount option string however expects a
> > double backslash prefix in a couple of places when it tries to use the
> > path returned by build_path_from_dentry. Fix compose_mount_options to
> > expect properly formed DFS paths (single backslash at front).
> >
> > Also clean up error handling in that function. There was a possible
> > NULL pointer dereference and situations where a partially built option
> > string would be returned.
> >
> > Tested against Samba 3.0.28-ish server and Win2k8.
> >
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/cifs/cifs_dfs_ref.c |   48 ++++++++++++++++++++++++++++++++++++------------
> >  1 files changed, 36 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> > index e1c1836..85c0a74 100644
> > --- a/fs/cifs/cifs_dfs_ref.c
> > +++ b/fs/cifs/cifs_dfs_ref.c
> > @@ -122,7 +122,7 @@ static char *compose_mount_options(const char *sb_mountdata,
> >                                   char **devname)
> >  {
> >        int rc;
> > -       char *mountdata;
> > +       char *mountdata = NULL;
> >        int md_len;
> >        char *tkn_e;
> >        char *srvIP = NULL;
> > @@ -136,10 +136,9 @@ static char *compose_mount_options(const char *sb_mountdata,
> >        *devname = cifs_get_share_name(ref->node_name);
> >        rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
> >        if (rc != 0) {
> > -               cERROR(1, ("%s: Failed to resolve server part of %s to IP",
> > -                         __func__, *devname));
> > -               mountdata = ERR_PTR(rc);
> > -               goto compose_mount_options_out;
> > +               cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
> > +                         __func__, *devname, rc));;
> > +               goto compose_mount_options_err;
> >        }
> >        /* md_len = strlen(...) + 12 for 'sep+prefixpath='
> >         * assuming that we have 'unc=' and 'ip=' in
> > @@ -149,8 +148,8 @@ static char *compose_mount_options(const char *sb_mountdata,
> >                strlen(ref->node_name) + 12;
> >        mountdata = kzalloc(md_len+1, GFP_KERNEL);
> >        if (mountdata == NULL) {
> > -               mountdata = ERR_PTR(-ENOMEM);
> > -               goto compose_mount_options_out;
> > +               rc = -ENOMEM;
> > +               goto compose_mount_options_err;
> >        }
> >
> >        /* copy all options except of unc,ip,prefixpath */
> > @@ -197,18 +196,32 @@ static char *compose_mount_options(const char *sb_mountdata,
> >
> >        /* find & copy prefixpath */
> >        tkn_e = strchr(ref->node_name + 2, '\\');
> > -       if (tkn_e == NULL) /* invalid unc, missing share name*/
> > -               goto compose_mount_options_out;
> > +       if (tkn_e == NULL) {
> > +               /* invalid unc, missing share name*/
> > +               rc = -EINVAL;
> > +               goto compose_mount_options_err;
> > +       }
> >
> > +       /*
> > +        * this function gives us a path with a double backslash prefix. We
> > +        * require a single backslash for DFS. Temporarily increment fullpath
> > +        * to put it in the proper form and decrement before freeing it.
> > +        */
> >        fullpath = build_path_from_dentry(dentry);
> > +       if (!fullpath) {
> > +               rc = -ENOMEM;
> > +               goto compose_mount_options_err;
> > +       }
> > +       ++fullpath;
> >        tkn_e = strchr(tkn_e + 1, '\\');
> > -       if (tkn_e || strlen(fullpath) - (ref->path_consumed)) {
> > +       if (tkn_e || (strlen(fullpath) - ref->path_consumed)) {
> >                strncat(mountdata, &sep, 1);
> >                strcat(mountdata, "prefixpath=");
> >                if (tkn_e)
> >                        strcat(mountdata, tkn_e + 1);
> > -               strcat(mountdata, fullpath + (ref->path_consumed));
> > +               strcat(mountdata, fullpath + ref->path_consumed);
> >        }
> > +       --fullpath;
> >        kfree(fullpath);
> >
> >        /*cFYI(1,("%s: parent mountdata: %s", __func__,sb_mountdata));*/
> > @@ -217,6 +230,11 @@ static char *compose_mount_options(const char *sb_mountdata,
> >  compose_mount_options_out:
> >        kfree(srvIP);
> >        return mountdata;
> > +
> > +compose_mount_options_err:
> > +       kfree(mountdata);
> > +       mountdata = ERR_PTR(rc);
> > +       goto compose_mount_options_out;
> >  }
> >
> >
> > @@ -309,13 +327,19 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
> >                goto out_err;
> >        }
> >
> > +       /*
> > +        * The MSDFS spec states that paths in DFS referral requests and
> > +        * responses must be prefixed by a single '\' character instead of
> > +        * the double backslashes usually used in the UNC. This function
> > +        * gives us the latter, so we must adjust the result.
> > +        */
> >        full_path = build_path_from_dentry(dentry);
> >        if (full_path == NULL) {
> >                rc = -ENOMEM;
> >                goto out_err;
> >        }
> >
> > -       rc = get_dfs_path(xid, ses , full_path, cifs_sb->local_nls,
> > +       rc = get_dfs_path(xid, ses , full_path + 1, cifs_sb->local_nls,
> >                &num_referrals, &referrals,
> >                cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> >
> > --
> > 1.5.5.1
> >
> >
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
> _______________________________________________
> linux-cifs-client mailing list
> linux-cifs-client@lists.samba.org
> https://lists.samba.org/mailman/listinfo/linux-cifs-client
> 


-- 
Jeff Layton <jlayton@redhat.com>
