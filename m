Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbYARRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbYARRzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757642AbYARRzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:55:32 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:17077 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbYARRzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:55:31 -0500
In-Reply-To: <4790E227.506@redhat.com>
References: <4790C756.2040704@redhat.com> <63F84201-9D38-4588-B237-A15138E94C5A@oracle.com> <4790D9F3.2070503@redhat.com> <451AC300-674E-4DBE-869F-08A9184051B3@oracle.com> <4790E227.506@redhat.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D4189D74-D4AB-42CA-A788-40A50518E7DA@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 0/3] enhanced ESTALE error handling
Date: Fri, 18 Jan 2008 12:52:45 -0500
To: Peter Staubach <staubach@redhat.com>
X-Mailer: Apple Mail (2.753)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008, at 12:30 PM, Peter Staubach wrote:
> Chuck Lever wrote:
>> On Jan 18, 2008, at 11:55 AM, Peter Staubach wrote:
>>> Chuck Lever wrote:
>>>> Hi Peter-
>>>>
>>>> On Jan 18, 2008, at 10:35 AM, Peter Staubach wrote:
>>>>> Hi.
>>>>>
>>>>> Here is a patch set which modifies the system to enhance the
>>>>> ESTALE error handling for system calls which take pathnames
>>>>> as arguments.
>>>>
>>>> The VFS already handles ESTALE.
>>>>
>>>> If a pathname resolution encounters an ESTALE at any point, the  
>>>> resolution is restarted exactly once, and an additional flag is  
>>>> passed to the file system during each lookup that forces each  
>>>> component in the path to be revalidated on the server.  This has  
>>>> no possibility of causing an infinite loop.
>>>>
>>>> Is there some part of this logic that is no longer working?
>>>
>>> The VFS does not fully handle ESTALE.  An ESTALE error can occur
>>> during the second pathname resolution attempt.
>>
>> If an ESTALE occurs during the second resolution attempt, we  
>> should give up.  When I addressed this issue two years ago, the  
>> two-try logic was the only acceptable solution because there's no  
>> way to guarantee the pathname resolution will ever finish unless  
>> we put a hard limit on it.
>>
>
> I can probably imagine a situation where the pathname resolution
> would never finish, but I am not sure that it could ever happen
> in nature.

Unless someone is doing something malicious.  Or if the server is  
repeatedly returning ESTALE for some reason.

>>> There are lots of
>>> reasons, some of which are the 1 second resolution from some file
>>> systems on the server
>>
>> Which is a server bug, AFAICS.  It's simply impossible to close  
>> all the windows that result from sloppy file time stamps without  
>> completely disabling client-side caching.  The NFS protocol relies  
>> on file time stamps to manage cache coherence.  If the server is  
>> lying about time stamps, there's no way the client can cache  
>> coherently.
>>
>
> Server bug or not, it is something that the client has to live
> with.  We can't get the server file system fixed, so it is
> something that we should find a way to live with.  This support
> can help.

We haven't identified a server-side solution yet, but that doesn't  
mean it doesn't exist.

If we address the time stamp problem in the client, should we also go  
to lengths to address it in every other corner of the NFS client?   
Should we also address every other server bug we discover with a  
client side fix?

>>> Also, there was no support for ESTALE errors which occur during
>>> subsequent operations to the pathname resolution process.  For
>>> example, during a mkdir(2) operation, the ESTALE can occur from
>>> the over the wire MKDIR operation after the LOOKUP operations
>>> have all succeeded.
>>
>> If the final operation fails after a pathname resolution, then  
>> it's a real error.  Is there a fixed and valid recovery script for  
>> the client in this case that will allow the mkdir to proceed?
>>
>
> Why do you think that it is an error?

Because this is a problem that sometimes requires application-level  
recovery.  Can we guarantee that retrying the mkdir is the right  
thing to do every time?

> It can easily occur if the directory in which the new directory
> is to be created disppears after it is looked up and before the
> MKDIR is issued.
>
> The recovery is to perform the lookup again.

Have you tried this client against a file server when you unexport  
the filesystem under test?  The server returns ESTALE no matter what  
the client does.  Should the client continue to retry the request if  
the file system has been permanently taken offline?

>> Admittedly, the NFS client could recover more cleanly from some of  
>> these problems, but given the architecture of the Linux VFS, it  
>> will be difficult to address some of the corner cases.
>
> Could you outline some of these corner cases that this proposal
> would not address, please?

I think we have one right here: should the client retry a mkdir if  
gets an ESTALE?

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
