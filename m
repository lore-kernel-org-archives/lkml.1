Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbZHDUbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbZHDUbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbZHDUbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:31:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58629 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbZHDUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:31:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090804184334.GC8442@us.ibm.com>
References: <20090804184334.GC8442@us.ibm.com> <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145546.17676.98776.stgit@warthog.procyon.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] KEYS: Add garbage collection for dead, revoked and expired keys.
Date: Tue, 04 Aug 2009 21:30:27 +0100
Message-ID: <5007.1249417827@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> These two lines (repeated below) beg for a helper?

Yeah...  Seems reasonable.

> Can this happen?  This implies that the number of live keys
> went up, but we're under keyring->sem?

An expired key can be updated back to life:

	[root@andromeda ~]# keyctl  add user a a @s
	619170185
	[root@andromeda ~]# keyctl timeout 619170185 5
	[root@andromeda ~]# keyctl  show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	627083299 --alswrv      0    -1   \_ keyring: _uid.0
	619170185 --alswrv      0     0   \_ user: a
	[root@andromeda ~]# keyctl  show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	627083299 --alswrv      0    -1   \_ keyring: _uid.0
	619170185: key inaccessible (Key has expired)
	[root@andromeda ~]# keyctl  add user a a @s
	619170185
	[root@andromeda ~]# keyctl  show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	627083299 --alswrv      0    -1   \_ keyring: _uid.0
	619170185 --alswrv      0     0   \_ user: a

> > +		.data = &key_gc_delay,
> 
> I see where this variable is defined at top of the patch, but
> I don't see where it is actually used?

Bah!  I forgot to add gc.c to the mix.  Sorry about that.

David
