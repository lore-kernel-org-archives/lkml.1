Return-Path: <linux-kernel-owner+w=401wt.eu-S1422710AbXDLH3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbXDLH3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422713AbXDLH3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:29:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422710AbXDLH3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:29:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=wvjIhJwR81lkF2WgLjFqtHtrRUd1c210Esq1afLwKH9cJOWnNNkE6/4bGQ+wsMTKR
	AXzhD2ZvmjX9yePsnvAKw==
Message-ID: <b040c32a0704120029u423bfd39pfa0479c3c678ebe2@mail.gmail.com>
Date: Thu, 12 Apr 2007 00:29:28 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Zach Brown" <zach.brown@oracle.com>
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Cc: akpm@linux-foundation.org, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410235353.325A7346F64@localhost>
	 <20070411180038.GN28322@mami.zabbo.net>
	 <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Ken Chen <kenchen@google.com> wrote:
> On 4/11/07, Zach Brown <zach.brown@oracle.com> wrote:
> > First, I'll NAK this and all AIO patches until the patch description
> > says that it's been run through the regression tests that we've started
> > collecting in autotest.  They're trivial to run, never fear:
>
> OK.  I will run those regression tests.

Unfortunately, the aio_dio_bugs test in autotest has bug in it :-(
We need stress test the "test code".

on stock 2.6.21-rc6 kernel:

[rock-me-baby]$ cd autotest/tests/aio_dio_bugs/src
[rock-me-baby]$ make
[rock-me-baby]$ ./aio-free-ring-with-bogus-nr-pages
aio-free-ring-with-bogus-nr-pages: Error: io_setup returned -22,
expected -ENOMEM

hmm???  The problem is that the test code forgot to initialized ctx
variable and in the kernel, sys_io_setup returns EINVAL if user
address contain none-zero value.

I will submit the following patch to autotest to correct the test code.

--- aio-free-ring-with-bogus-nr-pages.c.orig	2007-04-11 23:57:45 -0700
+++ aio-free-ring-with-bogus-nr-pages.c	2007-04-11 23:57:59 -0700
@@ -39,7 +39,7 @@
 int main(int __attribute__((unused)) argc, char **argv)
 {
 	long res;
-	io_context_t ctx;
+	io_context_t ctx = 0;
 	void* map;

 	while (1) {
