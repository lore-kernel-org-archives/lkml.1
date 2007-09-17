Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbXIQK5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbXIQK5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 06:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXIQK5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 06:57:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbXIQK5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 06:57:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070914165938.9a429e02.akpm@linux-foundation.org>
References: <20070914165938.9a429e02.akpm@linux-foundation.org> <20070912142508.19311.45995.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, kwc@citi.umich.edu,
       Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org,
       smfrench@gmail.com, nfsv4@linux-nfs.org
Subject: Re: [PATCH] KEYS: Make request_key() and co fundamentally asynchronous
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 17 Sep 2007 11:56:00 +0100
Message-ID: <16559.1190026560@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> So who's going to review this?  Nobody?  Well gee, maybe it was my turn
> anyway.

Well, Kevin Coffman has reviewed it and tested it against his NFS keys patches.

> checkpatch generates a pile of warnings, all of which afacit are legit.

For this warning:

ERROR: need space after that ',' (ctx:WxV)
#627: FILE: security/keys/internal.h:28:
+#define kenter(FMT, ...) no_printk("==> %s("FMT")\n",__FUNCTION__ ,##__VA_ARGS__)

                                                                   ^

This is with good reason.  Some versions of cpp get the ## resolution "wrong"
if __VA_ARGS__ is empty (ie: there are no arguments to the macro that
correspond to the "...").  This can be worked around by abutting the "," the
"##" and the "__VA_ARGS__" with no spaces, and inserting a space before the
comma.

If I remember correctly, the comma won't be removed if it doesn't abut the
##__VA_ARGS__, and the comma and everthing that abuts it on its LHS can be
removed if there's also no space.  Without the "##", the comma isn't removed.

Consider the result of doing x("a"); where x(y, ...) is #defined to each of the
folowing:

	DEFINITION			RESULT
	===============================	=======================
	printk(y, __VA_ARGS__)		print(y, );
	printk(y ,__VA_ARGS__)		print(y ,);
	printk(y,##__VA_ARGS__)		print();
	printk(y, ##__VA_ARGS__)	print(y, );
	printk(y ,##__VA_ARGS__)	print(y );

> It'd be nice to add a comment explaining to the long-suffering reader why
> down_write_nested() is used here.

I'll change the comment to:

	/* make sure no one's trying to change or use the key when we mark it
	 * - we tell lockdep that we might nest because we might be revoking an
	 *   authorisation key whilst holding the sem on a key we've just
	 *   instantiated
	 */

> You could actually use kstrdup() here, I think.

I could, but that potentially wastes time in two ways: firstly, there can be an
error before we've finished setting up, and that can lead to us having wasted
the time spent making the copy; and secondly, the call to kstrdup itself wastes
a bit of time because of the extra call made.

On the other hand, the code might end up a bit shorter, and isn't particularly
fast path anyway.

> rka->callout_info gets leaked later on (goto auth_key_revoked)

Fixed.

> Apart from that the changes look reasonable to me, but I am not a suitable
> reviewer for keys, NFS or rxrpc stuff.  Who is??

Kevin Coffman and Trond for the NFS stuff, both of whom are CC'd.

David
