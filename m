Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625Ab0ALMky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0ALMky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 07:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755Ab0ALMkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 07:40:52 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:55448 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0ALMkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 07:40:51 -0500
Date: Tue, 12 Jan 2010 13:41:34 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
Message-ID: <20100112134134.5f55e95f@gondolin>
In-Reply-To: <1263241315-19499-3-git-send-email-ebiederm@xmission.com>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
	<1263241315-19499-3-git-send-email-ebiederm@xmission.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Dirk
 Wittkopp Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010 12:21:51 -0800,
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> From: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> On large directories sysfs_count_nlinks can be a significant
> bottleneck, so keep a count in sysfs_dirent.  If we exceed
> the maximum number of directory entries we can store return
> nlink of 1.  An nlink of 1 matches what reiserfs does in
> this case, and it let's find and similar utlities know that
> we have a the directory nlink can not be used for optimization
> purposes.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  fs/sysfs/dir.c   |   20 ++++++++++++++++++++
>  fs/sysfs/inode.c |   15 +--------------
>  fs/sysfs/mount.c |    1 +
>  fs/sysfs/sysfs.h |    1 +
>  4 files changed, 23 insertions(+), 14 deletions(-)
> 

> @@ -420,6 +438,7 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>  		return -EEXIST;
> 
>  	sd->s_parent = sysfs_get(acxt->parent_sd);
> +	sysfs_dir_inc_nlink(sd->s_parent);
> 
>  	sysfs_link_sibling(sd);
> 
> @@ -512,6 +531,7 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
> 
>  	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
> 
> +	sysfs_dir_dec_nlink(sd->s_parent);
>  	sysfs_unlink_sibling(sd);
> 
>  	/* Update timestamps on the parent */

Shouldn't s_nlink be adjusted in sysfs_rename for the move case as well?
