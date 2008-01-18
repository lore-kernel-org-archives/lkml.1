Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbYARRbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbYARRbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761808AbYARRbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:31:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761428AbYARRbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:31:39 -0500
Message-ID: <4790E227.506@redhat.com>
Date: Fri, 18 Jan 2008 12:30:15 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071018)
MIME-Version: 1.0
To: Chuck Lever <chuck.lever@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/3] enhanced ESTALE error handling
References: <4790C756.2040704@redhat.com> <63F84201-9D38-4588-B237-A15138E94C5A@oracle.com> <4790D9F3.2070503@redhat.com> <451AC300-674E-4DBE-869F-08A9184051B3@oracle.com>
In-Reply-To: <451AC300-674E-4DBE-869F-08A9184051B3@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever wrote:
> On Jan 18, 2008, at 11:55 AM, Peter Staubach wrote:
>> Chuck Lever wrote:
>>> Hi Peter-
>>>
>>> On Jan 18, 2008, at 10:35 AM, Peter Staubach wrote:
>>>> Hi.
>>>>
>>>> Here is a patch set which modifies the system to enhance the
>>>> ESTALE error handling for system calls which take pathnames
>>>> as arguments.
>>>
>>> The VFS already handles ESTALE.
>>>
>>> If a pathname resolution encounters an ESTALE at any point, the 
>>> resolution is restarted exactly once, and an additional flag is 
>>> passed to the file system during each lookup that forces each 
>>> component in the path to be revalidated on the server.  This has no 
>>> possibility of causing an infinite loop.
>>>
>>> Is there some part of this logic that is no longer working?
>>
>> The VFS does not fully handle ESTALE.  An ESTALE error can occur
>> during the second pathname resolution attempt.
>
> If an ESTALE occurs during the second resolution attempt, we should 
> give up.  When I addressed this issue two years ago, the two-try logic 
> was the only acceptable solution because there's no way to guarantee 
> the pathname resolution will ever finish unless we put a hard limit on 
> it.
>

I can probably imagine a situation where the pathname resolution
would never finish, but I am not sure that it could ever happen
in nature.

>> There are lots of
>> reasons, some of which are the 1 second resolution from some file
>> systems on the server
>
> Which is a server bug, AFAICS.  It's simply impossible to close all 
> the windows that result from sloppy file time stamps without 
> completely disabling client-side caching.  The NFS protocol relies on 
> file time stamps to manage cache coherence.  If the server is lying 
> about time stamps, there's no way the client can cache coherently.
>

Server bug or not, it is something that the client has to live
with.  We can't get the server file system fixed, so it is
something that we should find a way to live with.  This support
can help.

>> and the window in between the revalidation
>> and the actual use of the file handle associated with each
>> dentry/inode pair.
>
> A use case or two would be useful to explore (on linux-nfs or 
> linux-fsdevel, rather than lkml).
>

I created a bunch of use cases in the gensyscall.c program that
I attached to the original description of the problem and my
proposed solution.  It was very useful in generating many, many
ESTALE errors over the wire from a variety of different over the
wire operations, which were originally getting returned to the
user level.

>> Also, there was no support for ESTALE errors which occur during
>> subsequent operations to the pathname resolution process.  For
>> example, during a mkdir(2) operation, the ESTALE can occur from
>> the over the wire MKDIR operation after the LOOKUP operations
>> have all succeeded.
>
> If the final operation fails after a pathname resolution, then it's a 
> real error.  Is there a fixed and valid recovery script for the client 
> in this case that will allow the mkdir to proceed?
>

Why do you think that it is an error?

It can easily occur if the directory in which the new directory
is to be created disppears after it is looked up and before the
MKDIR is issued.

The recovery is to perform the lookup again.

> Admittedly, the NFS client could recover more cleanly from some of 
> these problems, but given the architecture of the Linux VFS, it will 
> be difficult to address some of the corner cases. 

Could you outline some of these corner cases that this proposal
would not address, please?

I ran the test program for many hours, against several different
servers, and although I can't prove completeness, was not able to
show any ESTALE errors being returned unexpectedly.

    Thanx...

       ps
