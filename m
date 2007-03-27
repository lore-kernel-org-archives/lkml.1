Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXC0UsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXC0UsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXC0Urz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:47:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42513 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbXC0Uri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:47:38 -0400
Date: Tue, 27 Mar 2007 13:47:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux@horizon.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070327134700.f17e8b61.akpm@linux-foundation.org>
In-Reply-To: <20070327200933.6321.qmail@science.horizon.com>
References: <20070327123422.d0bbc064.akpm@linux-foundation.org>
	<20070327200933.6321.qmail@science.horizon.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Mar 2007 16:09:33 -0400
linux@horizon.com wrote:

> What part of "The msync() function writes all modified data to
> permanent storage locations [...] For mappings to files, the msync()
> function ensures that all write operations are completed as defined
> for synchronised I/O data integrity completion." suggests that it's not
> supposed to do disk I/O?  How is that uselessly vague?
> 

Because for MS_ASYNC, "msync() shall return immediately once all the write
operations are initiated or queued for servicing".

ie: the writes can complete one millisecond or one week later.  We chose 30
seconds.

And this is not completely fatuous - before 2.6.17, MAP_SHARED pages could
float about in memory in a dirty state for arbitrarily long periods -
potentially for the entire application lifetime.  It was quite reasonable
for our MS_ASYNC implementation to do what it did: tell the VM about the
dirtiness of these pages so they get written back soon.

Post-2.6.17 we preserved that behaviour.
