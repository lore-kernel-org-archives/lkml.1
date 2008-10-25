Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbYJYONi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbYJYONi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJYONa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:13:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:40664 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYJYON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:13:29 -0400
Date: Sat, 25 Oct 2008 07:13:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc1 regression] wmifinfo dockapp takes 100% of cpu
 (bisected)
Message-ID: <20081025071348.63c426d9@infradead.org>
In-Reply-To: <490327B6.2090903@linux.intel.com>
References: <20081025094043.GA4438@localhost.aei.mpg.de>
	<490327B6.2090903@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 07:05:42 -0700
Arjan van de Ven <arjan@linux.intel.com> wrote:

> Carlos R. Mafra wrote:
> 
> 
> Hi,
> 
> the line below is the key one:
> 
> > select(4, [3], NULL, NULL, {0, 5000000}) = -1 EINVAL (Invalid
> > argument)
> 
> the application gives us an invalid timeval; it should have been (5,
> 0) However, if the kernel accepted this before the kernel needs to
> now also accept it obviously, I'll look into it

This patch should fix it; I'm a bit worried that I need to fix up
userlands "mess", but ok. I also checked all other converted functions,
and only select has this problem. The problem is that the conversion
from microseconds to nanoseconds is overflowing ;-(

can you give this one a test?

diff --git a/fs/compat.c b/fs/compat.c
index fe3c9bf..95ceee6 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1680,9 +1680,16 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 	int ret;
 
 	if (tvp) {
+		int i;
 		if (copy_from_user(&tv, tvp, sizeof(tv)))
 			return -EFAULT;
 
+		while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
+			i++;
+			tv.tv_sec ++;
+			tv.tv_usec -= USEC_PER_SEC;
+		}
+
 		to = &end_time;
 		if (poll_select_set_timeout(to, tv.tv_sec,
 					    tv.tv_usec * NSEC_PER_USEC))
diff --git a/fs/select.c b/fs/select.c
index 448e440..e4e7cdb 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -515,9 +515,16 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 	int ret;
 
 	if (tvp) {
+		int i = 0;
 		if (copy_from_user(&tv, tvp, sizeof(tv)))
 			return -EFAULT;
 
+		while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
+			i++;
+			tv.tv_sec ++;
+			tv.tv_usec -= USEC_PER_SEC;
+		}
+
 		to = &end_time;
 		if (poll_select_set_timeout(to, tv.tv_sec,
 					    tv.tv_usec * NSEC_PER_USEC))

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
