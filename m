Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0CBNKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:10:32 -0500
Received: from airmail.airvana.com ([131.239.32.135]:10025 "EHLO
	airmail.wirelessworld.airvananet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753062Ab0CBNK2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:10:28 -0500
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Mar 2010 08:10:28 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: do_loop_readv_writev() not as described for drivers implementing only write()?
Date: Tue, 2 Mar 2010 12:55:14 -0000
Message-ID: <4B3F8896E1733D4787DDB0EA1C7FF91F01163E1D@ukmail.uk.wirelessworld.airvananet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: do_loop_readv_writev() not as described for drivers implementing only write()?
Thread-Index: Acq6B5o/aWqPGI/gTdOvH6n3R9tZyA==
From: "Mike McTernan" <mmcternan@airvana.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Mar 2010 12:54:58.0062 (UTC) FILETIME=[903832E0:01CABA07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using writev() with an old FPGA driver which only implements
write(), not aio_write().  I'm expecting the behaviour described in the
man page for writev():

"The  data  transfers  performed by readv() and writev() are atomic: the
data written by writev() is written as a single block that is not
intermingled with output from writes in other processes (but see pipe(7)
for an exception); analogously, readv() is guaranteed to read a
contiguous block of data from the file, regardless of read operations
performed in other threads or processes that have file descriptors
referring to the same open file description (see open(2))."

I appear to be observing intermingling of individual iovec entries that
are being written to the same fd from different threads i.e. each call
to writev() isn't producing a contiguous block to be output.  This is at
odds with the man page description.

Looking into the kernel sources (from around 2.6.28 to 2.6.33), the
driver doesn't implement aio_write(), so vfs_writev() gets handled by
do_loop_readv_writev() as a series of discrete calls to the driver's
write().

I can't see where any locking is applied to ensure each iovec is handled
serially without 'internmingling', which would awkwardly have to be
outside the driver in this case.

Hunting around I found various good articles on writev() and the aio
stuff e.g.

  http://lwn.net/Articles/170954/
  http://lwn.net/Articles/24366/

But nowhere can I find whether it is expected behaviour that
writev/readv() for an driver which only implements write/readv() is
actually non-atomic.  Lots of sources are stating the atomicity of these
calls though.

Have I overlooked some good docs or some locking hidden in the vfs
handling?

Aside I'm working to update the driver to provide aio_write() so it can
provide it's own locking such that the userspace.

Kind Regards,

Mike

