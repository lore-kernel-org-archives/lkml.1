Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbZLGNUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbZLGNUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZLGNUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:20:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42397 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbZLGNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:20:06 -0500
Date: Mon, 7 Dec 2009 14:20:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with 2.6.32-git1
Message-ID: <20091207132009.GI18989@one.firstfloor.org>
References: <20091207115949.GA7610@basil.fritz.box> <20091207211216.E95E.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207211216.E95E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 09:19:28PM +0900, KOSAKI Motohiro wrote:
> > 
> > While booting 2.6.32-git1 on a NFS root box I got the following
> > lockdep warning early at boot. I haven't looked at details.
> 
> It seems typical ABBA deadlock.
> 
>  vfs_readdir				[grab i_mutex]
>    nfs_readdir
>      nfs_do_filldir
>        filldir
>          copy_to_user
>            [page_fault]			[grab mmap_sem]
> 
>  sys_mmap				[grab mmap_sem]
>    do_mmap_pgoff
>      mmap_region
>        nfs_file_mmap
>          nfs_revalidate_mapping  
>            nfs_invalidate_mapping	[grab i_mutex]
> 
> I guess recent lockdep improvement find old bug.

Thanks for the analysis.

I guess should never do copy_*_user while holding i_mutex? There might
be lots of cases like that.

-Andi
