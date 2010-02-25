Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab0BYVin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:38:43 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36376 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759Ab0BYVil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:38:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DZgdpO0UK4gV0lcBwnNFOzlfkGiCc6ThdVByDYckkS79JmVNF2rtrM72W3Ty/dKr7h
         dtqc6QEYaQ7xcVzBLPxFX0GfGw9yn+3LZ37KDrBw4vdslWZVdomZehtlv1zZ0Vxzn55p
         Cpndm19z++NfDV3OemFz3RFsQAhufTLOFWuo4=
MIME-Version: 1.0
In-Reply-To: <20100225203834.GD10960@localhost.localdomain>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
	 <20100225202358.GC10960@localhost.localdomain>
	 <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
	 <20100225203834.GD10960@localhost.localdomain>
Date: Thu, 25 Feb 2010 21:38:38 +0000
Message-ID: <6278d2221002251338x6d235485t832ea6238272b9a7@mail.gmail.com>
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 8:38 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Feb 25, 2010 at 03:29:34PM -0500, Andrew Lutomirski wrote:
>> On Thu, Feb 25, 2010 at 3:23 PM, Josef Bacik <josef@redhat.com> wrote:
>> > On Thu, Feb 25, 2010 at 03:01:08PM -0500, Andrew Lutomirski wrote:
>> >> Mounting btrfs corrupts memory and causes nasty crashes within a few
>> >> seconds.  This seems to happen even if the mount fails (note the
>> >> unrecognized mount option).  This is a regression from 2.6.32, and
>> >> I've attached an example.
>> >>
>> >
>> > And it only happens when you mount a btrfs fs?  Can you show me a trace of when
>> > you mount a btrfs fs with valid mount options?  I'd like to see if we're not
>> > cleaning up something properly or what.  Thanks,
>>
>> Seems OK.  Or maybe I just got lucky, but it's crashed every time I
>> tried to mount with 'acl' before.
>>
>> I even went through a couple iterations of trying to mount with
>> 'xattr' and 'user_xattr', both of which failed.
>>
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

The patch is good, and the same as I was testing to fix this issue I
found a day before with -rc8.

Thanks,
  Daniel
-- 
Daniel J Blueman
