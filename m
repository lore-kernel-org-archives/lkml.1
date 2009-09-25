Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZIYMsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZIYMsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 08:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZIYMr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 08:47:59 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:38105 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbZIYMr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 08:47:58 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Staubach <staubach@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: mmap vs mtime in 2.6.26 and up
References: <20090518114305.GA6303@infradead.org>
Date: Fri, 25 Sep 2009 14:47:42 +0200
In-Reply-To: Ferenc Wagner's message of "Wed, 22 Jul 2009 20:01:54 +0200"
Message-ID: <87vdj742dt.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> Christoph Hellwig <hch@infradead.org> writes:
>
>> On Fri, May 15, 2009 at 12:50:54PM -0400, Christoph Hellwig wrote:
>>
>>> On Fri, May 15, 2009 at 06:40:29PM +0200, Ferenc Wagner wrote:
>>>
>>>> Thanks for the analysis.  Unfortunately I don't nearly know enough to
>>>> work on this issue, but would like to track it as it affects our
>>>> backup system.  So, shouldn't #2645 be reopened again?
>>> 
>>> Yes, definitively as the current "fix" is incorrected.  I'll try to cook
>>> up a correct version once I get some time.
>>
>> Doing this correctly in the framework of the current codee is
>> unfortunately not so easy, as calling ->setattr requires taking i_mutex
>> which we can't in the pagefaul path.
>>
>> To fix this properly we need to actually update the timestamps during
>> msync and co as done by the patches from Miklos:
>> 	http://lkml.org/lkml/2007/2/28/166
>> and Peter:
>> 	http://lkml.org/lkml/2006/5/31/176
>
> http://bugzilla.kernel.org/show_bug.cgi?id=2645#c53 shows that Anton
> doesn't quite agree with you on this.  I really can't tell, would you
> (or anybody from the accused XFS community) please comment?  Or did
> you perhaps fix it meanwhile?  I can't easily test newer kernels, but
> I will if there's some chance.

I added some fresh test results to
http://bugzilla.kernel.org/show_bug.cgi?id=2645.  In short, under
2.6.30-rc8 the test program reports full failure on XFS and RAMFS,
full success on EXT3, VFAT and ReiserFS, and mixed results on TMPFS:

$ ./mmap /dev/shm/testfile 
Modifying /dev/shm/testfile...
Flushing data using sync()...
Failure: time not changed.
Not modifying /dev/shm/testfile...
Flushing data using msync()...
Success: time not changed.
Not modifying /dev/shm/testfile...
Flushing data using fsync()...
Success: time not changed.
Modifying /dev/shm/testfile...
Flushing data using msync()...
Failure: time not changed.
Modifying /dev/shm/testfile...
Flushing data using fsync()...
Failure: time not changed.

This doesn't look like az XFS-specific issue, but XFS is definitely
affected.  Anybody's got an idea how to tackle this?
-- 
Regards,
Feri.
