Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZCSEZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZCSEZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 00:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZCSEY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 00:24:56 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:60463 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZCSEYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 00:24:55 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 00:24:55 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qei046OzSfHHPhMExJUf9VLeR70KH7I6djl6T9iu8hU8jy5UFBHIhMYIi8ie9aUPUF
         CzUeOqlwHoj4R0oiZgEXuJMoXMk0x98ozsoh90U8maqyPe2wpKrfUyK1WVit3/Ww6Ccs
         e0QR1NBUXsbWSjH2pLfrvidOcCko28YtSTyAY=
Subject: Re: PROBLEM: relay - stale data copied to user space
From: Tom Zanussi <tzanussi@gmail.com>
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <1237388848.4084.64.camel@kitka.ibm.com>
References: <1237388848.4084.64.camel@kitka.ibm.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 23:19:07 -0500
Message-Id: <1237436347.7834.13.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-03-18 at 16:07 +0100, Martin Peschke wrote:

> 
> This is my theory:
> Timing matters. It's a race caused by improper protection of critical
> sections in a producer-consumer scenario. A bug in the bookkeeping
> allows a reader to read at a position that is just being written to.
> 

It does look consistent with a reader reading an event that's been
reserved but not yet written, or partially written e.g. if an event
being written on one cpu was read by another before the first one
finished.  Can you see if the below patch to blktrace userspace helps?

Or failing that, explicitly using gettid() in place of getpid() in
sched_setaffinity().  Or, failing that, you had mentioned previously
that you would try to reproduce the problem on your laptop - were you
able to do that?  If so, it would help in debugging it further...

Tom

diff --git a/blktrace.c b/blktrace.c
index 26b3afd..656ab7a 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -610,7 +610,7 @@ static int lock_on_cpu(int cpu)
 
 	CPU_ZERO(&cpu_mask);
 	CPU_SET(cpu, &cpu_mask);
-	if (sched_setaffinity(getpid(), sizeof(cpu_mask), &cpu_mask) < 0)
+	if (sched_setaffinity(0, sizeof(cpu_mask), &cpu_mask) < 0)
 		return errno;
 
 	return 0;


