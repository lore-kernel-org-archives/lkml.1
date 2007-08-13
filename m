Return-Path: <linux-kernel-owner+w=401wt.eu-S1031923AbXHMQg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031923AbXHMQg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966349AbXHMPm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:42:28 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:30881 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965910AbXHMPmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:42:25 -0400
X-YMail-OSG: PjrwWR8VM1mg2ECgpCyMcmK1wgaAt8ITxI6OJoWtAHzhr3XxXvWxSKn9fOVfasiUso2H9I9vrQ--
X-RocketYMMF: rancidfat
Date: Mon, 13 Aug 2007 08:42:23 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
To: Stephen Smalley <sds@tycho.nsa.gov>, David Howells <dhowells@redhat.com>
Cc: casey@schaufler-ca.com, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1187017052.26008.51.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <98087.46480.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Mon, 2007-08-13 at 15:51 +0100, David Howells wrote:

> ... 

> > Actually, to address Stephen Smalley's requirements also, how about making
> > things a bit more complex.  Have the following suite of functions:
> > 
> >  (1) int security_get_context(struct sec **_context);
> > 
> > 	This allocates and gives the caller a blob that describes the current
> > 	context of all the LSM module states attached to the current task and
> > 	stores a pointer to it in *_context.
> > 
> >  (2) int security_push(struct sec *context, struct sec **_old_context)
> > 
> > 	This causes all the LSM modules on the current task to switch to a new
> > 	acting state, passing back the old state.  It does not change how
> > 	other tasks do things to this one.
> > 
> >  (3) int security_pop(struct sec *context)
> > 
> > 	This causes all the LSM modules on the current task to switch to a new
> > 	acting state, deleting the old state.  It does not change how
> > 	other tasks do things to this one.
> > 
> >  (4) int security_delete_context(struct sec *context)
> > 
> > 	This deletes a context blob.
> > 
> > The context blob could then be structured very simply.  Give each loaded
> LSM
> > module an integer index as it is registered.  Having a limit to the number
> of
> > LSM modules would make things simpler.  The blob would then be an array of
> > void pointers, one per LSM module, indexed by the integer index for each
> one.
> > It you don't have a limit on the number of LSM modules, you'd also need a
> > count of slots in the blob.
> > 
> > Any LSM module that wanted to implement the above three functions would
> fill
> > in or otherwise use the slot that belongs to it.  Otherwise the slot would
> > just be left NULL.
> > 
> > For example:
> > 
> > 	context --->+--------+                                    +---------+
> > 	            | SLOT 0 |----------------------------------->| SELINUX |
> > 	            +--------+                      +--------+    +---------+
> > 	            | SLOT 1 |--------------------->| THINGY |
> > 	            +--------+                      +--------+
> > 	            | ...    |
> > 	            +--------+         +-------+
> > 	            | SLOT N |-------->| AUDIT |
> > 	            +--------+         +-------+
> > 
> > For Stephen and NFS, he could then generate a context from NFS which nfsd
> > could then put in place.  Perhaps any unfilled slot would be ignored by the
> > LSM module to which it belonged.
> 
> Seems like over-design - we don't need to support LSM stacking, and we
> don't need to support pushing/popping more than one level of context.

LSM stacking has always been contentious and I don't see
that it addresses the issue, which is changing the data used
by an LSM, not the LSM itself.

> What was the objection again to the original interface, aside from
> replacing "u32 secids" with "void* security blobs"?

The objection centers around exposing LSM specific data outside
the LSM, and it applies to either secids or blobs, really. If you
need this information outside the LSM odds are good that what you're
using it for is going to be LSM specific, and hence should be inside
the LSM. I admit to two gray areas, audit and system service tasks
such as the two cited here. I like simplicity and find the single
security_act_as() interface attractive for the latter case.


Casey Schaufler
casey@schaufler-ca.com
