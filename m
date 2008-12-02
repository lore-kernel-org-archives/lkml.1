Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYLBU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYLBU4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLBU4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:56:08 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34349 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750966AbYLBU4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:56:05 -0500
Date: Tue, 2 Dec 2008 15:55:58 -0500
From: Theodore Tso <tytso@mit.edu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Pavel Machek <pavel@suse.cz>, mikulas@artax.karlin.mff.cuni.cz,
       clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081202205558.GD20858@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Friesen <cfriesen@nortel.com>, Pavel Machek <pavel@suse.cz>,
	mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
	kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu> <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49356EF2.7060806@nortel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 11:22:58AM -0600, Chris Friesen wrote:
> Theodore Tso wrote:
>
>> Even for ext3/ext4 which is doing physical journalling, it's still the
>> case that the journal commits first, and it's only later when the
>> write happens that we write out the change.  If the disk fails some of
>> the writes, it's possible to lose data, especially if the two blocks
>> involved in the node split are far apart, and the write to the
>> existing old btree block fails.
>
> Yikes.  I was under the impression that once the journal hit the platter  
> then the data were safe (barring media corruption).

Well, this is a case of media corruption (or a cosmic ray hitting
hitting a ribbon cable in the disk controller sending the write to the
wrong location on disk, or someone bumping the server causing the disk
head to lift up a little higher than normal while it was writing the
disk sector, etc.).  But it is a case of the hard drive misbehaving. 

Heck, if you have a hiccup while writing an inode table block out to
disk (for example a power failure at just the wrong time), so the
memory (which is more voltage sensitive than hard drives) DMA's
garbage which gets written to the inode table, you could lose a large
number of adjacent inodes when garbage gets splatted over the inode
table.

Ext3 tends to recover from this better than other filesystems, thanks
to the fact that it does physical block journalling, but you do pay
for this in terms of performance if you have a metadata-intensive
workload, because you're writing more bytes to the journal for each
metadata opeation.

> It seems like the more I learn about filesystems, the more failure modes  
> there are and the fewer guarantees can be made.  It's amazing that  
> things work as well as they do...

There are certainly things you can do.  Put your fileservers's on
UPS's.  Use RAID.  Make backups.   Do all three.  :-)

	    	   		      	  - Ted
