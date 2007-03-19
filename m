Return-Path: <linux-kernel-owner+w=401wt.eu-S965889AbXCSPgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965889AbXCSPgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbXCSPgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:36:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64136 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446AbXCSPgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:36:40 -0400
Date: Mon, 19 Mar 2007 08:35:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@in.ibm.com, rdunlap@xenotime.net, jlan@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: taskstats accounting info
Message-Id: <20070319083512.908fc695.randy.dunlap@oracle.com>
In-Reply-To: <20070315110655.5a815f2e.akpm@linux-foundation.org>
References: <Pine.LNX.4.58.0703140503250.28169@shark.he.net>
	<45F7E818.7010608@in.ibm.com>
	<20070315110655.5a815f2e.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 11:06:55 -0800 Andrew Morton wrote:

> > On Wed, 14 Mar 2007 17:48:32 +0530 Balbir Singh <balbir@in.ibm.com> wrote:
> > Randy.Dunlap wrote:
> > > Hi,
> > > 
> > > Documentation/accounting/delay-accounting.txt says that the
> > > getdelays program has a "-c cmd" argument, but that option
> > > does not seem to exist in Documentation/account/getdelays.c.
> > > 
> > > Do you have an updated version of getdelays.c?
> > > If not, please correct that documentation.
> > > 
> > 
> > Yes, I did, but then I changed my laptop. I should have it archived
> > at some place, I'll dig it out or correct the documentation.
> > 
> > > Is getdelays.c the best available example of a program
> > > using the taskstats netlink interface?
> > > 
> > 
> > It's the most portable example, since it does not depend on libnl.
> 
> err, what is libnl?

lib-netlink (as already answered, but I wrote this last week)

> If there exists some real userspace infrastructure which utilises
> taskstats, can we please get a referece to it into the kernel
> Documentation?  Perhaps in the TASKSTATS Kconfig entry, thanks.


Balbir, I was working with getdelays.c when I initially wrote
these questions.  Here is a small patch for it.  Hopefully you can
use it when you find the updated version of it.

~Randy

From: Randy Dunlap <randy.dunlap@oracle.com>

1.  add usage() function

2.  add unknown character in %c format (was only in %d, not useful):

./getdelays: invalid option -- h
Unknown option '?' (63)

instead of:

./getdelays: invalid option -- h
Unknown option 63

(or just remove that message)

3.  -v does not use an optarg, so remove ':' in getopt string after 'v';

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 getdelays.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- old/Documentation/accounting/getdelays.c
+++ new/Documentation/accounting/getdelays.c
@@ -72,6 +72,15 @@ struct msgtemplate {
 
 char cpumask[100+6*MAX_CPUS];
 
+static void usage(void)
+{
+	fprintf(stderr, "getdelays [-dilv] [-w logfile] [-r bufsize] [-m cpumask] [-t tgid] [-p pid]\n");
+	fprintf(stderr, "  -d: print delayacct stats\n");
+	fprintf(stderr, "  -i: print IO accounting\n");
+	fprintf(stderr, "  -l: listen forever\n");
+	fprintf(stderr, "  -v: debug on\n");
+}
+
 /*
  * Create a raw netlink socket and bind
  */
@@ -227,7 +236,7 @@ int main(int argc, char *argv[])
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "diw:r:m:t:p:v:l");
+		c = getopt(argc, argv, "diw:r:m:t:p:vl");
 		if (c < 0)
 			break;
 
@@ -277,7 +286,8 @@ int main(int argc, char *argv[])
 			loop = 1;
 			break;
 		default:
-			printf("Unknown option %d\n", c);
+			printf("Unknown option '%c' (%d)\n", c, c);
+			usage();
 			exit(-1);
 		}
 	}
