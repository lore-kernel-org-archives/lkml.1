Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbYAJHxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbYAJHxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYAJHxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:53:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42594 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbYAJHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:53:37 -0500
Date: Wed, 9 Jan 2008 23:42:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       serue@us.ibm.com
Subject: Re: [PATCH] track number of mnts writing to superblocks
Message-Id: <20080109234250.baa3b13b.akpm@linux-foundation.org>
In-Reply-To: <20080102215110.F3A0B1DC@kernel>
References: <20080102215110.F3A0B1DC@kernel>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jan 2008 13:51:10 -0800 Dave Hansen <haveblue@us.ibm.com> wrote:

> 
> One of the benefits of the r/o bind mount patches is that they
> make it explicit when a write to a superblock might occur.
> We currently search sb->s_files when remounting rw->ro to look
> for writable files.  But, that search is not comprehensive, and
> it is racy.  This replaces that search.
> 
> The idea is to keep a bit in each mount saying whether the
> mount has any writers on it.  When the bit is set the first
> time, we also increment a counter in the superblock.  That
> sb counter is the number of mounts with that bit set and
> thus, potential writers.
> 
> The other problem is that, after we make this check for
> the number of writable mounts, we need to exclude all new
> writers on those mounts.  We do this by requring that the
> superblock mnt writer count be incremented under a
> lock_super() and also holding that lock over the remount
> operation.  Effectively, this keeps us from *adding* to
> the sb's writable mounts during a remount.
> 
> The alternative to doing this is to do a much simpler list
> of mounts for each superblock.  I could also code that up
> to see what it look like.  Shouldn't be too bad.
> 
>  ...
>
> -static inline void __clear_mnt_count(struct mnt_writer *cpu_writer)
> +static int mark_mnt_has_writer(struct vfsmount *mnt,
> +			       struct mnt_writer *cpu_writer)
> +{
> +	/*
> +	 * Ensure that if there are people racing to set
> +	 * the bit that only one of them succeeds and can
> +	 * increment the sb count.
> +	 */
> +	if (test_and_set_bit(ilog2(MNT_MAY_HAVE_WRITERS), &mnt->mnt_flags))
> +		return 0;

boggle.

a) bitops are to be used on unsigned long only, and mnt_flags is int.

b) nowhere else is mnt_flags used as a bitfield.  Presumably (hopefully)
   it already has some locking.  Suggest that the same locking be used
   here.

c) Given that all other modifiers of mnt_flags are using non-atomic
   rmw's, they can trash this function's rmw.  What happens then?

> +static void __mark_sb_if_writable(struct vfsmount *mnt)
> +{
> +	int bitnr = ilog2(MNT_MAY_HAVE_WRITERS);
> +
> +	if (atomic_read(&mnt->__mnt_writers))
> +		mark_mnt_has_writer(mnt, NULL);
> +	else if (test_and_clear_bit(bitnr, &mnt->mnt_flags))
> +		atomic_dec(&mnt->mnt_sb->__s_mnt_writers);
> +}

and elsewhere.


I'm a bit surprised to see such a thing coming from your direction, Dave.
