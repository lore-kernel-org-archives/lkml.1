Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXIZSJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXIZSJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbXIZSJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:09:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45800 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbXIZSJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:09:07 -0400
Date: Wed, 26 Sep 2007 19:08:58 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, Trond.Myklebust@netapp.com, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 01/24] CRED: Introduce a COW credentials record
Message-ID: <20070926180858.GP8181@ftp.linux.org.uk>
References: <20070926142059.2656.27100.stgit@warthog.procyon.org.uk> <20070926142104.2656.26389.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926142104.2656.26389.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 03:21:05PM +0100, David Howells wrote:
> To alter the credentials record, a copy must be made.  This copy may then be
> altered and then the pointer in the task_struct redirected to it.  From that
> point on the new record should be considered immutable.

Umm...  Perhaps a better primitive would be "make sure that our cred is
not shared with anybody, creating a copy and redirecting reference to
it if needed".

 
> In addition, the default setting of i_uid and i_gid to fsuid and fsgid has been
> moved from the callers of new_inode() into new_inode() itself.

I don't think it's safe; better do something trivial like
	own_inode(inode)
that would set these (and that's a goot splitup candidate, to go in front
of the series).


FWIW, the main weakness here is the need of update_current_cred()
splattered all over the entry points.  Two problems:
	a) it's a bug source (somebody adds a syscall and forgets to
add that call / somebody modifies syscall guts and doesn't notice that
it needs to be added).
	b) it's almost always doing noting, so being lazier would be
better (event numbers checked in the inlined part, perhaps?)


The former would be more robust if it had been closer to the places where
we get to passing current->cred to functions.  The latter...  When do
we actually step into this kind of situation (somebody changing keys on
us) and what's the right semantics here?  E.g. if it happens in the middle
of long read(), do we want to keep using the original keys?

Comments?
