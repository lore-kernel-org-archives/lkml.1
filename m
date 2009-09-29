Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZI2QYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZI2QYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZI2QYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:24:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919AbZI2QYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:24:24 -0400
Date: Tue, 29 Sep 2009 09:23:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not
 used
In-Reply-To: <395.1254239745@redhat.com>
Message-ID: <alpine.LFD.2.01.0909290909280.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909280743310.3349@localhost.localdomain> <20090928135332.4300.56046.stgit@warthog.procyon.org.uk> <20090928151628.62955233@lxorguk.ukuu.org.uk> <395.1254239745@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Sep 2009, David Howells wrote:
> 
> Is it right to use pty_ops_bsd in _both_ places?  Looking at the code in
> linux-2.6.0, the BSD ioctl only applies to the master and doesn't apply to the
> slave.

Right you are, good catch.

That said, I have to say that this whole pty lock thing seems to have been 
broken since 2.6.26, and even now, nobody actually _complained_. You found 
the problem due to a compiler warning rather than due to somebody noticing 
that pty_bsd_ioctl() is no longer hooked up.

Because as far as I can tell, the bug was introduced by commit 
3e8e88ca053150efdbecb45d8f481cf560ec808d ("pty: prepare for tty->ops 
changes") back in April of 2008. That added the whole 'pty_ops_bsd' 
structure, but it has never actually been used.

So I do wonder whether the right thing to do would not be to simple remove 
the whole pty_ops_bsd code entirely. Or maybe mode the trivial TIOCSPTLCK 
into the generic tty ioctl handling, and just make it test for 
"driver->subtype == PTY_TYPE_MASTER" - and at least get rid of this subtle 
thing that was broken for over a year without anybody noticing..

		Linus
