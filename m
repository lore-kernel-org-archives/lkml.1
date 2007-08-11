Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbXHKP5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbXHKP5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 11:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXHKP47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 11:56:59 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:36180 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751433AbXHKP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 11:56:57 -0400
X-YMail-OSG: Rp90Rj4VM1lbKJ70o_da8vB_NiZv.QUhp2IaARGn33qLYK8.cUOfHRwZQXlftt9iaD5WRAYfrw--
X-RocketYMMF: rancidfat
Date: Sat, 11 Aug 2007 08:56:56 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <7504.1186821682@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <444368.22491.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > How would you expect an LSM that is not SELinux to interface with
> > CacheFiles?
> 
> You have to understand that I didn't know that much about the LSM interface,
> so I asked advice of the Red Hat security people, who, naturally, pointed me
> at the SELinux mailing list.  I knew my stuff would have to work with SELinux
> to be used with RH stuff.

Sigh. So it's not only SELinux specific, but RedHat specific as well.

> Furthermore, as you pointed out, there aren't any other LSM modules upstream
> yet for me to work against.  I would like CacheFiles to work with all LSM
> modules in general, but I don't know how to do that yet.

While neither is upstream you can certainly look at AppArmor and Smack,
both of which have nefarious plans for getting upstream.

> I'm open to suggestion as to how to modify things to support any LSM.

It's been a long time since I dealt with file system cacheing, and
that was under Unix, and I don't claim to have a working understanding
of the internals of CacheFiles, but ...

> Btw, do you understand the problems that CacheFiles has to deal with?  If I
> set this down clearly, this may help you or someone else suggest a better way
> to do things.
> 
>   (1) Some random process tries to access a file on a network filesystem
>       (NFS example).
> 
>   (2) NFS goes to the cache to attempt to read the data from there prior to
>       going to the network.
> 
>   (3) The cache driver wants to access the files in the cache, but it's
>       running in the security context of either the aforementioned random
>       process, or one of FS-Cache's thread pool.

I think that this is the point you should attack. Control the security
characteristics of the cache driver properly and you shouldn't need the
complexity that you're asking to introduce.
 
>       This security context, however, doesn't necessarily give it the rights
>       to access what's in the cache, so the driver has to be permitted to act
>       as a context appropriate to accessing the cache, without changing the
>       overall security context of the random process (which would impact
>       things trying to act on that process - kill() for example).

Can you run the cache as an independent thread and send it messages
rather than trying to do things in the context of the calling process?
I know that that involves extra bookkeeppingg, but it's lots safer.

>   (4) Assuming the data is found in the cache, all well and good, but if it
>       isn't, the cache driver will have to create some files in the cache.
> 
>       Now, if the cache driver just went ahead and created the files, they
>       could end up with their own security contexts being derived from the
>       random process's security context, thus potentially making it
> impossible
>       for other processes to access the cache.

Yes, and the SELinux semantics for what label to give a file don't
help much, either. The problem with the "act_as" interfaces is that
I wouldn't expect them to be any more reliable than the old access()
system call, which never really gave you a helpful answer.
 
>       So the file-creation part of the security context must also be
>       overridden temporarily, assuming that whatever LSM is in force has such
>       a concept.

Ideally you want to be running in the right context to create the
new file so that no one can use it and then label it "correctly"
and make it available.

> Part of the problem is that the VFS does not pass around the security context
> as which the VFS routines act, but rather gets them from the task_struct. 

That's by design. 

> For
> the most part, this is entirely sufficient, but in the cache driver case,
> it's
> a problem.

The cache driver is a unique case with an unusual function. It's pretty
obvious that the kernel architecture, the VFS architecture, LSM, SELinux,
NFS and pretty much everyone else has given no thought whatever to the
implications of their designs on file system cacheing. For all concerned,
I'll say "sorry 'bout that".

Casey Schaufler
casey@schaufler-ca.com
