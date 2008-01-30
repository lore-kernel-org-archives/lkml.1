Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYA3WiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYA3WiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbYA3Wh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:37:56 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:41059 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbYA3Whx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:37:53 -0500
In-Reply-To: <18686.1201663501@redhat.com>
References: <479901A8.3000706@oracle.com> <20080123172038.11107.86025.stgit@warthog.procyon.org.uk> <20080123172246.11107.62216.stgit@warthog.procyon.org.uk> <18686.1201663501@redhat.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8DB49AEC-5DA8-4AC3-A660-689E6BC80D2E@oracle.com>
Cc: Trond.Myklebust@netapp.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 24/27] NFS: Use local caching [try #2]
Date: Wed, 30 Jan 2008 17:36:16 -0500
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.753)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David-

On Jan 29, 2008, at 10:25 PM, David Howells wrote:
> Chuck Lever <chuck.lever@oracle.com> wrote:
>> This patch really ought to be broken into more manageable atomic
>> changes to make it easier to review, and to provide more fine-grained
>> explanation and rationalization for each specific change via
>> individual patch descriptions.
>
> Hmmm....  I broke the patch up as Trond stipulated - at least, I  
> thought I
> had.
>
> In many ways this request doesn't make sense.  You can't do NFS  
> caching
> without all the appropriate bits, so logically they should be one  
> patch.
> Breaking it up won't help git-bisect since the option to enable all  
> this is
> the last (or nearly last) patch.

In addition to adding a new feature, you are changing existing code.   
If any one of the changes you made breaks existing behavior, having  
them all in small atomic patches makes it practical to bisect and  
find the problem.

In addition it makes it worlds easier to review by people who are not  
so familiar with your fscache implementation.  And smaller patches  
means the ratio of patch descriptions to code changes can be much  
higher.

It does make sense to introduce the files under fs/fsc in a single  
patch.  But when you are changing code that is already being used,  
more care needs to be taken.

>> This should no longer be necessary.  The latest mount.nfs subcommand
>> from nfs-utils supports text-based mounts when running on kernels
>> 2.6.23 and later.
>
> Okay.  I'll update my patches to reflect this.  Note, however, I've  
> got
> someone reporting a bug that seems to show otherwise.  I'll have to
> investigate this more next week.

The very latest version (post 1.1.1) is required today for text-based  
NFS mounts.  (That is, the bleeding edge version you get by cloning  
the nfs-utils git repo).

And it only works on kernels later than 2.6.22 -- if that particular  
user is testing fscache on 2.6.22 or older, then only the legacy  
binary NFS mount system call API is supported.

>> Add comments like this in a separate clean up patch.
>
> ????

+/*
+ * Notification that a PTE pointing to an NFS page is about to be made
+ * writable, implying that someone is about to modify the page  
through a
+ * shared-writable mapping
+ */

What does that have to do with local disk caching?

>>> +struct nfs_fh_auxdata {
>>> +	struct timespec	i_mtime;
>>> +	struct timespec	i_ctime;
>>> +	loff_t		i_size;
>>> +};
>>
>> It might be useful to explain here why you need to supplement the
>> mtime, ctime, and size fields that already exist in an NFS inode.
>
> Supplement?  I don't understand.

Why is it necessary to add additional mtime, ctime and size fields  
for NFS inodes?  Similar metadata is already stored in nfsi.

All I'm asking for is some documentation of what these fields do that  
the existing time stamps and size fields in nfsi don't.  Explain why  
the NFS fsc implementation needs this data structure.

>>> +		key->port = clp->cl_addr.sin_port;
>>
>> Not sure why you are using the server's port here.  In almost every
>> case the server side port number will be 2049, so it really doesn't
>> add any uniquification.
>
> The reason lies is "in almost every case".  It's possible to  
> configure it
> such that a server is running two separate NFS servers on different  
> ports.

We should explore whether it is typical or even possible that such a  
configuration exports the same file handles on different ports, and  
whether that really matters to the client.

>> I strongly recommend you use the existing IPv6 address conversion
>> macros for this instead of open-coding yet another way of mapping an
>> IPv4 address to an IPv6 address.
>>
>> However, since AF_INET6 support is being introduced in the NFS client
>> in 2.6.24, I recommend you take a look at these source files after
>> Trond has pushed his NFS_ALL for 2.6.24.
>
> I'll look at them.

I always do this:  I meant 2.6.25, not 2.6.24.

By the time you return, basic IPv6 support for NFSv4 should be in  
2.6.25-rc1's NFS client (not server).  Not that it is bug-free, but  
an implementation is now there.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
