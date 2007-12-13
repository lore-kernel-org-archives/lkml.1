Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbXLMQZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbXLMQZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbXLMQZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:25:31 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:44473 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972AbXLMQZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:25:30 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: casey@schaufler-ca.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <21666.1197560219@redhat.com>
References: <1197557384.20226.21.camel@moss-spartans.epoch.ncsc.mil>
	 <1197488021.1125.138.camel@moss-spartans.epoch.ncsc.mil>
	 <1197473127.1125.50.camel@moss-spartans.epoch.ncsc.mil>
	 <81862.27432.qm@web36605.mail.mud.yahoo.com> <32168.1197484170@redhat.com>
	 <668.1197499783@redhat.com>  <21666.1197560219@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 13 Dec 2007 11:23:53 -0500
Message-Id: <1197563033.20226.110.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 15:36 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > It is just a way of carving up the permission space, typically based on
> > object type, but it can essentially be arbitrary.  The check in this
> > case seems specific to cachefiles since it is controlling an operation
> > on the /dev/cachefiles interface that only applies to cachefiles
> > internal operations, so making a cachefiles class seems reasonable.
> 
> Can you specify what sort of permissions you're thinking of providing for
> tasks to operate on this class?

They would correspond with the operations provided by
the /dev/cachefiles interface, at the granularity you want to support
distinctions to be made.  Could just be a single 'setcontext' permission
if that is all you want to control distinctly, or could be a permission
per operation.

>   Can an object of this class 'operate' on
> other objects, or can only process-class objects do that?

In this case, I wouldn't expect a cachefiles object to act on anything
else.  Some objects are also used as subjects, especially in the
networking arena.

> How does an object of this class acquire a label?  What is an object of this
> class?  Is it a "cache"?  Or were you thinking of a "module"?

I was thinking the latter since the only goal was to control what
contexts could be set by a given task, but you could support per-cache
"objects" with their own labels (in which case the label would likely be
determined from the creating task).

If the latter, you don't really need a label for the object, and can
just use the supplied context/secid as the object of the permission
check, ala:
	rc = avc_has_perm(tsec->sid, secid, SECCLASS_CACHEFILES,
CACHEFILES__SETCONTEXT);

If the former, then you'd need more than one check, as you then have to
check whether the task can act on the cache in question, and then check
whether it can set the context for that cache to the specified value.

-- 
Stephen Smalley
National Security Agency

