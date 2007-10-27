Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbXJ0Lmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbXJ0Lmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 07:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXJ0Lmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 07:42:44 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:43859 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXJ0Lmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 07:42:43 -0400
Date: Sat, 27 Oct 2007 07:39:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sg_next() for struct scatterlist is confusing
Message-ID: <Pine.LNX.4.64.0710270734210.24293@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  according to the inline comments in include/linux/scatterlist.h:

"* If bit 0 is set, then the page_link contains a pointer to the next sg
 * table list. Otherwise the next entry is at sg + 1."

but if that's the case, then the implementation of sg_next() seems a
bit weird:

=================================
/**
 * sg_next - return the next scatterlist entry in a list
 * @sg:         The current sg entry
 *
 * Description:
 *   Usually the next entry will be @sg@ + 1, but if this sg element is part
 *   of a chained scatterlist, it could jump to the start of a new
 *   scatterlist array.
 *
 **/
static inline struct scatterlist *sg_next(struct scatterlist *sg)
{
#ifdef CONFIG_DEBUG_SG
        BUG_ON(sg->sg_magic != SG_MAGIC);
#endif
        if (sg_is_last(sg))
                return NULL;

        sg++;
        if (unlikely(sg_is_chain(sg)))
                sg = sg_chain_ptr(sg);

        return sg;
}
================================

  note how the comment says that the next entry will "usually" be
sg+1, "but" not if it's actually a pointer.

  however, as i read the code above, sg is *always* incremented before
that testing.  is that correct?  am i just misreading something?  or
could the comment have been a bit clearer?

rday


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
