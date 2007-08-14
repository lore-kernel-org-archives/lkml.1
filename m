Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXHNLmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXHNLmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXHNLly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:41:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:24134 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbXHNLlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=t6ajLJGT4Pm6SeMqDL8Ir/6SxH1AVoaOjDePTJNEmg16/NMxepNMv1IdybQb3V8yp+X+8fjczF/66G3SFbqhV6MCmu+p0NwY3G6or8MDJQG5+JCNHBOLynYygVtfdZfA/jyojL1ITf/ApSWbUoECmw9aklkHYX0ScDPrBx0lsVc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: O_NONBLOCK is broken
Date: Tue, 14 Aug 2007 12:41:43 +0100
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708141241.44021.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I apologize for a provocative subject. O_NONBLOCK in Linux is not broken.
It is working as designed. But the design itself is suffering from a flaw.

Suppose I want to write block of data to stdout, without blocking.
I will do the classic thing:

int fl = fcntl(1, F_GETFL, 0);
fcntl(1, F_SETFL, fl | O_NONBLOCK);
r = write(1, buf, size);
fcntl(1, F_SETFL, fl); /* restore ASAP! */

The problem is, O_NONBLOCK flag is not attached to file *descriptor*,
but to a "file description" mentioned in fcntl manpage:

"Each open file description has certain associated status flags, initialized 
by open(2) and possibly modified by fcntl(2).  Duplicated file descriptors  
(made with dup(), fcntl(F_DUPFD), fork(), etc.) refer to the same open file 
description, and thus share the same file status flags."

We don't know whether our stdout descriptor #1 is shared with anyone or not,
and if we were started from shell, it typically is. That's why we try to
restore flags ASAP.

But "ASAP" isn't soon enough. Between setting and clearing O_NONBLOCK,
other process which share fd #1 with us may well be affected
by file suddenly becoming O_NONBLOCK under its feet.

Worse, other process can do the same
    fcntl(1, F_SETFL, fl | O_NONBLOCK);
    ...
    fcntl(1, F_SETFL, fl);
sequence, and first fcntl can return flags with O_NONBLOCK set (because of 
us), and then second fcntl will set O_NONBLOCK permanently, which is not
what was intended!

Other failure mode is that process can be killed by a signal
between fcntl's, leaving file in O_NONBLOCK mode.

This isn't theoretical problem, it actually happens not-so-rarely, for 
example, with pagers.

Possible solutions:

a) Introduce *per-fd* flag, so that one can use
   fcntl(1, F_SETFD, fdflag | O_NONBLOCK) instead of
   fcntl(1, F_SETFL, flflag | O_NONBLOCK) instead of
   Currently there is only one per-fd flag - O_CLOEXEC with value of 1.
   O_NONBLOCK is 0x4000.

b) Make recv(fd, buf, size, flags) and send(fd, buf, size, flags);
   work with non-socket fds too, for flags==0 or flags==MSG_DONTWAIT.
   (it's ok to fail with "socket op on non-socket fd" for other values
   of flags)

Both things are non-standard, but portable programs can test for errors
and fall back to "standard" UNIX way of doing it.


P.S. Hmm, it seems fcntl GETFL/SETFL interface seems to be racy:

    int fl = fcntl(fd, F_GETFL, 0);
    /* other process can muck with file flags here */
    fcntl(fd, F_SETFL, fl | SOME_BITS);

How can I *atomically* add or remove bits from file flags?
--
vda
