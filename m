Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYLCSvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYLCSvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYLCSvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:51:00 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43910 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYLCSvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:51:00 -0500
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1228328654.2821.35.camel@localhost.localdomain>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
	 <1228260925.2971.240.camel@nimitz>  <20081203130301.GA9681@infradead.org>
	 <1228328654.2821.35.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 10:50:55 -0800
Message-Id: <1228330255.26913.29.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 13:24 -0500, Mimi Zohar wrote:
> On Wed, 2008-12-03 at 08:03 -0500, Christoph Hellwig wrote: 
> > On Tue, Dec 02, 2008 at 03:35:25PM -0800, Dave Hansen wrote:
> > > I have memories of talking about this bit.  I was confused and you
> > > explained it to me, but it still isn't explained in the code. :(  Again,
> > > I'm not convinced that this works.  Can the code convince me, or should
> > > I go digging in my inbox?
> > 
> > I also haven't seen a good explanation for it yet.
> 
> Previous posting:
> "The OS protects against an executable file, already open for write,
> from being executed; and an executable file, open for execute, from
> being modified.  In the same vein, we want to know that the file
> measured is the same file read, that it hasn't been modified.  So, if a
> file already open for read is then opened for write, we log it with a
> "Time of Measure, Time of Use" error (ToMToU) and invalidate the
> PCR.....
> 
> This is important when measuring configuration files, shell scripts (not
> measured in brpm_check_integrity which are protected by the OS), and
> files imported/included by scripts."
> 
> Another posting:
> "From an integrity perspective, a file measurement might be invalidated
> unnecessarily, but it is safe. For any file when opened for write, while
> having an existing reader, will cause the file measurement to be
> invalidated."

Those are all great explanations.  But, some of that needs to get in the
patch somehow.  This is a subtle thing and someone looking at this a
year for now is going to have difficulty understanding why it was done.

> I'm just not seeing a problem. Perhaps because only regular files are
> being measured, and of them, only those defined by the policy, which
> most likely would not include pseudo filesystems (i.e. sysfs, procfs,
> tmpfs, securityfs).

There is no practical problem if you have false-positives on this check
and do extra invalidations.  But, I think both Christoph and I are
nervous that this check is racy and there may be false-negatives and
thus may miss some invalidations (which would be harmful).

The check is racy which is cause for concern by itself.  But, with
careful consideration, it may not be a dangerous or harmful race.  Could
you please consider it carefully and share some of your thoughts in a
comment in the next version?

You need to check very, very carefully that there are no possible ways
for i_writecount to be elevated without a corresponding elevation of
d_count.  I'm especially concerned as I look at some of the mmap() code.
It appears that there are some temporary i_writecount elevations as
VM_DENYWRITE is figured out.  That needs some careful auditing to ensure
it doesn't violate what is being assumed in the integrity code.

-- Dave

