Return-Path: <linux-kernel-owner+w=401wt.eu-S1161912AbXEDTkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161912AbXEDTkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161911AbXEDTkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:40:41 -0400
Received: from mga06.intel.com ([134.134.136.21]:28459 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161912AbXEDTkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,494,1170662400"; 
   d="scan'208";a="239432141"
Date: Fri, 4 May 2007 12:40:42 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: Theodore Tso <tytso@mit.edu>, David Chinner <dgc@sgi.com>,
       "Cabot, Mason B" <mason.b.cabot@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070504194036.GE3869@nifty>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070502154414.GB77450368@melbourne.sgi.com> <20070503211450.GA3869@nifty> <20070504122307.GA25339@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504122307.GA25339@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 08:23:08AM -0400, Theodore Tso wrote:
> On Thu, May 03, 2007 at 02:14:52PM -0700, Valerie Henson wrote:
> 
> > I'd really like to see a generic VFS-level detection of
> > read()/write()/creat()/mkdir()/etc. patterns which could detect things
> > like "Oh, this file is likely to be deleted immediately, wait and see
> > if it goes away and don't bother sending it on to the FS immediately"
> > or "Looks like this file will grow pretty big, let's go pre-allocate
> > some space for it."  This is probably best done as a set of helper
> > functions in the usual way.
> 
> What patterns do you think means things like "this file is likely to
> be deleted immediate", or "this file will grow pretty big"?  I don't
> think there are any that would be generally valid.

I wouldn't have guessed that either, but it turns out there are:

http://www.eecs.harvard.edu/~ellard/pubs/able-usenix04.pdf

    We present evidence that attributes that are known to
    the file system when a file is created, such as its name,
    permission mode, and owner, are often strongly related
    to future properties of the file such as its ultimate size,
    lifespan, and access pattern. More importantly, we show
    that we can exploit these relationships to automatically
    generate predictive models for these properties, and that
    these predictions are sufficiently accurate to enable opti-
    mizations.

For example, lock files have predictable names and permissions, and
live for a fraction of second in most cases.  Files which are appended
a few hundred bytes at a time are probably log files and will continue
to grow in this manner.  Some of their predictions were 98% accurate!

In any case, any predictive algorithms we already do at the file
system level can be done at the VFS level, and shared between file
systems, instead of being reimplemented over and over again.  Just
food for thought.

-VAL
