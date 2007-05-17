Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbXEQMbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbXEQMbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXEQMb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:31:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbXEQMb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:31:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <464BF8B2.3080101@yahoo.com.au>
References: <464BF8B2.3080101@yahoo.com.au> <464B3F2D.9030603@yahoo.com.au> <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com> <23262.1179334587@redhat.com> <31162.1179341123@redhat.com> 
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 17 May 2007 13:30:01 +0100
Message-ID: <6333.1179405001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> No, you shouldn't. We could theoretically introduce a new API for this,
> but I think it would be preferable if you can fix the race in the fs.

Actually, I might be able to do better.

When making a StoreData call to the AFS server, I send all the parameters
first, and at that point, the server will abort it, I think, if permission is
not available, and won't wait for the payload to be delivered.

So if I tell AF_RXRPC to send the parameter data with an explicit ACK request
and then wait till it's either hard-ACK'd or aborted, I should then be able to
deal with the permissions failure at a state where I have locked *all* the
pages to be sent.

At that point, I should be able to tell truncate to simple discard all these
locked pages.

How's that sound?

David
