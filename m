Return-Path: <linux-kernel-owner+w=401wt.eu-S1161048AbXCMR0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161048AbXCMR0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161049AbXCMR0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:26:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39051 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161048AbXCMR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:26:44 -0400
Subject: Re: [RFC][PATCH 2/7] RSS controller core
From: Dave Hansen <hansendc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       menage@google.com, linux-kernel@vger.kernel.org, xemul@sw.ru
In-Reply-To: <20070312220439.677b4787.akpm@linux-foundation.org>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
	 <1173724979.11945.103.camel@localhost.localdomain>
	 <20070312224129.GC21258@MAIL.13thfloor.at>
	 <20070312220439.677b4787.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 10:26:33 -0700
Message-Id: <1173806793.6680.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 22:04 -0800, Andrew Morton wrote:
> So these mmapped pages will contiue to be shared across all guests.  The
> problem boils down to "which guest(s) get charged for each shared page".
> 
> A simple and obvious and easy-to-implement answer is "the guest which paged
> it in".  I think we should firstly explain why that is insufficient.

My first worry was that this approach is unfair to the poor bastard that
happened to get started up first.  If we have a bunch of containerized
web servers, the poor guy who starts Apache first will pay the price for
keeping it in memory for everybody else.

That said, I think this is naturally worked around.  The guy charged
unfairly will get reclaim started on himself sooner.  This will tend to
page out those pages that he was being unfairly charged for.  Hopefully,
they will eventually get pretty randomly (eventually evenly) spread
among all users.  We just might want to make sure that we don't allow
ptes (or other new references) to be re-established to pages like this
when we're trying to reclaim them.  Either that, or force the next
toucher to take ownership of the thing.  But, that kind of arbitrary
ownership transfer can't happen if we have rigidly defined boundaries
for the containers.

The other concern is that the memory load on the system doesn't come
from the first user ("the guy who paged it in").  The long-term load
comes from "the guy who keeps using it."  The best way to exemplify this
is somebody who read()s a page in, followed by another guy mmap()ing the
same page.  The guy who did the read will get charged, and the mmap()er
will get a free ride.  We could probably get an idea when this kind of
stuff is happening by comparing page->count and page->_mapcount, but it
certainly wouldn't be conclusive.  But, does this kind of nonsense even
happen in practice?  

-- Dave

