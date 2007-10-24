Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbXJXPDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbXJXPDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbXJXPDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:03:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbXJXPDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:03:13 -0400
Message-ID: <471F5EA2.8060203@redhat.com>
Date: Wed, 24 Oct 2007 11:02:58 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071018)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] VFS: new fgetattr() file operation
References: <E1Iketp-0005dr-00@dorka.pomaz.szeredi.hu> <471F4254.9040206@redhat.com> <E1IkgW1-0005i0-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1IkgW1-0005i0-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> Miklos Szeredi wrote:
>>     
>>> I don't think Christoph will like the patch better, regardless of how
>>> I change the description.
>>>
>>> Of course, I'm open to suggestion on how to improve the interface, but
>>> I think fundamentally this is the only way to correctly deal with the
>>> below problem.
>>>
>>> Anyway, here's the patch another time, please consider adding it to
>>> -mm.  For 2.6.25 obviously.
>>>
>>> Thanks,
>>> Miklos
>>> ----
>>>
>>> From: Miklos Szeredi <mszeredi@suse.cz>
>>>
>>> Add a new file operation: f_op->fgetattr(), that is invoked by
>>> fstat().  Fall back to i_op->getattr() if it is not defined.
>>>
>>> We need this because fstat() semantics can in some cases be better
>>> implemented if the filesystem has the open file available.
>>>
>>> Let's take the following example: we have a network filesystem, with
>>> the server implemented as an unprivileged userspace process running on
>>> a UNIX system (this is basically what sshfs does).
>>>
>>> We want the filesystem to follow the familiar UNIX file semantics as
>>> closely as possible.  If for example we have this sequence of events,
>>> we still would like fstat to work correctly:
>>>
>>>  1) file X is opened on client
>>>  2) file X is renamed to Y on server
>>>  3) fstat() is performed on open file descriptor on client
>>>
>>> This is only possible if the filesystem server acutally uses fstat()
>>> on a file descriptor obtained when the file was opened.  Which means,
>>> the filesystem client needs a way to get this information from the
>>> VFS.
>>>
>>>   
>>>       
>> This true iff the protocol that this mythical
>>     
>
> Not mythical at all.  As noted in the description, there's sshfs, a
> live and quite popular example of this sort of filesystem.
>
>   
>> network file system uses the name of the file on the server to
>> actually identify the file on the server.
>>     
>
> The constraint is that the server has to be an ordinary unprivileged
> process.  How should it identify the file, other than by name, or by
> an open file descriptor?
>
>   

I explained this.  The fileid and the generation count along
with the file system id will uniquely identify the file.

>> Clearly, this is broken on many levels.  It can't handle
>> situations as described nor can it handle different instances
>> of the same filename being used.
>>     
>
> Can you please give concrete examples what it can't handle, and how
> should the implementation be improved to be able to handle it, given
> the above constraints?
>
>   
>> This is why NFS, a network file system, does not use the filename
>> as part of the file handle.
>>     
>
> And the nfs server isn't a userspace process, or if it is, it must use
> horrible hacks to convert the file handle to a name, that don't work
> half the time.
>
>   

Nice try.  Wrong.  Try a different rationalization.

>> Wouldn't you be better off by attempting to implement an "open
>> by ino" operation and an operation to get the generation count
>> for the file and then modifying the network protocol of interest
>> to use these as identifiers for the file to be manipulated?
>>     
>
> You mean an "open by inode" on the userspace API?  My guess, it
> wouldn't get very far.
>
>   

This isn't a new idea and has been implemented on a variety of
different systems.

> Anyway, that would still not work on old servers, and servers running
> other OS's.
>
>   

I didn't think that we were talking about old servers and other
OS's.  My concern at the moment is Linux and the changes being
made to it.

> Note, the point is _not_ to make a brand new NFS replacement
> filesystem, that can use names instead of file handles.  The point is
> to use existing infrastructure, to make the setup as easy as ssh'ing
> to a different machine.  And sshfs does just that.

And the solution is limiting.  It is not scalable nor particularly
interesting to anyone interested in security.  Unless there is a
way of limiting access to a particular set of files, then it is
not generally useful outside of hackers or perhaps small groups
of users not concerned about too many aspects of security.

I am not interested in an extended discussion of this topic.

    Thanx...

       ps
