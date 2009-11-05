Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbZKEP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbZKEP1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZKEP1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:27:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:37508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZKEP1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:27:19 -0500
Date: Thu, 5 Nov 2009 16:27:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Michael Gilbert <michael.s.gilbert@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: CVE-2009-2584
In-Reply-To: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com>
Message-ID: <alpine.LRH.2.00.0911051620510.31913@twin.jikos.cz>
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding some more CCs and including patch below for completness, 
  obviously it got lost in space ]

On Wed, 4 Nov 2009, Michael Gilbert wrote:

> CVE-2009-2584 [0],[1] has been disclosed for quite a while now (with 
> existing exploit code by Brad Spengler [2]).  A patch has also been 
> available for the same amount of time [3], but as of 2.6.32-rc6 it is 
> still not applied.  Did this slip through the cracks?  Thanks upfront 
> for any info on the matter.
[ ... ]
> [0] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-2584
> [1] http://xorl.wordpress.com/2009/07/21/linux-kernel-sgi-gru-driver-off-by-one-overwrite/
> [2] http://grsecurity.net/~spender/exploit_demo.c
> [3] http://lkml.org/lkml/2009/7/20/348



From: Michael Buesch <mb@bu3sch.de>
Subject: sgi-gru: Fix kernel stack buffer overrun

This patch fixes a kernel stack buffer overrun in the sgi-gru procfs 
interface implementation. The "count" parameter to options_write() is user 
controlled. So this bug can be used to write '\0' bytes to almost 
arbitrary places on the kernel stack.

Cc: stable@kernel.org
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Acked-by: Jack Steiner <steiner@sgi.com>

--- linux-2.6.orig/drivers/misc/sgi-gru/gruprocfs.c
+++ linux-2.6/drivers/misc/sgi-gru/gruprocfs.c
@@ -157,23 +157,23 @@ static int options_show(struct seq_file 
 	seq_printf(s, "0x%lx\n", gru_options);
 	return 0;
 }
 
 static ssize_t options_write(struct file *file, const char __user *userbuf,
 			     size_t count, loff_t *data)
 {
 	unsigned long val;
 	char buf[80];
 
+	memset(buf, 0, sizeof(buf));
 	if (strncpy_from_user(buf, userbuf, sizeof(buf) - 1) < 0)
 		return -EFAULT;
-	buf[count - 1] = '\0';
 	if (!strict_strtoul(buf, 10, &val))
 		gru_options = val;
 
 	return count;
 }
 
 static int cch_seq_show(struct seq_file *file, void *data)
 {
 	long gid = *(long *)data;
 	int i;

  
