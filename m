Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYLFHAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYLFHAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYLFHAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:00:08 -0500
Received: from vps1.tull.net ([66.180.172.116]:52698 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752064AbYLFHAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:00:06 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [RFC PATCH v1 2/3] Add %v support to vsnprintf()
Cc: <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 06 Dec 2008 18:00:03 +1100
Message-ID: <20081206070003.29149.50293.stgit@marcab.local.tull.net>
In-Reply-To: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add %v support to vsnprintf()

vsnprintf() is extended to support a '%v' in the format string.  '%v'
takes two arguments, the first is a format string and the second is a
va_list. vsnprintf() is recursively called to process the specified
format string and arguments, before returning to the original format
string.

This allows functions like the following, which prepend a
subsystem-specific string to an error message:

int subsystem_error(char *fmt, ...) {
    va_list ap;
    int rc;

    va_start(ap, fmt);
    rc = printk("%s: %v\n", "SUBSYSTEM", fmt, ap);
    va_end(ap);
    return rc;
}

Functions printing errors inside the subsystem would do like:

    subsystem_error("Failed to get widget: %d", 3);

The resulting kernel message would be:

    SUBSYSTEM: Failed to get widget: 3\n

The advantage over using say 2 printk() calls is that message output
will be contiguous, whereas separate printk() calls might be broken
by an intervening message from another kernel thread. Also a single
message buffer is used, which avoids double-handling and excessive
memory use.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 lib/vsprintf.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)


diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1e2dcaf..e779f79 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -632,6 +632,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
  * %pS output the name of a text symbol
  * %pF output the name of a function pointer
  * %pR output the address range in a struct resource
+ * %v  processes a supplied format string and args, recursively
  *
  */
 
@@ -787,6 +788,19 @@ static char *__vsnprintfr(char *buf, char *str, char *end,
 			case 'u':
 				break;
 
+			case 'v': {
+				char *fmt2;
+				va_list args2;
+
+				fmt2 = va_arg(args, char *);
+				args2 = va_arg(args, va_list);
+				/* recurse to format the (fmt,args) pair */
+				str = __vsnprintfr(buf, str, end, fmt2, args2);
+				va_end(args2);
+
+				continue;
+			}
+
 			default:
 				if (str < end)
 					*str = '%';

