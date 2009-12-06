Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZLFJJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZLFJJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZLFJJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:09:13 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:53349 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZLFJJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:09:11 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/5] pathconf(3) with _PC_LINK_MAX 
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stewb@linux-foundation.org
In-Reply-To: <20091206083958.GC14381@ZenIV.linux.org.uk>
References: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp> <20091206083958.GC14381@ZenIV.linux.org.uk>
Date: Sun, 06 Dec 2009 18:09:06 +0900
Message-ID: <11114.1260090546@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> Um...  Why do we need that, again?  Note that there is no way whatsoever
> for predicting whether link(2) will fail due to having too many existing
> links before you attempt the call - links can be created or removed between
> stat(2) and link(2).  So any uses of that value are heuristical.
> 
> Can you actually show any use cases of that thing?  Preferably - in existing
> code, but even a theoretical one would be interesting.

Thanx for quick reply.
To be honest, I am unsure how important this is in real world.
But I've met (reported, precisly) such test program. It seems to come
from old X/Open, though the actual reporter tried the LSB (Linux
Standard Base) runtime-test.

You can get the source code from
ftp.freestandards.org/pub/lsb/test_suites/released-3.2/source/runtime/lsb-test-core-3.2.0-2.src.rpm
+ lsb-test-core-3.2.0.tar.gz
  + lts_vsx-pcts-3.2.0.tgz
    + tset/POSIX.os/files/link/link.c

Here I quote just a part from tset/POSIX.os/files/link/link.c,
The function tblink() behaves as a wrapper for link(2) with the error
checking.
When the filesystem is unknown to pathconf(_PC_LINK_MAX), 'link_max' may
be incorrect and LSB cannot pass this test.

test15()
{
	creat(t15a_file, MODEANY);
	link_max = pathconf(t15a_file, _PC_LINK_MAX);

	/* create lesser of LINK_MAX and PCTS_LINK_MAX links successfully */
	/* i.e. make (testmax-1) link() calls, as there is 1 link already */

	testmax = link_max;
	for (i = 0; i < testmax-1; i++)
	{
		(void) sprintf(links[i], "L%ld", i+1);
		if (tblink(t15a_file, links[i], SUCCEED, NOERROR) != SUCCEED)
			break;
	}

	/* if LINK_MAX is testable, next link gives EMLINK */

	(void) tblink(t15a_file, t15b_file, SYSERROR, EMLINK);
}


J. R. Okajima
