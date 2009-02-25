Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZBYR14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZBYR14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZBYR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:27:47 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:45056 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZBYR1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:27:46 -0500
Message-ID: <49A57FA7.407@oracle.com>
Date: Wed, 25 Feb 2009 09:28:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-02-24-16-23 uploaded (proc_net & namespaces)
References: <200902250041.n1P0fe4A024914@imap1.linux-foundation.org> <49A5778E.1000204@oracle.com> <20090225171748.GC14463@us.ibm.com>
In-Reply-To: <20090225171748.GC14463@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49A57F64.0158:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Randy Dunlap (randy.dunlap@oracle.com):
>> akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-02-24-16-23 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>>>
>>> It contains the following patches against 2.6.29-rc6:
>> namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch,
>> when CONFIG_NAMESPACES=n:
>>
>> proc_net.c:(.text+0x4255c): undefined reference to `get_sb_ns'
>>
>>
>> config attached.
> 
> Thanks, Randy.  Does the following fix it?
> 
> (Sorry, it's a misleading patch, and maybe it would turn out more
> readable if I moved get_sb_ns under instead of above the
> CONFIG_BLOCK ifdef...  But all I'm doing is what the subject says,
> plus adding an EXPORT_SYMBOL which may be debatable, but is in
> keeping with other get_sb_*'s.)

That causes problems in fs/super.c:

fs/super.c: In function 'get_sb_ns':
fs/super.c:773: error: 'ns_test_super' undeclared (first use in this function)

> thanks,
> -serge
> 
> From fff28e37112037efbbc6e44e29bbd741c9dd38a9 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Wed, 25 Feb 2009 09:14:03 -0800
> Subject: [PATCH 1/1] namespaces: get_sb_ns does not require CONFIG_BLOCK
> 
> So move it outside of the CONFIG_BLOCK ifdef in fs/super.c.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  fs/super.c |   50 ++++++++++++++++++++++++++------------------------
>  1 files changed, 26 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 1a37b58..b3bf049 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -761,30 +761,6 @@ void kill_litter_super(struct super_block *sb)
>  
>  EXPORT_SYMBOL(kill_litter_super);
>  
> -#ifdef CONFIG_BLOCK
> -static int set_bdev_super(struct super_block *s, void *data)
> -{
> -	s->s_bdev = data;
> -	s->s_dev = s->s_bdev->bd_dev;
> -	return 0;
> -}
> -
> -static int test_bdev_super(struct super_block *s, void *data)
> -{
> -	return (void *)s->s_bdev == data;
> -}
> -
> -static int ns_test_super(struct super_block *sb, void *data)
> -{
> -	return sb->s_fs_info == data;
> -}
> -
> -static int ns_set_super(struct super_block *sb, void *data)
> -{
> -	sb->s_fs_info = data;
> -	return set_anon_super(sb, NULL);
> -}
> -
>  int get_sb_ns(struct file_system_type *fs_type, int flags, void *data,
>  	int (*fill_super)(struct super_block *, void *, int),
>  	struct vfsmount *mnt)
> @@ -812,6 +788,32 @@ int get_sb_ns(struct file_system_type *fs_type, int flags, void *data,
>  	return 0;
>  }
>  
> +EXPORT_SYMBOL(get_sb_ns);
> +
> +#ifdef CONFIG_BLOCK
> +static int set_bdev_super(struct super_block *s, void *data)
> +{
> +	s->s_bdev = data;
> +	s->s_dev = s->s_bdev->bd_dev;
> +	return 0;
> +}
> +
> +static int test_bdev_super(struct super_block *s, void *data)
> +{
> +	return (void *)s->s_bdev == data;
> +}
> +
> +static int ns_test_super(struct super_block *sb, void *data)
> +{
> +	return sb->s_fs_info == data;
> +}
> +
> +static int ns_set_super(struct super_block *sb, void *data)
> +{
> +	sb->s_fs_info = data;
> +	return set_anon_super(sb, NULL);
> +}
> +
>  int get_sb_bdev(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data,
>  	int (*fill_super)(struct super_block *, void *, int),


-- 
~Randy
