Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZBJVg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZBJVg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZBJVgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:36:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342AbZBJVgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:36:18 -0500
Date: Tue, 10 Feb 2009 13:35:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-kernel@vger.kernel.org, jnelson-kernel-bugzilla@jamponi.net,
       Pavel Machek <pavel@ucw.cz>, stable@kernel.org
Subject: Re: [PATCH 1/1] NBD: fix I/O hang on disconnected nbds
Message-Id: <20090210133537.23b1779a.akpm@linux-foundation.org>
In-Reply-To: <4990743F.1070409@steeleye.com>
References: <4990743F.1070409@steeleye.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Feb 2009 13:21:51 -0500
Paul Clements <paul.clements@steeleye.com> wrote:

> This patch fixes a problem that causes I/O to a disconnected
> (or partially initialized) nbd device to hang indefinitely. To reproduce:
> 
> # ioctl NBD_SET_SIZE_BLOCKS /dev/nbd23 514048
> # dd if=/dev/nbd23 of=/dev/null bs=4096 count=1
> 
> ...hangs...
> 
> This can also occur when an nbd device loses its nbd-client/server
> connection. Although we clear the queue of any outstanding I/Os after 
> the client/server connection fails, any additional I/Os that get queued 
> later will hang.
> 
> This bug may also be the problem reported in this bug report:
> http://bugzilla.kernel.org/show_bug.cgi?id=12277
> 
> Testing would need to be performed to determine if the two issues are 
> the same.
> 
> This problem was introduced by the new request handling thread code
> ("NBD: allow nbd to be used locally", 3/2008), which entered into 
> mainline around 2.6.25.

Seems that the patch applies to 2.6.26, but not to 2.6.25.

> 
> The fix, which is fairly simple, is to restore the check for lo->sock
> being NULL in do_nbd_request. This causes I/O to an uninitialized nbd to
> immediately fail with an I/O error, as it did prior to the introduction 
> of this bug.

I marked this as needing backporting into 2.6.26.x, 2.6.27.x and
2.6.28.x.  OK?

