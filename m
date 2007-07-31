Return-Path: <linux-kernel-owner+w=401wt.eu-S1762558AbXGaRNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762558AbXGaRNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXGaRNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:13:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46713 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbXGaRNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:13:37 -0400
Date: Tue, 31 Jul 2007 13:11:59 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731171159.GA27234@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731170012.GN5101@hasse.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 07:00:12PM +0200, Jan Blunck wrote:
> On Tue, Jul 31, Josef Sipek wrote:
> 
> > On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> > > Introduce white-out support to ext2.
> > 
> > I think storing whiteouts on the branches is wrong. It creates all sort of
> > nasty cases when people actually try to use unioning. Imagine a (no-so
> > unlikely) scenario where you have 2 unions, and they share a branch. If you
> > create a whiteout in one union on that shared branch, the whiteout magically
> > affects the other union as well! Whiteouts are a union-level construct, and
> > therefore storing them at the branch level is wrong.
> 
> So you think that just because you mounted the filesystem somewhere else it
> should look different? This is what sharing is all about. If you share a
> filesystem you also share the removal of objects.

The removal happens at the union level, not the branch level. Say you have:

/a/
/b/foo
/c/foo

And you mount /u1 as a union of {a,b}, and /u2 as union of {a,c}.

$ find /u*
/u1
/u1/foo
/u2
/u2/foo
$ rm /u1/foo # this creates whiteout for "foo" in /a
$ find /u*
/u1
/u2

Is that what you'd expect as a user? I don't think so.

...
> > Really the only sane way of keeping track of whiteouts seems some external
> > store. We did an experiment with Unionfs, and moving the whiteout handling
> > to effectively a "library" that did all the dirty work cleaned up the code
> > considerably [2,3].
> 
> Haven't checked if you could use ODF for a generic store for filesystems that
> couldn't support whiteouts. This might be an interesting idea.
 
Yes, since the ODF is completely separate, you can use _any_ filesystem and
regardless of whether or not they support whiteouts.

Josef 'Jeff' Sipek.

-- 
Once you have their hardware. Never give it back.
(The First Rule of Hardware Acquisition)
