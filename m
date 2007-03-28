Return-Path: <linux-kernel-owner+w=401wt.eu-S965550AbXC1Lic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbXC1Lic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 07:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965547AbXC1Lic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 07:38:32 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:37499 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965549AbXC1Lib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 07:38:31 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-kernel@vger.kernel.org
Subject: question on tty open and close
Date: Wed, 28 Mar 2007 13:38:29 +0200
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281338.29250.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH7LxRcmd0Z
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in tty_io.c::tty_open():

	if (!retval) {
		if (tty->driver->open)
			retval = tty->driver->open(tty, filp);
		else
			retval = -ENODEV;
	}
	filp->f_flags = saved_flags;

	if (!retval && test_bit(TTY_EXCLUSIVE, &tty->flags) && !capable(CAP_SYS_ADMIN))
		retval = -EBUSY;

	if (retval) {
#ifdef TTY_DEBUG_HANGUP
		printk(KERN_DEBUG "error %d in opening %s...", retval,
		       tty->name);
#endif
		release_dev(filp);

We find that a failure in open() leads to release_dev() being called.
release_dev() calls close():

	if (tty->driver->close)
		tty->driver->close(tty, filp);

So we have a file that's closed although open() never succeeded?
What's the reason for that?

	Regards
		Oliver
