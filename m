Return-Path: <linux-kernel-owner+w=401wt.eu-S1422714AbXBAJjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714AbXBAJjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 04:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422713AbXBAJjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 04:39:08 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35757 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422710AbXBAJjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 04:39:06 -0500
Date: Thu, 1 Feb 2007 10:22:52 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-aio <linux-aio@kvack.org>,
       Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Badari Pulavarty <pbadari@us.ibm.com>,
       Benjamin LaHaise <bcrl@linux.intel.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm 0/7][AIO] - AIO completion signal notification v6
Message-ID: <20070201102252.240130c6@frecb000686>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/02/2007 10:39:58,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/02/2007 10:40:05,
	Serialize complete at 01/02/2007 10:40:05
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Andrew,

  here is the latest rework of the aio notification and listio support
patches with comments from Oleg Nesterov and you addressed.

  Sébastien.

  This set now consists in 7 patches:

	1. rework-compat-sys-io-submit: cleanup the sys_io_submit() compat layer,
	   making it more efficient and laying out the base for the following patches

	2. aio-header-fix-includes: fixes the double inclusion of uio.h in aio.h

	3. aio-fix-access_ok-check: fixes the access_ok() checks

	4. make-good_sigevent-non-static: move good_sigevent into signal.c, rename
	   it to something more meaningfull and make it non-static

	5. make-__sigqueue_alloc-free-non-static: make __sigqueue_alloc() and
	   __sigqueue_free() non static

	6. aio-notify-sig: the AIO completion signal notification

	7. add-listio-syscall-support: adds listio support via a new syscall

  Description are in the individual patches.


  Changes from v5: based on comments from Oleg Nesterov and Andrew Morton

	- Fix for signo range not checked in the SIGEV_THREAD_ID case in
	  good_sigevent()
	- renamed good_sigevent() to sigevent_find_task()

	- Fixed the access_ok checks in sys_io_submit() and
	  compat_sys_io_submit()

	- Made __sigqueue_alloc() and __sigqueue_free() non static
	- Reworked the aio code to directly use __sigqueue_alloc() and
	  __sigqueue_free() and avoid messing with SIGQUEUE_PREALLOC

	- Removed the unneeded PF_EXITING check in aio_setup_sigevent()
	- Added a comment in aio_setup_sigevent() for why there is no task
	  ref leak
	- Changed read_lock(&tasklist_lock) to rcu_read_lock() in
	  aio_setup_sigevent()

	- Fixed an ioctx reference leak in compat_sys_lio_submit()
	- Renamed lio_check() as lio_notify()
	- Added comments to lio_notify() and lio_create()
	- Replaced sigqueue_free() by __sigqueue_free() in lio_notify()

  Changes from v4:
	No comments received for v4, so it must be perfect ;-)
	replaced the IOCB_CMD_GROUP listio implementation with Bharata's
	syscall approach which I find much cleaner.

  Changes from v3:

	- added justification for the compat_sys_io_submit() cleanup - Zach Brown
	- more cleanups in compat_sys_io_submit() to put it in line with
	  sys_io_submit() - Zach Brown

	- Changed "Export good_sigevent()" patch name to "Make good_sigevent()
	  non-static" to better describe what it does. - Christoph Hellwig
	- Reworked good_sigevent() to make it more readable. - Christoph Hellwig

	- Simplified the use of the SIGEV_* constants in signal notification -
	  Christoph Hellwig
	- Take a reference on the target task both for the SIGEV_THREAD_ID and
	  SIGEV_SIGNAL cases.

  Changes from v2:
	- rebased to 2.6.19-rc6-mm2
	- reworked the sys_io_submit() compat layer as suggested by Zach Brown
	- fixed saving of a pointer to a task struct in aio-notify-sig as
	  pointed out by Andrew Morton

  Changes from v1:
	- cleanups suggested by Christoph Hellwig, Badari Pulavarty and
	Zach Brown
	- added lisio patch


