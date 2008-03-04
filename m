Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbYCDQmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbYCDQmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764804AbYCDQm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:42:28 -0500
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:38849 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764707AbYCDQm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:42:27 -0500
X-YMail-OSG: 4VMCdiUVM1lcsmagdDWeSvb_0CJJXVTBVsYIKNZbJ2WckKTzIU5h153a0M.SNtCCxA8mbGIv4IE5JVDBFE0HGwxk
X-Mailer: YahooMailRC/902.35 YahooMailWebService/0.7.162
Date: Tue, 4 Mar 2008 08:42:26 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not loaded
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <623001.60200.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----
> From: Ahmed S. Darwish <darwish.07@gmail.com>
> To: Casey Schaufler <casey@schaufler-ca.com>
> Cc: LKML <linux-kernel@vger.kernel.org>; Linus <torvalds@linux-foundation.org>
> Sent: Tuesday, March 4, 2008 5:10:55 AM
> Subject: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not loaded
> 
> Hi all,
> 
> Smackfs initialization without an enabled Smack leads to
> an early Oops that renders the system unusable.
> 
> Introduce a global smack_enabled variable that will be used
> to make sure that no smack components will be registered 
> (ala smackfs) if we are not already enabled.
> 
> Signed-off-by: Ahmed S. Darwish
Acked-by: Casey Schaufler casey@schaufler-ca.com

> ---
> 
> The Oops is triggered by the security= patch that will be sent
> soon.
> 
> I can't imagine an SELinux guru finding /smackfs instead of 
> his usual /selinuxfs when he hits a tab completion after 's' ;).
> As a bonus, this patch will handle that case too.
> 
> smack.h | 9 +++++++++
> smack_lsm.c | 8 ++++++++
> smackfs.c | 3 +++
> 
> 3 files changed, 20 insertions(+)
> 
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index a21a0e9..17c55ad 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -18,6 +18,15 @@
> #include 
> 
> /*
> + * We must not bother the rest of the kernel by exporting our
> + * own stuff if we are not already enabled. We may not be loaded
> + * if another or no LSM was chosen on boot.
> + * Smackfs is currently the only exported component, but this
> + * may change in the future.
> + */
> +extern int smack_enabled;
> +
> +/*
> * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
> * bigger than can be used, and 24 is the next lower multiple
> * of 8, and there are too many issues if there isn't space set
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 770eb06..6fe7869 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -36,6 +36,8 @@
> #define SOCKFS_MAGIC 0x534F434B
> #define TMPFS_MAGIC 0x01021994
> 
> +int smack_enabled;
> +
> /**
> * smk_fetch - Fetch the smack label from a file.
> * @ip: a pointer to the inode
> @@ -2589,6 +2591,12 @@ static __init int smack_init(void)
> if (register_security(&smack_ops))
> panic("smack: Unable to register with kernel.\n");
> 
> + /*
> + * Notify other Smack components that it's now safe to
> + * to register themselves.
> + */
> + smack_enabled = 1;
> +
> return 0;
> }
> 
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 358c92c..e1687c0 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -992,6 +992,9 @@ static int __init init_smk_fs(void)
> {
> int err;
> 
> + if (!smack_enabled)
> + return 0;
> +
> err = register_filesystem(&smk_fs_type);
> if (!err) {
> smackfs_mount = kern_mount(&smk_fs_type);
> 
> -- 
> 
> "Better to light a candle, than curse the darkness"
> 
> Ahmed S. Darwish
> Homepage: http://darwish.07.googlepages.com
> Blog: http://darwish-07.blogspot.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at 
> http://www.tux.org/lkml/


Casey Schaufler
casey@schaufler-ca.com 
