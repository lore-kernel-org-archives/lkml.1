Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbXITNjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbXITNjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXITNi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:38:59 -0400
Received: from mx2.netapp.com ([216.240.18.37]:3296 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXITNi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:38:58 -0400
X-IronPort-AV: E=Sophos;i="4.20,278,1186383600"; 
   d="scan'208";a="106043013"
Subject: Re: [PATCH 3/3] CRED: Move the effective capabilities into the
	cred struct
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <46F1F2EE.1010904@kernel.org>
References: <20070919161749.8334.26064.stgit@warthog.procyon.org.uk>
	 <20070919161805.8334.96808.stgit@warthog.procyon.org.uk>
	 <46F1F2EE.1010904@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 20 Sep 2007 09:38:55 -0400
Message-Id: <1190295535.6763.29.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 20 Sep 2007 13:38:56.0089 (UTC) FILETIME=[974EAC90:01C7FB8B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 21:11 -0700, Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> David Howells wrote:
> > Move the effective capabilities mask from the task struct into the credentials
> > record.
> > 
> > Note that the effective capabilities mask in the cred struct shadows that in
> > the task_struct because a thread can have its capabilities masks changed by
> > another thread.  The shadowing is performed by update_current_cred() which is
> > invoked on entry to any system call that might need it.
> 
> OOC If we were to simply drop support for one process changing the
> capabilities of another, would we need this patch?

No. This has nothing to do about one process changing some other
process' capabilities. It has to do with being able to pass security
information around the kernel beyond the confines of the task struct.

This is needed in order to deal with asynchronous i/o where security
checks may have to be deferred, and where the task struct may no longer
be available.
One example would be a failover situation when doing deferred writes: if
the first choice of storage medium is unavailable, and the kernel tries
to fail the write over to another storage. On NFS that might involve
having to build up a new RPCSEC_GSS security context for the new server.
Currently, you cannot do this safely because all the security info is
cached in the task struct and much of it cannot be copied.

Trond
