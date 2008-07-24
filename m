Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYGXVat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYGXVat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYGXVak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:30:40 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21922 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYGXVak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:30:40 -0400
X-IronPort-AV: E=Sophos;i="4.31,248,1215414000"; 
   d="scan'208";a="17612919"
Subject: Re: [PATCH 2.6.26-git] Fix oops on remounting nfsroot
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080724.185122.139681307.nemoto@toshiba-tops.co.jp>
References: <20080724.185122.139681307.nemoto@toshiba-tops.co.jp>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Thu, 24 Jul 2008 14:29:43 -0700
Message-Id: <1216934983.7171.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 24 Jul 2008 21:30:37.0453 (UTC) FILETIME=[83771BD0:01C8EDD4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 18:51 +0900, Atsushi Nemoto wrote:
> I got this oops when remounting nfsroot using busybox's mount:
> 
> VFS: Mounted root (nfs filesystem) readonly.
> Freeing unused kernel memory: 180k freed
> CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc == 801c3160, ra == 801744d0
> ...
> Call Trace:
> [<801c3160>] nfs_remount+0x60/0x2e0
> [<801744d0>] do_remount_sb+0x184/0x1fc
> [<8018b7a8>] do_remount+0x140/0x194
> [<8018d824>] do_mount+0x138/0x1f0
> [<8018d970>] sys_mount+0x94/0x1b4
> [<80108df0>] stack_done+0x20/0x3c
> 
> This is a quick workaround, but I'm not sure this is proper fix.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index 1b94e36..adc96cd 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -1718,7 +1718,8 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
>  	 * ones were explicitly specified. Fall back to legacy behavior and
>  	 * just return success.
>  	 */
> -	if ((nfsvers == 4 && options4->version == 1) ||
> +	if (!options ||
> +	    (nfsvers == 4 && options4->version == 1) ||
>  	    (nfsvers <= 3 && options->version >= 1 &&
>  	     options->version <= 6))
>  		return 0;

Hi,

The above is almost correct. You need to test for options4 if the
filesystem is NFSv4.

Marc Zyngier sent me a patch for the same problem a couple of days ago,
but I have yet to pass it on to Linus.

Thanks
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
