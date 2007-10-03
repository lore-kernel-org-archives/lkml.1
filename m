Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbXJCA0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbXJCA0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXJCA0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:26:48 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:40746 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbXJCA0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:26:48 -0400
Date: Wed, 3 Oct 2007 10:26:46 +1000
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
Message-ID: <20071003002646.GD9814@bakeyournoodle.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <20070924123531.GC30855@shadowen.org> <20071002232819.GN4338@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071002232819.GN4338@austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 06:28:19PM -0500, Linas Vepstas wrote:
> On Mon, Sep 24, 2007 at 01:35:31PM +0100, Andy Whitcroft wrote:
> > Seeing the following from an older power LPAR, pretty sure we had
> > this in the previous -mm also:
> 
> I haven't forgetten about this ... and am looking at it now.
> Seems that whenever I go to reserve the machine pSeries-102,
> someone else is using it :-)

This panic is caused by "[POWERPC] pseries: Fix jumbled no_logging flag."
(79c0108d1b9db4864ab77b2a95dfa04f2dcf264c), in the powerpc/for-2.6.24
branch.  It looks to me that we have logging enabled too early now.

I think the following is a reasonable fix?

---
Explicitly enable RTAS error logging, when it should be ready.


Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---

 arch/powerpc/platforms/pseries/rtasd.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index 30925d2..0df5d0d 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -54,7 +54,10 @@ static unsigned int rtas_event_scan_rate;
 static int full_rtas_msgs = 0;
 
 /* Stop logging to nvram after first fatal error */
-static int no_more_logging;
+static int no_more_logging = 1; /* Until we initialize everything,
+                                 * make sure we don't try logging
+                                 * anything */
+
 
 static int error_log_cnt;
 
@@ -414,6 +417,8 @@ static int rtasd(void *unused)
 	memset(logdata, 0, rtas_error_log_max);
 	rc = nvram_read_error_log(logdata, rtas_error_log_max,
 	                          &err_type, &error_log_cnt);
+	/* We can use rtas_log_buf now */
+	no_more_logging = 0;
 
 	if (!rc) {
 		if (err_type != ERR_FLAG_ALREADY_LOGGED) {

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

