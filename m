Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZGNRrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZGNRrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZGNRrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:47:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37077 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZGNRrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:47:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1247161851.5766.44.camel@heimdal.trondhjem.org>
References: <1247161851.5766.44.camel@heimdal.trondhjem.org> <1552.1247160463@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, steved@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] NFS: Propagate 'fsc' mount option through automounts
Date: Tue, 14 Jul 2009 18:47:34 +0100
Message-ID: <6404.1247593654@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> Why not just use the mount path as the default uniquifier?

Because:

 (1) Which mount path?  You're now constructing the mount tree in its own
     private namespace.

 (2) Due to the new VFS-pathwalk-based mount, the uniquifier is applied to the
     root mount only, and if modified to inherit, would be applied to every
     automount subordinate to that, rather than just the actual subject of the
     mount.

 (3) Due to the new VFS-pathwalk-based mount and the private namespace, the
     default uniquifier for all instances of any particular mount is always
     the same.

 (4) If we work around some how the mounts now getting their mount path from
     the private namespace, there are still real namespaces, chroots and
     root-pivots to contend with.

> > +	target->options = source->options;
> 
> BTW: Why does fscache require a private flag field?

I thought it best to avoid touching nfs_server::flags as that is at least
partially visible to userspace.

> > +	struct nfs_parsed_mount_data parsed_data = { .fscache_uniq = NULL, };
> 
> Rather than wasting all this space on the stack, how about just changing
> the second argument of nfs_fscache_get_super_cookie()? You only use the
> pointer to data->fscache_uniq.

Yeah, that's probably wise.

Actually, I don't really want to get this data via mount at all (as there are
automounts to locally configure for caching).

David
