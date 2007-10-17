Return-Path: <linux-kernel-owner+w=401wt.eu-S935344AbXJQUbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbXJQUbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760633AbXJQUb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:31:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39901 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbXJQUb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:31:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chris Mason <chris.mason@oracle.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
References: <200710151028.34407.borntraeger@de.ibm.com>
	<m1zlykj8zl.fsf_-_@ebiederm.dsl.xmission.com>
	<200710160956.58061.borntraeger@de.ibm.com>
	<200710171814.01717.borntraeger@de.ibm.com>
	<m1sl49ei8x.fsf@ebiederm.dsl.xmission.com>
	<1192648456.15717.7.camel@think.oraclecorp.com>
Date: Wed, 17 Oct 2007 14:29:20 -0600
In-Reply-To: <1192648456.15717.7.camel@think.oraclecorp.com> (Chris Mason's
	message of "Wed, 17 Oct 2007 15:14:16 -0400")
Message-ID: <m17illeb8f.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:

> In this case, the commit block isn't allowed to be dirty before reiserfs
> decides it is safe to write it.  The journal code expects it is the only
> spot in the kernel setting buffer heads dirty, and it only does so after
> the rest of the log blocks are safely on disk.

Ok.  So the journal code here fundamentally depends on being able to
control the order of the writes, and something else being able to set
the buffer head dirty messes up that control.

> Given this is a ramdisk, the check can be ignored, but I'd rather not
> sprinkle if (ram_disk) into the FS code....

It makes no sense to implement a ramdisk in a way that requires this.


>> At the same time I increasingly don't think we should allow user space
>> to dirty or update our filesystem metadata buffer heads.  That seems
>> like asking for trouble.
>> 
>
> Demanding trouble ;)

Looks like it.  There are even comments in jbd about the same class
of problems.  Apparently dump and tune2fs on mounted filesystems have
triggered some of these issues.  The practical question is any of this
trouble worth handling.

Thinking about it.  I don't believe anyone has ever intentionally built
a filesystem tool that depends on being able to modify a file systems
metadata buffer heads while the filesystem is running, and doing that
would seem to be fragile as it would require a lot of cooperation
between the tool and the filesystem about how the filesystem uses and
implement things.

Now I guess I need to see how difficult a patch would be to give
filesystems magic inodes to keep their metadata buffer heads in.

Eric
