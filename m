Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYEHIpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYEHIpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYEHIpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:45:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:17961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYEHIpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:45:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="diff'?scan'208";a="279159731"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080508073924.GA30356@elte.hu>
References: <1210126286.3453.37.camel@ymzhang>
	 <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org>
	 <20080507114643.GR19219@parisc-linux.org>
	 <87hcdab8zp.fsf@basil.nowhere.org>
	 <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
	 <1210214696.3453.87.camel@ymzhang> <20080508064340.GA27452@elte.hu>
	 <1210230883.3453.127.camel@ymzhang>  <20080508073924.GA30356@elte.hu>
Content-Type: multipart/mixed; boundary="=-vSiUv7eRXo9Z2Eq8/Xx+"
Date: Thu, 08 May 2008 16:44:14 +0800
Message-Id: <1210236254.3453.137.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vSiUv7eRXo9Z2Eq8/Xx+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 2008-05-08 at 09:39 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > > great! Yanmin, could you please also check the other patch i sent 
> > > (also attached below), does it solve the regression similarly?
> >
> > With your patch, aim7 regression becomes less than 2%. I ran the 
> > testing twice.
> > 
> > Linus' patch could recover it completely. As aim7 result is quite 
> > stable(usually fluctuating less than 1%), 1.5%~2% is a little big.
> 
> is this the old original aim7 you are running,
I useold AIM7 plus a small patch which is just to change a couple of data type to match
64bit.

>  or osdl-aim-7 or 
> re-aim-7?
> 
> if it's aim7 then this is a workload that starts+stops 2000 parallel 
> tasks that each start and exit at the same time.
Yes.

>  That might explain its 
> sensitivity on the BKL - this is all about tty-controlled task startup 
> and exit.
> 
> i could not get it to produce anywhere close to stable results though. I 
> also frequently get into this problem:
> 
>   AIM Multiuser Benchmark - Suite VII Run Beginning
>   Tasks    jobs/min  jti  jobs/min/task      real       cpu
>    2000
>   Failed to execute
>           new_raph 200
>   Unable to solve equation in 100 tries. P = 1.5708, P0 = 1.5708, delta = 6.12574e-17
> 
>   Failed to execute
>           disk_cp /mnt/shm
>   disk_cp (1): cannot open /mnt/shm/tmpa.common
>   disk1.c: No such file or directory
> 
>   [.. etc. a large stream of them .. ]
> 
> system has 2GB of RAM and tmpfs mounted to the place where aim7 puts its 
> work files.
My machine has 8GB. To simulate your environment, I reserve 6GB for hugetlb, then reran the testing
and didn't see any failure except:
AIM Multiuser Benchmark - Suite VII Run Beginning

Tasks    jobs/min  jti  jobs/min/task      real       cpu
 2000create_shared_memory(): can't create semaphore, pausing...
create_shared_memory(): can't create semaphore, pausing...


Above info doesn't mean errors.

Perhaps you could:
1) Apply the attched aim9 patch;
2) check if you have write right under /mnt/shm;
3) echo "/mnt/shm">aim7_path/config;


--=-vSiUv7eRXo9Z2Eq8/Xx+
Content-Disposition: attachment; filename=aim9.diff
Content-Type: text/x-patch; name=aim9.diff; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -urp aim9.orig/creat-clo.c aim9/creat-clo.c
--- aim9.orig/creat-clo.c	2002-04-22 15:25:16.000000000 -0700
+++ aim9/creat-clo.c	2005-07-11 10:20:13.000000000 -0700
@@ -352,7 +352,7 @@ page_test(char *argv,
 	 */
 	oldbrk = sbrk(0);		/* get current break value */
 	newbrk = sbrk(1024 * 1024);	/* move up 1 megabyte */
-	if ((int)newbrk == -1) {
+	if (newbrk == (void *)-1L) {
 		perror("\npage_test");	/* tell more info */
 		fprintf(stderr, "page_test: Unable to do initial sbrk.\n");
 		return (-1);
@@ -365,7 +365,7 @@ page_test(char *argv,
 		newbrk = sbrk(-4096 * 16);	/* deallocate some space */
 		for (i = 0; i < 16; i++) {	/* now get it back in pieces */
 			newbrk = sbrk(4096);	/* Get pointer to new space */
-			if ((int)newbrk == -1) {
+			if (newbrk == (void *)-1L) {
 				perror("\npage_test");	/* tell more info */
 				fprintf(stderr,
 					"page_test: Unable to do sbrk.\n");
@@ -406,7 +406,7 @@ brk_test(char *argv,
 	 */
 	oldbrk = sbrk(0);		/* get old break value */
 	newbrk = sbrk(1024 * 1024);	/* move up 1 megabyte */
-	if ((int)newbrk == -1) {
+	if (newbrk == (void *)-1L) {
 		perror("\nbrk_test");	/* tell more info */
 		fprintf(stderr, "brk_test: Unable to do initial sbrk.\n");
 		return (-1);
@@ -419,7 +419,7 @@ brk_test(char *argv,
 		newbrk = sbrk(-4096 * 16);	/* deallocate some space */
 		for (i = 0; i < 16; i++) {	/* allocate it back */
 			newbrk = sbrk(4096);	/* 4k at a time (should be ~ 1 page) */
-			if ((int)newbrk == -1) {
+			if (newbrk == (void *)-1L) {
 				perror("\nbrk_test");	/* tell more info */
 				fprintf(stderr,
 					"brk_test: Unable to do sbrk.\n");
diff -urp aim9.orig/pipe_test.c aim9/pipe_test.c
--- aim9.orig/pipe_test.c	2002-04-22 15:25:16.000000000 -0700
+++ aim9/pipe_test.c	2005-07-11 10:21:19.000000000 -0700
@@ -493,8 +493,8 @@ readn(int fd,
 		buf += result;		/* update pointer */
 		if (--count <= 0) {
 			fprintf(stderr,
-				"\nMaximum iterations exceeded in readn(%d, %#x, %d)",
-				fd, (unsigned)buf, size);
+				"\nMaximum iterations exceeded in readn(%d, %p, %d)",
+				fd, buf, size);
 			return (-1);
 		}
 	}				/* and loop */
@@ -523,8 +523,8 @@ writen(int fd,
 		buf += result;		/* update pointer */
 		if (--count <= 0) {	/* handle too many loops */
 			fprintf(stderr,
-				"\nMaximum iterations exceeded in writen(%d, %#x, %d)",
-				fd, (unsigned)buf, size);
+				"\nMaximum iterations exceeded in writen(%d, %p, %d)",
+				fd, buf, size);
 			return (-1);
 		}
 	}				/* and loop */

--=-vSiUv7eRXo9Z2Eq8/Xx+--

