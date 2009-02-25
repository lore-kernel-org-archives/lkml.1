Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbZBYJHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbZBYJHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZBYJH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:07:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:35887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbZBYJH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:07:27 -0500
Subject: Re: [PATCH] drm: Fix lock order reversal between mmap_sem and
 struct_mutex.
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Anholt <eric@anholt.net>
Cc: Thomas Hellstrom <thomas@shipmail.org>,
       Wang Chen <wangchen@cn.fujitsu.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1235549745.5213.4.camel@gaiman>
References: <1234918786-854-1-git-send-email-eric@anholt.net>
	 <1234969734.4637.111.camel@laptop>  <499DC8EC.3000806@shipmail.org>
	 <1235082372.4612.665.camel@laptop>  <1235095484.2636.39.camel@gaiman>
	 <1235115406.4736.4.camel@laptop>  <1235549745.5213.4.camel@gaiman>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 10:07:16 +0100
Message-Id: <1235552836.4645.3089.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 00:15 -0800, Eric Anholt wrote:
> > Or you could get_user_pages() to fault the user pages and pin them, and
> > then do pagefault_disable() and use copy_from_user_inatomic or such, and
> > release the pages again.
> 
> I started poking at this today, since the get_user_pages sounded like
> the solution.  Only then I noticed: when we unbind an existing object,
> we have to unmap_mapping_range to clear the clients' mappings to it in
> the GTT, which needs to happen while the struct lock (protecting the gtt
> structure and the gtt to object mappings) is held.  So for fault we have
> mmap_sem held to struct mutex taken for poking at the gtt structure, and
> for unbind we have struct mutex held to mmap_sem taken to clear
> mappings.

So it again comes down to the fact that you cannot pin a gtt object
without also holding this struct_mutex?

Normally such things are done by elevating a refcount so that both
regular frees and reclaim gets delayed until you're done with the
object.



