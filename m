Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbXLCQ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbXLCQ4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXLCQ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:56:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbXLCQ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:56:25 -0500
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zach.brown@oracle.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 BUG] 100% iowait on host while UML is running
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <E1IzDHv-0003xj-Af@dorka.pomaz.szeredi.hu>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Mon, 03 Dec 2007 11:55:16 -0500
In-Reply-To: <E1IzDHv-0003xj-Af@dorka.pomaz.szeredi.hu> (Miklos Szeredi's message of "Mon\, 03 Dec 2007 16\:32\:51 +0100")
Message-ID: <x49ir3fhg5n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On 2.6.24, top started showing 100% iowait on one CPU when a UML
> instance was running (but completely idle).  I've traced it to this
> commit [1].  Reverting it cures the problem.

Hi,

The UML code sits in io_getevents waiting for an event to be submitted
and completed.  This is a case I completely overlooked when putting
together the referenced patch.

We could check ctx->reqs_active before scheduling to determine whether
or not we are waiting for I/O, but this would require taking the
context lock in order to be accurate.  Given that the test would be
only for the sake of book keeping, it might be okay to do it outside
of the lock.

Zach, what are your thoughts on this?

-Jeff


[1] commit 41d10da3717409de33d5441f2f6d8f072ab3fbb6
