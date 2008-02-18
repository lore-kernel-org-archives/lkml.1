Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYBRQLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYBRQLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYBRQLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:11:06 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43882 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbYBRQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:11:05 -0500
To: haveblue@us.ibm.com
CC: linux-kernel@vger.kernel.org, hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       haveblue@us.ibm.com
In-reply-to: <20080215223759.6B1F044A@kernel> (message from Dave Hansen on
	Fri, 15 Feb 2008 14:37:59 -0800)
Subject: Re: [PATCH 28/30] r/o bind mounts: track numbers of writers to mounts
References: <20080215223721.9E0A088A@kernel> <20080215223759.6B1F044A@kernel>
Message-Id: <E1JR8a0-0003sT-8d@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Feb 2008 17:10:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -327,7 +514,30 @@ static struct vfsmount *clone_mnt(struct
>  
>  static inline void __mntput(struct vfsmount *mnt)
>  {
> +	int cpu;
>  	struct super_block *sb = mnt->mnt_sb;
> +	/*
> +	 * We don't have to hold all of the locks at the
> +	 * same time here because we know that we're the
> +	 * last reference to mnt and that no new writers
> +	 * can come in.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		struct mnt_writer *cpu_writer = &per_cpu(mnt_writers, cpu);
> +		if (cpu_writer->mnt != mnt)
> +			continue;
> +		spin_lock(&cpu_writer->lock);
> +		atomic_add(cpu_writer->count, &mnt->__mnt_writers);
> +		cpu_writer->count = 0;

I think you should also add a

		cpu_writer->mnt = NULL;

here.  It's not a bug, but I had to think a bit about why it's not a bug.

Miklos
