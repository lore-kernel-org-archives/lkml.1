Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbXISW6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbXISW6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbXISW5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:57:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbXISW5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:57:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <843863.97817.qm@web36611.mail.mud.yahoo.com>
References: <843863.97817.qm@web36611.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part of it into struct cred
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 19 Sep 2007 23:57:16 +0100
Message-ID: <6741.1190242636@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> > Move into the cred struct the part of the task security data that defines
> > how a task acts upon an object.  The part that defines how something acts
> > upon a task remains attached to the task.
> 
> This seems to me to be an unnatural and inappropriate separation.  Move the
> whole of the security blob into the cred if you must have a cred (which I
> was soooo glad Linux didn't have after having dealt with it in Solaris)
> rather than having two blobs to deal with.

The separation is necessary for a few reasons:

 (1) The task victimisation context must *not* be changed by a temporary
     override of the action and creation contexts for purposes such as
     cachefiles.

 (2) If the victimisation context is not included in the override cred, then I
     only need one copy of the override cred to do *all* the work for
     cachefiles.  I can share that singular override blob across every task
     that wishes to access the cache.

 (3) If the victimisation context is moved to the override cred, I have to
     create a new context every time I want to apply the override.  This means
     I have to deal with the possibility of OOM at such points.  I could cache
     the contexts, but that's messy - and unnecessary.

> If an LSM requires a different treatment between when a task is a subject and
> when it is an object the LSM should handle that itself.

Indeed, but I can help it to do so by providing separate security pointers on
the task struct and the cred struct.

> So put all these fields into one blob and attach them to the cred.

The separation is, I think, the correct thing to do.

> Actually, if you put all these fields in the task blob maybe you
> don't need to do your COW thing at all.

Whilst that is true, one of the purposes of this is to make it easier and
cleaner to effect the override.  Every field in the cred struct potentially
must be overridden.  That's a lot of context to save each time I need to apply
the override and a lot of context to restore each time I want to restore it.

With these patches, all I need to do is to take a ref and swap the cred
pointers with a memory barrier to satisfy the RCU, and then swap them back
again and release the ref.  It's much, much simpler.

Furthermore, with respect to LSM and SELinux, I think I can remove the SELinux
specific knowledge currently present in cachefiles by saying to LSM "give me a
cred for kernel service X".  With SELinux this can do all the transformations
necessary to give me the appropriate action SID and file creation SID without
me needing to know that these concepts exist.  I just apply the cred I'm given
as an override.

With your suggestion, I either have to do a full set of transformations each
time I want to apply the override, or I have to know about SELinux or
whatever's internals.  Your objection to my earlier patch was this very point.

David
