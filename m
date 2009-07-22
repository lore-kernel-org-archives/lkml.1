Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbZGVAvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbZGVAvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 20:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZGVAvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 20:51:53 -0400
Received: from mail-yx0-f202.google.com ([209.85.210.202]:56491 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZGVAvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 20:51:52 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 20:51:52 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VDfVLqcObNYz3PkxQh4CaK8PqxZIuWSmqYGIEOuMFhb+5rebSeYITi3xogR1xob0ne
         a3fhIgoWOT3FnM6rW8Y+S0SNjQxQlPtgidNfRcCGp7NFoKF+UKiqMGTCuyHJgAnxqBWJ
         avWZPLxbbGzkjGXJ3kzh7kD3JNGzbaM6HTBIs=
MIME-Version: 1.0
In-Reply-To: <1248219723-832-1-git-send-email-jlayton@redhat.com>
References: <1248219723-832-1-git-send-email-jlayton@redhat.com>
Date: Tue, 21 Jul 2009 19:45:40 -0500
Message-ID: <524f69650907211745t3c19724ete7f7a9c7b92fcfd2@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix sb->s_maxbytes so that it casts properly to a 
	signed value
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix seems logical, although would like to see the maxbytes field the
correct size.  If it really is a loff_t rather than unsigned why
wasn't sparse warning on the vfs in sendfile when it did this
incorrect cast?

When did this start breaking, am a little surprised that connectathon
(and the usual dbench, fsstress, fsx etc.) didn't break if sendfile
was broken, and I don't think that cifs has changed in this area in a
long time.

Shouldn't this cc stable ... sendfile is important.

On Tue, Jul 21, 2009 at 6:42 PM, Jeff Layton<jlayton@redhat.com> wrote:
> This off-by-one bug causes sendfile() to not work properly. When a task
> calls sendfile() on a file on a CIFS filesystem, the syscall returns -1
> and sets errno to EOVERFLOW.
>
> do_sendfile uses s_maxbytes to verify the returned offset of the file.
> The problem there is that this value is cast to a signed value (loff_t).
> When this is done on the s_maxbytes value that cifs uses, it becomes
> negative and the comparisons against it fail.
>
> Even though s_maxbytes is an unsigned value, it seems that it's not OK
> to set it in such a way that it'll end up negative when it's cast to a
> signed value. These casts happen in other codepaths besides sendfile
> too, but the VFS is a little hard to follow in this area and I can't
> be sure if there are other bugs that this will fix.
>
> It's not clear to me why s_maxbytes isn't just declared as loff_t in the
> first place, but either way we still need to fix these values to make
> sendfile work properly. This is also an opportunity to replace the magic
> bit-shift values here with the standard #defines for this.
>
> This fixes the reproducer program I have that does a sendfile and
> will probably also fix the situation where apache is serving from a
> CIFS share.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/connect.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 3e9936d..82ad2a8 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2446,10 +2446,10 @@ try_mount_again:
>                tcon->local_lease = volume_info->local_lease;
>        }
>        if (pSesInfo) {
> -               if (pSesInfo->capabilities & CAP_LARGE_FILES) {
> -                       sb->s_maxbytes = (u64) 1 << 63;
> -               } else
> -                       sb->s_maxbytes = (u64) 1 << 31; /* 2 GB */
> +               if (pSesInfo->capabilities & CAP_LARGE_FILES)
> +                       sb->s_maxbytes = MAX_LFS_FILESIZE;
> +               else
> +                       sb->s_maxbytes = MAX_NON_LFS;
>        }
>
>        /* BB FIXME fix time_gran to be larger for LANMAN sessions */
> --
> 1.6.0.6
>
>



-- 
Thanks,

Steve
