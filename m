Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbYDVNPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbYDVNPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYDVNPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:15:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:14765 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbYDVNPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=aqj0eW8u5TxwgTIKUf9nSy0HFZkckmQLaR1/eysNE/h+FIAqfu5w5XNWlQwBI3RA47K+jQSXrUXrwA5tjxMuQSYCJEwggLOdPoVcICPHr+i7PnOYQLghhhBovjIPU2jX2NOXFamJqQ0znLB1ARNwN2k3jxuVEFMiUYZsQHoEb4E=
Message-ID: <480DE523.6030304@gmail.com>
Date: Tue, 22 Apr 2008 15:16:19 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
Subject: MAP_POPULATE behavior change?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

In 2.6.23, you had the commit below, which seems to have changed the
kernel-userland API.

Am I right to understand that with this patch MAP_POPULATE now also works with
MAP_PRIVATE mappings?  (Formerly it only worked with MAP_SHARED mappings, but
some very quick testing suggests that MAP_POPULATE now also has an affect for
MAP_PRIVATE.)

Also, can you summarize the status of MAP_NONBLOCK?  Is it now a no-op?

Cheers,

Michael

==

commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7
Author: Nick Piggin <npiggin@suse.de>
Date:   Thu Jul 19 01:46:59 2007 -0700

    mm: merge populate and nopage into fault (fixes nonlinear)

    Nonlinear mappings are (AFAIKS) simply a virtual memory concept that encodes
    the virtual address -> file offset differently from linear mappings.

    ->populate is a layering violation because the filesystem/pagecache code
    should need to know anything about the virtual memory mapping.  The hitch here
    is that the ->nopage handler didn't pass down enough information (ie.  pgoff).
     But it is more logical to pass pgoff rather than have the ->nopage function
    calculate it itself anyway (because that's a similar layering violation).

    Having the populate handler install the pte itself is likewise a nasty thing
    to be doing.

    This patch introduces a new fault handler that replaces ->nopage and
    ->populate and (later) ->nopfn.  Most of the old mechanism is still in place
    so there is a lot of duplication and nice cleanups that can be removed if
    everyone switches over.

    The rationale for doing this in the first place is that nonlinear mappings are
    subject to the pagefault vs invalidate/truncate race too, and it seemed stupid
    to duplicate the synchronisation logic rather than just consolidate the two.

    After this patch, MAP_NONBLOCK no longer sets up ptes for pages present in
    pagecache.  Seems like a fringe functionality anyway.

    NOPAGE_REFAULT is removed.  This should be implemented with ->fault, and no
    users have hit mainline yet.


