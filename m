Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZDBTIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZDBTIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZDBTIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:08:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44706 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZDBTIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:08:19 -0400
Subject: Re: [patch 1/2] fs: mnt_want_write speedup
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090402184305.GI28946@ZenIV.linux.org.uk>
References: <20090310143718.GB15977@wotan.suse.de>
	 <1236809477.30142.83.camel@nimitz> <20090312041334.GB1893@wotan.suse.de>
	 <1237403623.8286.196.camel@nimitz> <20090402182210.GB17175@wotan.suse.de>
	 <20090402184305.GI28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 12:08:07 -0700
Message-Id: <1238699287.8846.58.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 19:43 +0100, Al Viro wrote:
> On Thu, Apr 02, 2009 at 08:22:10PM +0200, Nick Piggin wrote:
> > On Wed, Mar 18, 2009 at 12:13:43PM -0700, Dave Hansen wrote:
> > > On Thu, 2009-03-12 at 05:13 +0100, Nick Piggin wrote: 
> > > > On Wed, Mar 11, 2009 at 03:11:17PM -0700, Dave Hansen wrote:
> > > > > I'm feeling a bit better about these, although I am still honestly quite
> > > > > afraid of the barriers.  I also didn't like all the #ifdefs much, but
> > > > > here's some help on that.
> > > > 
> > > > FWIW, we have this in suse kernels because page fault performance was
> > > > so bad compared with SLES10. mnt_want_write & co was I think the 2nd
> > > > biggest offender for file backed mappings (after pvops). I think we're
> > > > around parity again even with pvops.
> > > 
> > > Page faults themselves?  Which path was that from?
> > 
> > Yes. file_update_time.
> 
> FWIW, I'm not sure that this optimization is valid.  We might eventually
> want to go for "don't allow any new writers, remount r/o when existing
> ones expire" functionality, so nested mnt_want_write() might eventually
> be allowed to fail.

That makes sense on a larger scale definitely.

But I do wonder about file_update_time() specifically, especially since
its mnt_want_write() is never persistent and it is always done under the
cover of a FMODE_WRITE 'struct file'.  Do we strictly even need the
mnt_want/drop_write() pair in here at all right now?

-- Dave

