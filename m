Return-Path: <linux-kernel-owner+w=401wt.eu-S1762773AbZDBPZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762773AbZDBPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761619AbZDBPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:25:25 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:39194 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759802AbZDBPZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:25:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=DD182HajEPZ3EeETJQuqSTsnmnHTwbHrEchhh85sITB1jdDiL23Ok2NDgAJUdpbqGQt1zyJH/++eZVZK7TlN1+zGLkWnyn6gXzHY/01eHVqVbXuEpbbZMqjxKrQp0i7US0TuiZP0Zrj5GleS9hGCF9jiRR7EeRBfSGFplRWskd8=  ;
X-YMail-OSG: 6tBb8qcVM1nTXCK9COrQICoVU1PnkXW41PtBL693QBT2JJRjYwi476PyoEmvH_pCN_tYax_7BG4MRdTaOI_yxn0.0nyL7poA9ExCIb0k1vsvhzPkCml0gCtaNkDhcJGvriL7V32ARlp3cwH0VnG_MKaw_X467OTgVuXbM9Sh6hKqBeTDyXH4bqnNfRZDcSlP6tLLUIiM51CTdxIKUaEqW6mTP7HnmzqTR1eZqvolssxhcTbxNMExbSTtlGD1i5K_MPxV8ypkeEgTetcNw1RinzYPYSvCCNaKR6UVQbWFOEbRgcPbFGYAkQeO1yA8Cyq6B_HbEKygoukCglYNlGLSyT3lPw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Fri, 3 Apr 2009 02:25:15 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030055.26668.nickpiggin@yahoo.com.au> <20090401230352.28177.65878.stgit@warthog.procyon.org.uk> <5198.1238682972@redhat.com>
In-Reply-To: <5198.1238682972@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904030225.16372.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry for that html crap :(]

On Friday 03 April 2009 01:36:12 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > 1) PG_mappedtodisk is basically PG_owner_priv_2. Please alias that and
> > use it? Then at least we're down to 1 extra flag.
> > 2) Why do you need another PG_private?  PG_private for pagecache means
> > that it should call into the filesystem when it needs to handle fs data
> > attached to the page, right? So PG_private_2 doesn't really make sense
> > in that respect.
> 
> Won't that either break fs/buffer.c and fs/mpage.c or preclude the use of
> FS-Cache with block-based filesystems that use the standard buffer wangling
> routines?

Haven't looked closely at how fscache works. Possibly you can't reuse
mappedtodisk....

But PG_private. PG_private from the vm/vfs side means to call into the
filesystem. So from that point, the filesystem should handle it. It just
doesn't seem to make sense to have 2 flags for this.

I mean, there is only the single aop that can be called, so having 2 VM
visible flags doesn't help the VM do anything, and presumably your aop
knows how to handle this, so it should be an fs private bit.

Just give me a situation of why it won't work.


> As I've previously stated, I want to be able to make ISO9660 use FS-Cache.
> That rules out use of PG_mappedtodisk and PG_private for anything FS-Cache
> related.
> 
> We can actually reclaim PG_private, I think.  There are patches to do that.
> At the very least, we can probably reclaim the std buffering code's use of it.

But that's peripheral issue.

 
> If anything, avoiding the need for PG_fscache_write is probably easier - just
> more memory intensive and slower.  I could build a second radix tree for each
> inode that kept track of which pages from that inode FS-Cache knows about, and
> use the status bits in that node to keep track of what pages are being written
> out to the cache.

If it's not much slower, that would be nice.

 
> We still need a way of triggering the page invalidation callbacks for in-use
> pages, however.  PG_private, as I've said, is not currently a viable option.

Can you say exactly why not?
