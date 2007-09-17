Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXIQLCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXIQLCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXIQLCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:02:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbXIQLC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:02:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a36005b50709150851s52d04554t62d53dab3f47eaf8@mail.gmail.com>
References: <a36005b50709150851s52d04554t62d53dab3f47eaf8@mail.gmail.com> <1577.1189713412@redhat.com>
To: "Ulrich Drepper" <drepper@gmail.com>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: Credentials test patch
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 17 Sep 2007 12:02:12 +0100
Message-ID: <19877.1190026932@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper <drepper@gmail.com> wrote:

> In sys_faccessat you temporarily allocate a cred object which is
> discarded in the end.  With a few more macro definitions you could
> create a dup_cred variant which initialized an automatic variable of
> type struct cred.  This way the kmalloc/kfree pair would fall away.

No, you can't.  The filesystems sys_faccessat() then invokes are entitled to
take a reference to it - the SunRPC authentication stuff, for example - so you
can't just preemptively unallocate it as would occur with an automatic variable.

> access is actually used frequently.  For instance, ld.so uses it on
> every startup as a quicker possibility to check for a file which
> usually doesn't exist.  So, speeding up access has some small effect
> on performance.  The resulting code might actually reduce the kernel
> size a bit due to all the checks and calls which go away.

A better way would be to compare fsuid/fsgid to uid/gid and to just take an
extra ref on the incumbent cred object if they're the same, rather than always
allocating a new one.  That, I suspect, would speed up 99.99% of the cases.

David
