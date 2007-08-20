Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbXHTQoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbXHTQoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759963AbXHTQoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:44:24 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:35278 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbXHTQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:44:23 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Refine FAT chmod checks
References: <Pine.LNX.4.64.0708201500490.30570@fbirervta.pbzchgretzou.qr>
	<87ps1i6xrh.fsf@duaron.myhome.or.jp>
	<Pine.LNX.4.64.0708201803080.5333@fbirervta.pbzchgretzou.qr>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 21 Aug 2007 01:44:18 +0900
In-Reply-To: <Pine.LNX.4.64.0708201803080.5333@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Mon\, 20 Aug 2007 18\:12\:11 +0200 \(CEST\)")
Message-ID: <87absm6tr1.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> On Aug 21 2007 00:17, OGAWA Hirofumi wrote:
>>Jan Engelhardt <jengelh@computergmbh.de> writes:
>>> when a vfat filesystem is mounted without the quiet option, chown fails, 
>>> but chmod still succeeds. I think that is wrong.
>>
>>Could you explain why this is wrong more?
>
> Suppose a vfat filesystem is mounted with umask=0 and [not-quiet].
> Then all files will have mode 0777. Trying to change the owner will
> fail, because fat does not know about owners or groups. chmod 0770,
> on the other hand, will succeed, even though fat does not know about
> the permission triplet [user/group/other].
>
> So this patch changes fat's not-quiet behavior so that only UNIX
> modes are accepted that can be mapped lossless between the fat disk
> format and the local system. There is only one attribute, and that is
> the readonly attribute, which is mapped to the UNIX write permission
> bit(s). chmod 0555 is therefore valid (taking away the +w bits <=>
> setting the readonly attribute). Since chmod 0775 and chmod 0755 is
> an ambiguous case as to whether to set or clear the readonly bit,
> these modes are also denied.

I see. Sounds sane. We would be able to see what happen in real world.
However, implementation is really right?

> @@ -186,16 +222,19 @@ int fat_notify_change(struct dentry *den
>  	if (((attr->ia_valid & ATTR_UID) &&
>  	     (attr->ia_uid != sbi->options.fs_uid)) ||
>  	    ((attr->ia_valid & ATTR_GID) &&
> -	     (attr->ia_gid != sbi->options.fs_gid)) ||
> -	    ((attr->ia_valid & ATTR_MODE) &&
> -	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
> +	     (attr->ia_gid != sbi->options.fs_gid)))
>  		error = -EPERM;
> -
>  	if (error) {
>  		if (sbi->options.quiet)
>  			error = 0;
>  		goto out;
>  	}
> +
> +	if (error == 0 && (attr->ia_valid & ATTR_MODE))
> +		if ((error = check_mode(sbi, attr->ia_mode)) != 0 &&
> +		    sbi->options.quiet)
> +			error = 0;

This test is really here? The error is always "0", and it seems
anybody doesn't check after that.

And please separate the check like following

	error = check_mode(sbi, attr->ia_mode);
	if (error && sbi->options.quiet)
		error = 0;

>  	error = inode_setattr(inode, attr);
>  	if (error)
>  		goto out;
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
