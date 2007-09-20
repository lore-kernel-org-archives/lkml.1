Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXITQbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXITQbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbXITQbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:31:34 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:31403 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756309AbXITQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:31:32 -0400
X-YMail-OSG: OXjGczUVM1loF081iFgAOk4dtjnJB6m16exzCbhF
X-RocketYMMF: rancidfat
Date: Thu, 20 Sep 2007 09:31:31 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part of it into struct cred
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <6741.1190242636@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <956034.72880.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > > Move into the cred struct the part of the task security data that defines
> > > how a task acts upon an object.  The part that defines how something acts
> > > upon a task remains attached to the task.
> > 
> > This seems to me to be an unnatural and inappropriate separation.  Move the
> > whole of the security blob into the cred if you must have a cred (which I
> > was soooo glad Linux didn't have after having dealt with it in Solaris)
> > rather than having two blobs to deal with. 

Could you use "object context" instead of "victimisation context"?
It would be in better keeping with traditional security jargon.

> The separation is necessary for a few reasons:
> 
>  (1) The task victimisation context must *not* be changed by a temporary
>      override of the action and creation contexts for purposes such as
>      cachefiles.

That would be for the LSM to decide, not the file system. While I
concede that it is unlikely that you are going to want to use the
same security attributes for your "object" and your "subject" I also
suggest that it is probable that the "object" attributes will want to
change in the case of an filesystem daemon as well, and that the
filesystem code by itself can't know what's correct.

>  (2) If the victimisation context is not included in the override cred, then
> I
>      only need one copy of the override cred to do *all* the work for
>      cachefiles.  I can share that singular override blob across every task
>      that wishes to access the cache.

Assuming that the LSM goes along with the notion you could do that
with a task struct, too.

>  (3) If the victimisation context is moved to the override cred, I have to
>      create a new context every time I want to apply the override.  This
> means
>      I have to deal with the possibility of OOM at such points.  I could
> cache
>      the contexts, but that's messy - and unnecessary.

You're making a big mess (that's my opinion, take it for what it's worth)
throughout the LSMs to deal with a single (or maybe a very few) special
case.

> > If an LSM requires a different treatment between when a task is a subject
> and
> > when it is an object the LSM should handle that itself.
> 
> Indeed, but I can help it to do so by providing separate security pointers on
> the task struct and the cred struct.
> 
> > So put all these fields into one blob and attach them to the cred.
> 
> The separation is, I think, the correct thing to do.
> 
> > Actually, if you put all these fields in the task blob maybe you
> > don't need to do your COW thing at all.
> 
> Whilst that is true,

Glad I figured it out.

> one of the purposes of this is to make it easier and
> cleaner to effect the override.  Every field in the cred struct potentially
> must be overridden.  That's a lot of context to save each time I need to
> apply
> the override and a lot of context to restore each time I want to restore it.

So it sounds like what you'd be happiest with would be a separate task
struct hand crafted to he the right "object" and "subject" attributes.
Couldn't you set up a task to do the overridden operations? Yes, it
would have it's own set of ugly, but it would be isolated. I haven't
been through the code of late, but this used to be what nfsd did, that
being nothing except loaning it's attributes (ok, it was a cred) to
whoever needed them.

> With these patches, all I need to do is to take a ref and swap the cred
> pointers with a memory barrier to satisfy the RCU, and then swap them back
> again and release the ref.  It's much, much simpler.

Yes, but the LSM writer now has to maintain two full security blobs
even if the system doesn't want cachefs or nfs.

> Furthermore, with respect to LSM and SELinux, I think I can remove the
> SELinux
> specific knowledge currently present in cachefiles by saying to LSM "give me
> a
> cred for kernel service X".  With SELinux this can do all the transformations
> necessary to give me the appropriate action SID and file creation SID without
> me needing to know that these concepts exist.  I just apply the cred I'm
> given
> as an override.

You could have done the same thing passing the task instead of a cred.

> With your suggestion, I either have to do a full set of transformations each
> time I want to apply the override, or I have to know about SELinux or
> whatever's internals.  Your objection to my earlier patch was this very
> point.

Yup. And I'm reluctantly withdrawing my objection to exporting secid's
across the LSM interface. I didn't like 'em when I saw 'em in 1988 in
the SecureWare CMW, and I don't like 'em any better now, but I had three
tries at extracting them from use outside the SELinux specific code and
it's clear that there's no way to do it without being Linus. For Smack
I have restructured a couple lists and can deal with secid's now.

I don't see any way to get around the LSM being involved, even with
secid's. Only the LSM can decide what is appropriate for an override
value. Maybe all you need is

    int security_task_godlikesecid(u32 *secid)

which gives you the fully protected, all powerfull secid. That doesn't
handle capabilities, of course, but It appears you know how to deal with
those already.

I appologize that I can't offer a complete alternative at this point,
but I do have other fish on the barbie right now. Thank you for your
attention to my concerns.




Casey Schaufler
casey@schaufler-ca.com
