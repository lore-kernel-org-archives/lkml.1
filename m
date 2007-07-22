Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXGVWyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXGVWyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761733AbXGVWyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:54:22 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:39477 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761256AbXGVWyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:54:20 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [EXT4 set 7][PATCH 1/1]Remove 32000 subdirs limit.
Date: Mon, 23 Jul 2007 00:52:22 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
References: <1183275498.4010.135.camel@localhost.localdomain> <20070713095343.d2e76775.akpm@linux-foundation.org> <1184665789.7063.8.camel@garfield.linsyssoft.com>
In-Reply-To: <1184665789.7063.8.camel@garfield.linsyssoft.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230052.23972.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007, Kalpak Shah wrote:
> Index: linux-2.6.22/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.22.orig/include/linux/ext4_fs.h
> +++ linux-2.6.22/include/linux/ext4_fs.h
> @@ -797,12 +797,18 @@ struct ext4_dir_entry_2 {
>    #define is_dx(dir) (EXT4_HAS_COMPAT_FEATURE(dir->i_sb, \
>                                               EXT4_FEATURE_COMPAT_DIR_INDEX) && \
>                       (EXT4_I(dir)->i_flags & EXT4_INDEX_FL))
> -#define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
> -#define EXT4_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
> +static inline int ext4_dir_link_max(struct inode *dir)
> +{
> +       return (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX);
> +}
> +static inline int ext4_dir_link_empty(struct inode *dir)
> +{
> +       return ((dir)->i_nlink == 2 || (dir)->i_nlink == 1);
> +}

even better:

static inline bool ext4_is_dx(const struct inode *dir)
{
#ifdef FOOBAR
	return EXT4_HAS_COMPAT_FEATURE(dir->i_sb,   EXT4_FEATURE_COMPAT_DIR_INDEX) 
                   && (EXT4_I(dir)->i_flags & EXT4_INDEX_FL));
#else
	return false;
#endif
}

static inline bool ext4_dir_link_max(const struct inode *dir)
{
	return !ext4_is_dx(dir) && (dir->i_nlink >= EXT4_LINK_MAX);
}

static inline bool ext4_dir_link_empty(const struct inode *dir)
{
#ifdef FOOBAR
	return dir->i_nlink == 2 || dir->i_nlink == 1;
#else
	return dir->i_nlink == 2;
#endif
}


FOOBAR is the define, which enables ext4_is_dx(). 
That is not in the patch, so left as an exercise to the reader :-)

Best Regards

Ingo Oeser
