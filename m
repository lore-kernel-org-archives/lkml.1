Return-Path: <linux-kernel-owner+w=401wt.eu-S934045AbZLOWVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbZLOWVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbZLOWVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:21:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33899 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761375AbZLOWVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:21:41 -0500
Date: Tue, 15 Dec 2009 22:21:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
	2.6.32-git1
Message-ID: <20091215222134.GA27892@ZenIV.linux.org.uk>
References: <20091207115949.GA7610@basil.fritz.box> <20091207211216.E95E.A69D9226@jp.fujitsu.com> <20091207132009.GI18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207132009.GI18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 02:20:09PM +0100, Andi Kleen wrote:
> >    nfs_readdir
> >      nfs_do_filldir
> >        filldir
> >          copy_to_user
> >            [page_fault]			[grab mmap_sem]
> > 
> >  sys_mmap				[grab mmap_sem]
> >    do_mmap_pgoff
> >      mmap_region
> >        nfs_file_mmap
> >          nfs_revalidate_mapping  
> >            nfs_invalidate_mapping	[grab i_mutex]
> > 
> > I guess recent lockdep improvement find old bug.
> 
> Thanks for the analysis.
> 
> I guess should never do copy_*_user while holding i_mutex? There might
> be lots of cases like that.

No.  mmap_sem inside i_mutex is the normal order; NFS mmap is doing the
wrong thing here.  Note that readdir() vs. NFS (file-only, thankfully ;-)
mmap() is a non-issue; NFS mmap() vs. write() is much more interesting.

Again, a lot of mm/* code expects i_mutex, then mmap_sem order.  It's not
just readdir().
