Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZDQAOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZDQAOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZDQANu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:13:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbZDQANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:13:49 -0400
Date: Fri, 17 Apr 2009 01:13:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417001345.GH26366@ZenIV.linux.org.uk>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417000142.GF21405@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 02:01:42AM +0200, Ingo Molnar wrote:
> 
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > remount is potentially nastier, but then it *is* nasty.  Again, 
> > it's only per-fs stuff, so the obvious first step is taking BKL 
> > down into the instances. It doesn't protect anything in VFS; all 
> > uses are fs internal, so that'll take review of individual 
> > filesystems.
> > 
> > NOTE: do not assume that code in fs/foo/* is correct; "it doesn't 
> > take BKL elsewhere" does _not_ mean that we don't have races.  
> > IOW, the same review ought to look for such beasts and deal with 
> > them.  Mere "oh, no BKL anywhere in that fs" is not enough to 
> > discard the ->remount_fs() instance.
> 
> what kind of races do you mean? Timing sensitive ones that are there 
> just are not easy to trigger with the BKL held?
> 
> Or actual locking interaction between that body of BKL code and all 
> other BKL using code?

Old foo_read_super/foo_write_super/foo_put_super/foo_remount_fs for the
same foo.  IOW, per-driver (and not per-fs - that's taken care of) data
structures.  Arbitrary weird ones.
