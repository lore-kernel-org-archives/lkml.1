Return-Path: <linux-kernel-owner+w=401wt.eu-S1762951AbXK2MCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951AbXK2MCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbXK2MBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:01:04 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:37072 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762811AbXK2MA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:00:59 -0500
Date: Thu, 29 Nov 2007 15:01:19 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Robin Holt <holt@sgi.com>
Cc: Roland McGrath <roland@redhat.com>, Kawai@americas.sgi.com,
       Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bron Nelson <bron@sgi.com>,
       Stephen Champion <schamp@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: Can we make application core dumps interruptible?
Message-ID: <20071129120119.GA4385@tv-sign.ru>
References: <20071128123823.GB919@lnx-holt.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128123823.GB919@lnx-holt.americas.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Robin Holt wrote:
> 
> We have a customer machine with 4096 cpus.  When some user applications
> crash, it begins dumping core and can tie up the filesystem and
> processors for a considerable period of time.  Often, they contact the
> user and the user says the core dump files will not be useful and they
> reboot the machine.  They have already reduced the default core dump size
> to not dump anything and taken all reasonable steps to limiting core dumps
> while still allowing them to be useful for those users that need them.
> They would like to not need to reboot.
> 
> They hoped for a couple changes, one of which is a way for a SIGTERM,
> SIGKILL, or something along that line interrupting the core dump process.
> Is this the correct direction to take?  Are there any better ideas for
> handling this?

Well, I don't know what would be the right soultion, but perhaps we can do
something like the patch below. Allows to abort the coredump with kill -9.

Oleg.

--- fs/binfmt_elf.c~	2007-10-25 16:22:10.000000000 +0400
+++ fs/binfmt_elf.c	2007-11-29 14:47:43.000000000 +0300
@@ -1178,6 +1178,9 @@ out:
  */
 static int dump_write(struct file *file, const void *addr, int nr)
 {
+	if (sigismember(&current->signal->shared_pending.signal, SIGKILL))
+		return 0;
+
 	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
 }
 

