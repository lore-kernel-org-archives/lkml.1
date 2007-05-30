Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXE3ROv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXE3ROv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXE3ROn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:14:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11449 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbXE3ROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:14:43 -0400
Date: Wed, 30 May 2007 10:08:01 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Dave Jones <davej@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530170801.GC5488@mami.zabbo.net>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070529230931.GL7875@mami.zabbo.net> <465CB524.4020006@redhat.com> <20070530011108.GA2794@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530011108.GA2794@redhat.com>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> due to the added syscall. (Maybe we can just get that reserved
> upstream now?)

Maybe, but we'd have to agree on the bare syslet interface that is being
supported :).

Personally, I'd like that to be the simplest thing that works for people
and I'm not convinced that the current syslet-specific syscalls are that.
Certainly not the atom interface, anyway.

+asmlinkage __attribute__((weak)) long
+sys_umem_add(unsigned long __user *uptr, unsigned long inc)
+{
+       unsigned long val, new_val;
+
+       if (get_user(val, uptr))
+               return -EFAULT;
+       /*
+        * inc == 0 means 'read memory value':
+        */
+       if (!inc)
+               return val;
+
+       new_val = val + inc;
+       if (__put_user(new_val, uptr))
+               return -EFAULT;
+
+       return new_val;
+}

A syscall for *long addition* strikes me as a bit much, I have to admit.
Where do we stop?  (Where's the compat wrapper? :))

Maybe this would be fine for some wildly aggressive optimization some
number of years in the future when we have millions of syslet interface
users complaining about the cycle overhead of their syslet engines, but
it seems like we can do something much less involved in the first pass
without harming the possibility of promising to support this complex
optimization in the future.

- z
