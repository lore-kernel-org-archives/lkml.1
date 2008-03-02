Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYCBCSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYCBCSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 21:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCBCSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 21:18:22 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36873 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYCBCSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 21:18:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: serge@hallyn.com, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Fix /proc/net in presence of net namespaces
References: <47C6D743.1050802@openvz.org>
	<m1y794514k.fsf@ebiederm.dsl.xmission.com>
	<20080228211720.GA1232@vino.hallyn.com>
	<m1k5ko4sfi.fsf@ebiederm.dsl.xmission.com>
	<47C7BB1B.9060906@openvz.org>
Date: Sat, 01 Mar 2008 19:17:00 -0700
In-Reply-To: <47C7BB1B.9060906@openvz.org> (Pavel Emelyanov's message of "Fri,
	29 Feb 2008 10:58:19 +0300")
Message-ID: <m1zlth3m5f.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:

>> I was thinking we might be able to hide the existence of
>> /proc/.netns/NNN/  however we can read the current working directory.
>> So even if we only allow explicit access through /proc/net and all
>> others paths don't work we have something that is visible.
>
> I have a patch that overrides the ->readdir method for /proc/.netns,
> so that you can no longer read the directory contents, but you still
> can guess one by guessing and opening files in it. Overriding the 
> ->lookup to screw one up looks like "shadowing" technics.

Or looking at the symlinks under /proc/<pid>/fd/1
Or opening something under /proc/net/ and calling get pwd.

> OTOH - consider you have the ids of existing net namespaces, but cannot 
> read the contents on any but yours. So what? This information is useless
> for you. So I dropped this part of a patch.

However it is fundamental that monitoring programs want to inspect
the namespaces of other processes.

In theory the resource group stuff was suppose to provide us with
all of the names we would need.  However the semantics seem a bit
to flexible to use for something like this.

>> - Have readdir and lookup filter the directory entries by the pid
>>   namespace of the proc mount.
>
> So, how are you going to filter the lookup? The problem I see - you have
> a process that opened the /proc/.netns/X directory (he onws that namespace)
> and the other one trying to do the same. The VFS layer finds the hashed
> dentry corresponding to this /proc/.netns/X. The only way you can prevent
> VFS from giving one to the second task is to override .d_revalidate method 
> and drop that dentry....
>
> But we've already tried to walk this way with no luck.

I meant a per mount filtering.  Exactly like we do for the pids now.

>> It looks like we have to tweak things just a bit so that free_pid
>> would not be called until the pid namespace goes away.  Something
>> similar to how we do the hash chains.
>
> This is not about pid namespace, this is about net namespace and
> tuning pids management to facilitate networking needs is not the right
> thing to do.

Not exactly.  It is about process attribute visibility.  Which
is what proc is about.  In plan9 where the concept comes from
namespaces are referred to as process groups, and that is a valid
view.  At least from a monitoring perspective.

>> If we make namespaces show up anywhere besides under
>> "/proc/<pid>/task/<tid>/" we have to do something like this, and pids
>> are largely designed for this kind of use.
>
> Proc consists of two parts - the <pid>-s one with generated-on-the-fly
> entries and the static one that is represented by proc_dir_entry tree.
> Do you propose to mix those two?

Yes.  Because the static entries are beginning to depend on process
specific attributes.  We have already started with /proc/mounts.

>> just need a non-global id for our directory entries so we don't paint
>> ourselves into a corner.
>
> What namespace do you mean by "non-global"?

The best is an id I can take with me when I migrate from machine A
to machine B.  An id in some namespace or a form that doesn't need
an id at all is the core requirement.

Eric
