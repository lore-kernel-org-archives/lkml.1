Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732Ab0BYUso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:48:44 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37128 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab0BYUsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=W6b3asHMg8WDqxM2qfKxo3VZTL1fB5FciA9Ix2cBonK7wBNaEOreEOD7JjBh4RqtlF
         qC9yNxwH0gmbeozxPCQ2wpo8uIe5Xtd0dUxh/kc0+f3dn0Pf4nkhII/YfembE6oCTyHB
         hH3Z7R+nOCaEvCUfaziVHi9UMKgdeQe+oC6LQ=
MIME-Version: 1.0
In-Reply-To: <20100225203834.GD10960@localhost.localdomain>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com> 
	<20100225202358.GC10960@localhost.localdomain> <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com> 
	<20100225203834.GD10960@localhost.localdomain>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 25 Feb 2010 15:48:21 -0500
X-Google-Sender-Auth: b2f2e5fdf392c95b
Message-ID: <cb0375e11002251248h17f46468x9a5c3bab0e8bf60d@mail.gmail.com>
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 3:38 PM, Josef Bacik <josef@redhat.com> wrote:
>
> Ok it looks like we have a problem kfree'ing the wrong stuff.  we kstrdup the
> options string, but then strsep screws with the pointer, so when we kfree() it,
> we're not giving it the right pointer.  Please try this patch, and mount with -o
> acl and other such garbage to make sure it actually worked (acl isn't a valid
> mount option btw).  Let me know if it works.  Thanks,
>
> Josef
>
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8a1ea6e..f8b4521 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -128,7 +128,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  {
>        struct btrfs_fs_info *info = root->fs_info;
>        substring_t args[MAX_OPT_ARGS];
> -       char *p, *num;
> +       char *p, *num, *orig;
>        int intarg;
>        int ret = 0;
>
> @@ -143,6 +143,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>        if (!options)
>                return -ENOMEM;
>
> +       orig = options;
>
>        while ((p = strsep(&options, ",")) != NULL) {
>                int token;
> @@ -280,7 +281,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>                }
>        }
>  out:
> -       kfree(options);
> +       kfree(orig);
>        return ret;
>  }
>
>


Thanks for the instant patch.  I hammered on it a bit and it hasn't
crashed yet.  I'll let you know if it crashes later.  (The earlier
trial with xattr crashed after a couple minutes.)

In the mean time,

Tested-by: Andy Lutomirski <luto@mit.edu>

--Andy
