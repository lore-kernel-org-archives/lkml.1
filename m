Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZELHKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZELHKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZELHKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:10:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:53085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZELHKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:10:37 -0400
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1242109650.11251.313.camel@twins>
References: <20090508165219.469818319@chello.nl>
	 <20090508170028.837558214@chello.nl> <200905120158.46314.arnd@arndb.de>
	 <1242108700.11251.304.camel@twins>
	 <18953.5533.398597.677737@drongo.ozlabs.ibm.com>
	 <1242109650.11251.313.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 12 May 2009 09:10:25 +0200
Message-Id: <1242112226.11251.315.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 08:27 +0200, Peter Zijlstra wrote:
> On Tue, 2009-05-12 at 16:22 +1000, Paul Mackerras wrote:
> > Peter Zijlstra writes:
> > 
> > > Hmm, are you saying that the 3rd argument to unlocked_ioctl is actually
> > > (void __user *) instead of unsigned long?
> > 
> > He's saying (correctly) that using _IOR or _IOW implies that the ioctl
> > is going to read or write the memory location pointed to by the 3rd
> > argument to unlocked_ioctl.  If the 3rd argument is just a number, not
> > an address, I believe you should use _IO.
> 
> Oh, somewhat confusing all this. Would be good to spell out these things
> somewhere. Documentation/ioctl/ seems less than helpful.

Ah, so _IO() gets an unsigned long 3rd argument.
_IOW() treats the 3rd arg as a (type __user *) and copies the bits over
_IOR() copies the bits back out to userspace
_IORW() does both

In which case the below should fix things up, no?

---
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 614f921..6a9cebc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -159,10 +159,10 @@ struct perf_counter_hw_event {
 /*
  * Ioctls that can be done on a perf counter fd:
  */
-#define PERF_COUNTER_IOC_ENABLE		_IOW('$', 0, u32)
-#define PERF_COUNTER_IOC_DISABLE	_IOW('$', 1, u32)
-#define PERF_COUNTER_IOC_REFRESH	_IOW('$', 2, u32)
-#define PERF_COUNTER_IOC_RESET		_IOW('$', 3, u32)
+#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
+#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
+#define PERF_COUNTER_IOC_REFRESH	_IO('$', 2)
+#define PERF_COUNTER_IOC_RESET		_IO('$', 3)
 
 enum perf_counter_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,

