Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYLLCCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYLLCCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYLLCC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:02:29 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:32224 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756768AbYLLCC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:02:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tjA77wczK86zV/Xbadq7bRG7jb+ddPwJT6nJrXB7Don4AZS0+6F0ICdge18+YEEUpUNDOtG6SHDgI6KTUgYxoVlrPx7PBuwcMMEaTHlviNASpeDFBoQOCyF6bfUh8ToEoCMsJnA7Ju7MFTBHfjX7vAonkU+5XZw74TS58esFvPk=  ;
X-YMail-OSG: sAaPuIcVM1nOyoU9GEuoM_v4eOlnyEpuooHqauAQkw_yxSLq2kFW1qW.7L6MJW0qa3jo5zMp4CV0rLYoGaIrgQrvTyN6h9hj4th2ETBUKLhvD0i8CKNFM244Vqr_M7no1u6zfkuPEfhSAN2hndBbrP5L9K5XCQA5TZFaKSof
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH v3 1/7] fs: Use a percpu_counter to track nr_dentry
Date: Tue, 24 Jul 2007 11:24:51 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <493100B0.6090104@cosmosbay.com> <49419680.8010409@cosmosbay.com>
In-Reply-To: <49419680.8010409@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241124.52675.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 09:38, Eric Dumazet wrote:
> Adding a percpu_counter nr_dentry avoids cache line ping pongs
> between cpus to maintain this metric, and dcache_lock is
> no more needed to protect dentry_stat.nr_dentry
>
> We centralize nr_dentry updates at the right place :
> - increments in d_alloc()
> - decrements in d_free()
>
> d_alloc() can avoid taking dcache_lock if parent is NULL
>
> ("socketallocbench -n8" result : 27.5s to 25s)

Seems like a good idea.


> @@ -696,7 +712,7 @@ static void shrink_dcache_for_umount_subtree(struct
> dentry *dentry) * otherwise we ascend to the parent and move to the
>  			 * next sibling if there is one */
>  			if (!parent)
> -				goto out;
> +				return;
>
>  			dentry = parent;
>

Andrew doesn't like return from middle of function.
