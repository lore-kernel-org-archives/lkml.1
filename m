Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYBAWbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYBAWbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbYBAWav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:30:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721AbYBAWau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:30:50 -0500
Message-ID: <47A39D8F.9010003@redhat.com>
Date: Fri, 01 Feb 2008 17:30:39 -0500
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071018)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] enhanced syscall ESTALE error handling (v2)
References: <4790C768.4080207@redhat.com> <47A387D4.70605@redhat.com> <E1JL3a0-0006H7-U3@pomaz-ex.szeredi.hu> <47A39471.4010105@redhat.com> <E1JL3yn-0006KQ-AS@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JL3yn-0006KQ-AS@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>>> This doesn't apply to -mm, because the ro-mounts stuff touches a lot
>>> of the same places as this patch.  You probably need to rebase this on
>>> top of those changes.
>>>
>>>   
>>>       
>>>> This patch adds handling for the error, ESTALE, to the system
>>>> calls which take pathnames as arguments.  The algorithm used
>>>> is to detect that an ESTALE error has occurred during an
>>>> operation subsequent to the lookup process and then to unwind
>>>> appropriately and then to perform the lookup process again.
>>>> Eventually, either the lookup process will return an error
>>>> or a valid dentry/inode combination and then operation can
>>>> succeed or fail based on its own merits.
>>>>     
>>>>         
>>> If a broken NFS server or FUSE filesysem keeps returning ESTALE, this
>>> goes into an infinite loop.  How are we planning to deal with that?
>>>
>>>   
>>>       
>> Would you describe the situation that would cause the kernel to
>> go into an infinite loop, please?
>>     
>
> The patch basically does:
>
> 	do {
> 		...
> 		error = inode->i_op->foo()
> 		...
> 	} while (error == ESTALE);
>
> What is the guarantee, that ->foo() will not always return ESTALE?

You skimmed over some stuff, like the pathname lookup component
contained in the first set of dots...

I can't guarantee that ->foo() won't always return ESTALE.

That said, the loop is not unbreakable.  At least for NFS, a signal
to the process will interrupt the loop because the error returned
will change from ESTALE to EINTR.

These changes include the base assumption that the components of
the underlying file system are basically reliable, that there is
a way to deal with bugs and/or malicious entities in the short
term, and that these things will be dealt with appropriately
in the longer term.

The short term resolution is a signal.  The longer term fix is
to hunt down the bug or the malicious entity and either make it
go away or fence it off via some security measure or another to
prevent it from causing another problem.

If the underlying file system is the type that could potentially
return ESTALE, then it needs to be aware of the system architecture
and handle things appropriately.

    Thanx...

       ps
