Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZGaT0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZGaT0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZGaT0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 15:26:17 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:64939 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZGaT0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 15:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d5/xaE1DUYAMkfMl8YAgIUEHYG9gIyE0CRS3nC6OARW7FIigy5xMlFdsyKbeYyzGMa
         4ZmxONCuimz3SjAMIQ6b1zK86TOoxeknLzuNQaJulZc6Mxec7wnHKxwmntn8NRfZmeFe
         NMTzGA/6VX3R6EkX/1Idgi1Kass+BdD2S0G00=
MIME-Version: 1.0
In-Reply-To: <1249037742-7862-1-git-send-email-jlayton@redhat.com>
References: <1249037742-7862-1-git-send-email-jlayton@redhat.com>
Date: Fri, 31 Jul 2009 14:26:15 -0500
Message-ID: <4a4634330907311226g409e4098s83059caf8db4f03b@mail.gmail.com>
Subject: Re: [linux-cifs-client] [PATCH] cifs: reinstate original behavior 
	when uid=/gid= options are specified
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 5:55 AM, Jeff Layton<jlayton@redhat.com> wrote:
> This patch fixes the regression reported here:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=13861
>
> commit 4ae1507f6d266d0cc3dd36e474d83aad70fec9e4 changed the default
> behavior when the uid= or gid= option was specified for a mount. The
> existing behavior was to always clobber the ownership information
> provided by the server when these options were specified. The above
> commit changed this behavior so that these options simply provided
> defaults when the server did not provide this information.
>
> This patch reverts this change so that the default behavior is restored.
> It also adds "noforceuid" and "noforcegid" options to make it so that
> ownership information from the server is preserved, even when the mount
> has uid= or gid= options specified.
>
> It also adds a couple of printk notices that pop up when forceuid or
> forcegid options are specified without a uid= or gid= option.
>
> Reported-by: Tom Chiverton <bugzilla.kernel.org@falkensweb.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/connect.c |   42 ++++++++++++++++++++++++++++++------------
>  1 files changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f248688..1f3345d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -803,6 +803,10 @@ cifs_parse_mount_options(char *options, const char *devname,
>        char *data;
>        unsigned int  temp_len, i, j;
>        char separator[2];
> +       short int override_uid = -1;
> +       short int override_gid = -1;
> +       bool uid_specified = false;
> +       bool gid_specified = false;

Should override_uid  and override_gid be initialized to 1 so that if
uid and/or gid
are specified and none of the options, either forceuid/gid and or
noforceuid/gid are
specified, the vol-> override defaults to 1 (i.e. forceuid/gid)?

>
>        separator[0] = ',';
>        separator[1] = 0;
> @@ -1093,18 +1097,20 @@ cifs_parse_mount_options(char *options, const char *devname,
>                                                    "too long.\n");
>                                return 1;
>                        }
> -               } else if (strnicmp(data, "uid", 3) == 0) {
> -                       if (value && *value)
> -                               vol->linux_uid =
> -                                       simple_strtoul(value, &value, 0);
> -               } else if (strnicmp(data, "forceuid", 8) == 0) {
> -                               vol->override_uid = 1;
> -               } else if (strnicmp(data, "gid", 3) == 0) {
> -                       if (value && *value)
> -                               vol->linux_gid =
> -                                       simple_strtoul(value, &value, 0);
> -               } else if (strnicmp(data, "forcegid", 8) == 0) {
> -                               vol->override_gid = 1;
> +               } else if (!strnicmp(data, "uid", 3) && value && *value) {
> +                       vol->linux_uid = simple_strtoul(value, &value, 0);
> +                       uid_specified = true;
> +               } else if (!strnicmp(data, "forceuid", 8)) {
> +                       override_uid = 1;
> +               } else if (!strnicmp(data, "noforceuid", 10)) {
> +                       override_uid = 0;
> +               } else if (!strnicmp(data, "gid", 3) && value && *value) {
> +                       vol->linux_gid = simple_strtoul(value, &value, 0);
> +                       gid_specified = true;
> +               } else if (!strnicmp(data, "forcegid", 8)) {
> +                       override_gid = 1;
> +               } else if (!strnicmp(data, "noforcegid", 10)) {
> +                       override_gid = 0;
>                } else if (strnicmp(data, "file_mode", 4) == 0) {
>                        if (value && *value) {
>                                vol->file_mode =
> @@ -1355,6 +1361,18 @@ cifs_parse_mount_options(char *options, const char *devname,
>        if (vol->UNCip == NULL)
>                vol->UNCip = &vol->UNC[2];
>
> +       if (uid_specified)
> +               vol->override_uid = override_uid;
> +       else if (override_uid == 1)
> +               printk(KERN_NOTICE "CIFS: ignoring forceuid mount option "
> +                                  "specified with no uid= option.\n");
> +
> +       if (gid_specified)
> +               vol->override_gid = override_gid;
> +       else if (override_gid == 1)
> +               printk(KERN_NOTICE "CIFS: ignoring forcegid mount option "
> +                                  "specified with no gid= option.\n");
> +
>        return 0;
>  }
>
> --
> 1.6.0.6
>
> _______________________________________________
> linux-cifs-client mailing list
> linux-cifs-client@lists.samba.org
> https://lists.samba.org/mailman/listinfo/linux-cifs-client
>
