Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYJNHFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYJNHFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYJNHFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:05:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52308 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYJNHFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:05:24 -0400
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <48F42A93.1040004@cs.helsinki.fi>
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
	 <1223631723.8959.46.camel@penberg-laptop>
	 <1223701131.7489.25.camel@charm-linux>
	 <1223881068.31587.1.camel@penberg-laptop>
	 <1223957031.10883.7.camel@charm-linux>  <48F42A93.1040004@cs.helsinki.fi>
Date: Tue, 14 Oct 2008 10:05:30 +0300
Message-Id: <1223967930.18017.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 08:13 +0300, Pekka Enberg wrote:
> Hi Tom,
> 
> Tom Zanussi wrote:
> > To me, that sounds like how it should work - if kmemtrace is disabled,
> > it shouldn't be logging anything, and that's in fact what I saw when
> > debugging this - it started out disabled and therefore nothing being
> > logged to relay (printks confirmed that).  When I wrote 1 to the enabled
> > file, data started getting logged to relay and to the *.out files.
> > 
> > So I don't know why the enabled state behaves the way it does, or if
> > it's unexpected, but that anyway doesn't seem like a relay problem to
> > me.
> 
> Oh, right. Looking at kmemtraced.c, we never enable kmemtrace, just 
> disable it (which doesn't make much sense). Bug in README or the code. 

Eduard, here's a fix for the userspace counterpart:

>From aa95e997458fd4d2a3b9a5c75e1452e22a3159af Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Tue, 14 Oct 2008 10:03:51 +0300
Subject: [PATCH] kmemtrace: enable tracing in kmemtraced

If kmemtrace is not enabled at boot, we need to enable it before we start
relaying data to userspace.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kmemtraced.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kmemtraced.c b/kmemtraced.c
index 217478d..5cc1ada 100644
--- a/kmemtraced.c
+++ b/kmemtraced.c
@@ -165,8 +165,6 @@ int main(int argc, char *argv[])
 	if (!readers)
 		panic("Out of memory!\n");
 
-	write_str("/sys/kernel/debug/kmemtrace/enabled", "0");
-
 	printf("Copying /proc/kallsyms...\n");
 	copy_kallsyms();
 
@@ -180,6 +178,8 @@ int main(int argc, char *argv[])
 			      strerror(errno));
 	}
 
+	write_str("/sys/kernel/debug/kmemtrace/enabled", "1");
+
 	printf("Logging... Press Control-C to stop.\n");
 
 	while (sigwait(&signals, &signal) == 0) {
-- 
1.5.4.3



