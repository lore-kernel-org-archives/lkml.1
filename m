Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZDWQQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZDWQQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDWQQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:16:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33262 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZDWQQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:16:07 -0400
Message-ID: <49F092E5.9020601@redhat.com>
Date: Thu, 23 Apr 2009 12:10:13 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Valerie Aurora Henson <vaurora@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423160426.GF8476@shell>
In-Reply-To: <20090423160426.GF8476@shell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valerie Aurora Henson wrote:
> On Wed, Apr 22, 2009 at 10:17:48PM -0700, Andrew Morton wrote:
>> On Wed, 22 Apr 2009 20:12:57 -0400 Valerie Aurora Henson <vaurora@redhat.com> wrote:
>>
>>> In the default mode for ext3 and btrfs, fsync() is both slow and
>>> unnecessary for some important application use cases - at the same
>>> time that it is absolutely required for correctness for other modes of
>>> ext3, ext4, XFS, etc.  If applications could easilyl distinguish
>>> between the two cases, they would be more likely to be correct and
>>> fast.
>>>
>>> How about an fpathconf() variable, something like _PC_ORDERED?  E.g.:
>>>
>>> 	/* Unoptimized example optional fsync() demo */
>>> 	write(fd);
>>> 	/* Only fsync() if we need it */
>>> 	if (fpath_conf(fd, _PC_ORDERED) != 1)
>>> 		fsync(fd);
>>> 	rename(tmp_path, new_path);
>>>
>>> I know of two specific real-world cases in which this would
>>> significantly improve performance: (a) fsync() before rename(), (b)
>>> fsync() of the parent directory of a newly created file.  Case (b) is
>>> particularly nasty when you have multiple threads creating files in
>>> the same directory because the dir's i_mutex is held across fsync() -
>>> file creates become limited to the speed of sequential fsync()s.
>>>
>>> Conceptual libc patch below.
>> Would it be better to implement new syscall(s) with finer-grained control
>> and better semantics?  Then userspace would just need to to:
>>
>> 	fsync_on_steroids(fd, FSYNC_BEFORE_RENAME);
>>
>> and that all gets down into the filesystem which can then work out what
>> it needs to do to implement the command.
> 
> You and Jamie have a good point: fsync() is a very big hammer used for
> many different purposes, and it would be nice to have finer-grained
> tools.  There are distinct limits to what you can do to optimize a
> full fsync(); we should be thrilled to get fewer of them from userspace.
> 
> Like others, I am concerned about the complexity for the programmer.
> Perhaps in addition to the various fine-grained options, there is a:
> 
> 	fsync_on_steroids(fd, FSYNC_DO_WHAT_ORDERED_WOULD_DO);
> 
> The idea is that we've currently got a lot of code that assumes ext3
> data=ordered semantics (btrfs will fulfill these assumptions too).  It
> would be nice if we had one simple drop-in test to distinguish between
> ext3-ordered/btrfs/reiserfs and all other fs's; I think we'd get a lot
> more adoption that way.
> 
> All that being said, I'd be thrilled to have fine-grained fsync().
> 
> -VAL

I like the fine grained fsync variation as well. We could reimplement the 
standard fsync to be safe, boring and relatively slow while allowing the few 
really sophisticated users the extra options.

It would also make it easier to insure that the traditional fsync() semantics 
are not weakened in unexpected ways for apps that care.

ric

