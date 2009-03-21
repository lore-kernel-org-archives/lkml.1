Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZCUJxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZCUJxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZCUJww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:52:52 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45154 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbZCUJwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:52:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18884.47341.106849.379374@cargo.ozlabs.ibm.com>
Date: Sat, 21 Mar 2009 20:52:45 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perfcounters: fix type/event_id layout on big-endian
	systems
In-Reply-To: <20090321094246.GA5594@elte.hu>
References: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
	<20090321094246.GA5594@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> hm, this ifdef really looks ugly. How about just changing event_id 
> to 64 bits and having a separate u32 type field? The size impact is 
> minimal, the cleanliness win is significant :-)

We wanted to get a complete and unique identifier for the event into
64 bits so that we could put it into the ring buffer for
PERF_RECORD_GROUP and have it take up only one 8-byte slot and yet
identify uniquely which counter's value follows it.  I don't know that
that is absolutely necessary but it sounds like a nice property.

We could easily go back to a 1-bit raw field and have the type be
either a 64-bit raw value or an 8-bit type plus 32 or 56-bit
event_id.

Or we could keep the current layout but use explicit shifts and masks
rather than bitfields.

I don't know the current C rules concerning unions very well, but I
have the impression that writing to one member of a union and reading
another is undefined behaviour, which is another strike against the
current code if true...

Anyway, the point is that the current code doesn't compile on powerpc
and wouldn't work properly even if it did, so we need to do something.

Paul.
