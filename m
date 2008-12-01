Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYLAT2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYLAT2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYLAT2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:28:15 -0500
Received: from smtp2-g19.free.fr ([212.27.42.28]:59352 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYLAT2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:28:14 -0500
Message-ID: <49343AC2.3010808@free.fr>
Date: Mon, 01 Dec 2008 20:28:02 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.18) Gecko/20081030 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Jan Kara <jack@suse.cz>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-2008-11-28 : can't mount UDF DVD
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au> <49332545.5020604@free.fr> <20081201001854.GA9881@joi>
In-Reply-To: <20081201001854.GA9881@joi>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01.12.2008 01:18, Marcin Slusarz a écrit :
> On Mon, Dec 01, 2008 at 12:44:05AM +0100, Laurent Riffard wrote:
>> Hi,
>>
>> With next-2008-11-28, I was unable to mount an UDF-formatted DVD-RW:
>>
>> ~$ mount -oro -t udf /dev/sr0 /media/cdrom/
>> mount: Not a directory
>>
>> There was no problem with 2.6.28-rc6.
>>
>> I made a bisection:
>>
>> 33284bdf40f88160a154202510b27d983138c805 is first bad commit
>> commit 33284bdf40f88160a154202510b27d983138c805
>> Author: Marcin Slusarz <marcin.slusarz@gmail.com>
>> Date:   Sun Nov 16 20:52:19 2008 +0100
>>
>>     udf: implement mode and dmode mounting options
>>
>>     "dmode" allows overriding permissions of directories and
>>     "mode" allows overriding permissions of files.
>>
>>     Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
>>     Cc: Jan Kara <jack@suse.cz>
>>     Signed-off-by: Jan Kara <jack@suse.cz>
>>
>>
>> Indeed, with this commit, I *must* use the dmode option to mount my DVD:
> 
> That's not intended behaviour... ;)
>  
>> ~$ sudo mount -oro,dmode=0755 -t udf /dev/sr0 /media/cdrom/
>> ~$ grep /media/cdrom /proc/mounts 
>> /dev/scd0 /media/cdrom udf ro,mode=177777,dmode=755,utf8 0 0
>                                      ^^^^^^
> funny (it's 65535 / (u16)-1)
> 
[snip]
> 
> Can you check whether attached patch fixes it?
> What architecture are you testing on?

i686, 32-bit althought CPU is "AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02".

~$ uname -a
Linux calimero 2.6.28-rc6-next-20081128-05108-g389b1c9 #62 SMP PREEMPT Mon Dec 1 19:53:55 CET 2008 i686 GNU/Linux

Current kernel is next-20081128 + reiser4 patches + your patch: it seems to works well now.

First test: mount with default options. It works as expected.

~$ sudo mount -oro -t udf /dev/sr0 /media/cdrom/
~$ grep /media/cdrom /proc/mounts
/dev/scd0 /media/cdrom udf ro,utf8 0 0
~$ ls -al /media/cdrom/
total 46
drwxrwxrwx  5 root    root     344 2007-12-24 18:09 .
drwxr-xr-x 12 root    root    4096 2008-12-01 20:04 ..
drwxr-x---  2 laurent laurent 7112 2008-11-30 20:14 flexbackup
drwxr-xr-x  2 root    root      40 2005-11-20 23:37 lost+found
drwxr-x--- 10 laurent laurent 4548 2005-11-25 18:18 patches
~$ ls -al /media/cdrom/flexbackup/
total 4307946
drwxr-x--- 2 laurent laurent       7112 2008-11-30 20:14 .
drwxrwxrwx 5 root    root           344 2007-12-24 18:09 ..
-rw-r----- 1 laurent laurent         44 2006-10-01 15:36 00-index-key
[...]
~$ sudo umount /dev/scd0


Second test : mount with dmode=0755 option. Does work as expected too.

~$ sudo mount -oro,dmode=0755 -t udf /dev/sr0 /media/cdrom/
~$ grep /media/cdrom /proc/mounts
/dev/scd0 /media/cdrom udf ro,dmode=755,utf8 0 0
~$ ls -al /media/cdrom/
total 46
drwxr-xr-x  5 root    root     344 2007-12-24 18:09 .
drwxr-xr-x 12 root    root    4096 2008-12-01 20:04 ..
drwxr-xr-x  2 laurent laurent 7112 2008-11-30 20:14 flexbackup
drwxr-xr-x  2 root    root      40 2005-11-20 23:37 lost+found
drwxr-xr-x 10 laurent laurent 4548 2005-11-25 18:18 patches
~$ ls -al /media/cdrom/flexbackup/
total 4307946
drwxr-xr-x 2 laurent laurent       7112 2008-11-30 20:14 .
drwxr-xr-x 5 root    root           344 2007-12-24 18:09 ..
-rw-r----- 1 laurent laurent         44 2006-10-01 15:36 00-index-key
[...]

Tested-by: Laurent Riffard <laurent.riffard@free.fr>

> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 6612a27..9eeb726 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1222,10 +1222,10 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  	iinfo->i_lenExtents = inode->i_size;
>  
>  	if (fe->icbTag.fileType != ICBTAG_FILE_TYPE_DIRECTORY &&
> -			sbi->s_fmode != -1)
> +			sbi->s_fmode != (mode_t)-1)
>  		inode->i_mode = sbi->s_fmode;
>  	else if (fe->icbTag.fileType == ICBTAG_FILE_TYPE_DIRECTORY &&
> -			sbi->s_dmode != -1)
> +			sbi->s_dmode != (mode_t)-1)
>  		inode->i_mode = sbi->s_dmode;
>  	else
>  		inode->i_mode = udf_convert_permissions(fe);
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index e5d121d..af8a771 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -284,9 +284,9 @@ static int udf_show_options(struct seq_file *seq, struct vfsmount *mnt)
>  		seq_printf(seq, ",gid=%u", sbi->s_gid);
>  	if (sbi->s_umask != 0)
>  		seq_printf(seq, ",umask=%o", sbi->s_umask);
> -	if (sbi->s_fmode != -1)
> +	if (sbi->s_fmode != (mode_t)-1)
>  		seq_printf(seq, ",mode=%o", sbi->s_fmode);
> -	if (sbi->s_dmode != -1)
> +	if (sbi->s_dmode != (mode_t)-1)
>  		seq_printf(seq, ",dmode=%o", sbi->s_dmode);
>  	if (UDF_QUERY_FLAG(sb, UDF_FLAG_SESSION_SET))
>  		seq_printf(seq, ",session=%u", sbi->s_session);

Thanks
~~
laurent


 

