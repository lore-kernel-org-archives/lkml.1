Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYFJROs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYFJROs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYFJROa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:14:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:13019 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYFJRO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uSbyjiDyGqI+n/3xa0FttCRRZmlPd0RWMJF61iz7eJCcw+Xf26IiSdjwhYOEYrcBhu
         XrtHFoHysKjZyZQBA3qh9bsYhYLocagBI7DB4VXm1sKSJJtxeRW70KLUs/VM8ukf3CYn
         GTKVkF/1FQL5xxHOsfvCeq1s0rtN3ywPiwrjs=
Message-ID: <524f69650806101014r6a068a7dvacb7fba58a230a63@mail.gmail.com>
Date: Tue, 10 Jun 2008 12:14:26 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>, marcin.slusarz@gmail.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Fwd: [patch (for 2.6.26?) 1/1] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled
In-Reply-To: <524f69650806100947g4392b44es12b800e39a406d75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806092348.m59NmsZd015641@imap1.linux-foundation.org>
	 <524f69650806100947g4392b44es12b800e39a406d75@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have the original note (ie patch without whitespace mangled by
the mailers) that I can ack to Linus on this but would like it merged
into mainline as an individual patch (my cifs-2.6.git tree has
additional patches in it that I don't want to merged into
linux-2.6.git yet).


---------- Forwarded message ----------
From: Steve French <smfrench@gmail.com>
Date: Tue, Jun 10, 2008 at 11:47 AM
Subject: Re: [patch (for 2.6.26?) 1/1] cifs: fix oops on mount when
CONFIG_CIFS_DFS_UPCALL is enabled
To: akpm@linux-foundation.org
Cc: sfrench@us.ibm.com, marcin.slusarz@gmail.com, sfrench@samba.org,
stable@kernel.org


ACK

On Mon, Jun 9, 2008 at 6:48 PM,  <akpm@linux-foundation.org> wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
>
> simple "mount -t cifs //xxx /mnt" oopsed on strlen of options
> http://kerneloops.org/guilty.php?guilty=cifs_get_sb&version=2.6.25-release&start=1671168&end=1703935&class=oops
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Steve French <sfrench@samba.org>
> Cc: <stable@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/cifs/cifsfs.c |   21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> diff -puN fs/cifs/cifsfs.c~cifs-fix-oops-on-mount-when-config_cifs_dfs_upcall-is-enabled fs/cifs/cifsfs.c
> --- a/fs/cifs/cifsfs.c~cifs-fix-oops-on-mount-when-config_cifs_dfs_upcall-is-enabled
> +++ a/fs/cifs/cifsfs.c
> @@ -124,9 +124,6 @@ cifs_read_super(struct super_block *sb,
>  {
>        struct inode *inode;
>        struct cifs_sb_info *cifs_sb;
> -#ifdef CONFIG_CIFS_DFS_UPCALL
> -       int len;
> -#endif
>        int rc = 0;
>
>        /* BB should we make this contingent on mount parm? */
> @@ -144,15 +141,17 @@ cifs_read_super(struct super_block *sb,
>         * complex operation (mount), and in case of fail
>         * just exit instead of doing mount and attempting
>         * undo it if this copy fails?*/
> -       len = strlen(data);
> -       cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
> -       if (cifs_sb->mountdata == NULL) {
> -               kfree(sb->s_fs_info);
> -               sb->s_fs_info = NULL;
> -               return -ENOMEM;
> +       if (data) {
> +               int len = strlen(data);
> +               cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
> +               if (cifs_sb->mountdata == NULL) {
> +                       kfree(sb->s_fs_info);
> +                       sb->s_fs_info = NULL;
> +                       return -ENOMEM;
> +               }
> +               strncpy(cifs_sb->mountdata, data, len + 1);
> +               cifs_sb->mountdata[len] = '\0';
>        }
> -       strncpy(cifs_sb->mountdata, data, len + 1);
> -       cifs_sb->mountdata[len] = '\0';
>  #endif
>
>        rc = cifs_mount(sb, cifs_sb, data, devname);
> _
>



--
Thanks,

Steve



-- 
Thanks,

Steve
