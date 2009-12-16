Return-Path: <linux-kernel-owner+w=401wt.eu-S934241AbZLPAGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241AbZLPAGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934125AbZLPAGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:06:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43814 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbZLPAGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:06:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with 2.6.32-git1
Cc: kosaki.motohiro@jp.fujitsu.com, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
In-Reply-To: <20091215233841.GE22392@basil.fritz.box>
References: <20091215222134.GA27892@ZenIV.linux.org.uk> <20091215233841.GE22392@basil.fritz.box>
Message-Id: <20091216085051.CDE2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Dec 2009 09:06:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Dec 15, 2009 at 10:21:34PM +0000, Al Viro wrote:
> > On Mon, Dec 07, 2009 at 02:20:09PM +0100, Andi Kleen wrote:
> > > >    nfs_readdir
> > > >      nfs_do_filldir
> > > >        filldir
> > > >          copy_to_user
> > > >            [page_fault]			[grab mmap_sem]
> > > > 
> > > >  sys_mmap				[grab mmap_sem]
> > > >    do_mmap_pgoff
> > > >      mmap_region
> > > >        nfs_file_mmap
> > > >          nfs_revalidate_mapping  
> > > >            nfs_invalidate_mapping	[grab i_mutex]
> > > > 
> > > > I guess recent lockdep improvement find old bug.
> > > 
> > > Thanks for the analysis.
> > > 
> > > I guess should never do copy_*_user while holding i_mutex? There might
> > > be lots of cases like that.
> > 
> > No.  mmap_sem inside i_mutex is the normal order; NFS mmap is doing the
> > wrong thing here.  Note that readdir() vs. NFS (file-only, thankfully ;-)
> > mmap() is a non-issue; NFS mmap() vs. write() is much more interesting.
> 
> I see.
> 
> > 
> > Again, a lot of mm/* code expects i_mutex, then mmap_sem order.  It's not
> > just readdir().
> 
> I suppose an easy workaround would be to not revalidate in mmap,
> because open should have already done that?
> 
> Very lightly tested RFC patch attached.
> 
> -Andi
> 
> ---
> 
> NFS: don't revalidate in mmap
> 
> nfs_revalidate_mapping takes i_mutex, but mmap already has mmap_sem
> hold and taking i_mutex inside mmap_sem is not allowed by the VFS.
> 
> So don't revalidate on mmap time and trust it has been already done.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

afaik, no revalidate mean "I don't mind the file was already removed
at server, I only care client handle".

What's happen if we mmap removed file? 




