Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYFYIFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYFYIFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYFYIFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:05:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbYFYIFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:05:03 -0400
Date: Wed, 25 Jun 2008 03:04:56 -0500
From: Paul Jackson <pj@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, akpm@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
Message-Id: <20080625030456.cab9ec3e.pj@sgi.com>
In-Reply-To: <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	<20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
	<20080623060939.6b6b3183.pj@sgi.com>
	<86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com>
	<20080624203252.f932c631.pj@sgi.com>
	<4861A5DF.5010104@zytor.com>
	<20080624211711.8c6d5105.pj@sgi.com>
	<4861AAEF.3020103@zytor.com>
	<alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org>
	<20080624220810.b2ec0c6a.pj@sgi.com>
	<alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux, replying to pj:
> > I'd be inclined instead to use "%P" for symbolic addrs.
> 
> That doesn't work - gcc warns about it.
> 
> That turns out to be a problem with %#p too. 

Ah so.

How about the following "sym(addr, buf)" macro?  This could make it
more practical to include kernel symbols within ordinary printk's.

On a silly little test with:

	{
		char b1[32], b2[32], b3[32];
		printk(">>>>>> Testing sym(): A. %s, B. %s, C. %s\n",
			sym(&pid_max, b1),
			sym(0xffffffff80615750, b2),		/* an addr in my System.map */
			sym(0, b3));
	}

the kernel printed:

	>>>>>> Testing sym(): A. pid_max+0x0/0x4, B. trampoline_base+0x0/0x10, C. 0x0

===========================================================================

--- linux.orig/include/linux/kallsyms.h	2008-06-23 15:16:49.885666712 -0700
+++ linux/include/linux/kallsyms.h	2008-06-25 00:48:09.446807842 -0700
@@ -32,6 +32,12 @@ extern int sprint_symbol(char *buffer, u
 /* Look up a kernel symbol and print it to the kernel messages. */
 extern void __print_symbol(const char *fmt, unsigned long address);
 
+/* Convert address to kernel symbol; can printk result with "%s" format */
+#define sym(address, namebuf) ({				\
+	sprint_symbol((namebuf), (unsigned long)(address));	\
+	(namebuf);						\
+})
+
 int lookup_symbol_name(unsigned long addr, char *symname);
 int lookup_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
