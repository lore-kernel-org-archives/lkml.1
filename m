Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbZFPEF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbZFPEF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbZFPEFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:05:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbZFPEFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:05:17 -0400
Date: Mon, 15 Jun 2009 21:04:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] WARN(): add a \n to the message printk
In-Reply-To: <20090615171044.GC25760@elte.hu>
Message-ID: <alpine.LFD.2.01.0906152055580.3282@localhost.localdomain>
References: <20090615000822.6e6bf282@infradead.org> <alpine.LFD.2.01.0906150933330.3305@localhost.localdomain> <alpine.LFD.2.01.0906150945490.3305@localhost.localdomain> <20090615171044.GC25760@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Ingo Molnar wrote:
> 
> Nice idea ...
> 
> Puts some pressure on current intentionally 'naked' printks (there's 
> still a few of them) - but that's OK, it's not like KERN_CONT (or 
> pr_cont()) is that hard to add.

I looked some more, and there's a _ton_ of these naked printk's in the 
partition handling code.

So while I think the patch was a good idea, I don't feel like exposing 
quite that many old printk's and forcing people to use KERN_CONT. Here's 
an alternate patch that has a somewhat similar approach, but tries much 
harder to leave naked printk's as-is.

So instead of always adding a '\n' if it doesn't say KERN_CONT, it just 
adds '\n' if it has a KERN_xyz level. It also modifies the code to _only_ 
look at the beginning of the printk - if you have a multi-line printk, 
it will take the log-level from the beginning of the printk, and nowhere 
else.

And it will take the log-level from the beginning of the printk 
*regardless* of whether it thinks you're at the beginning of a line or 
not.

So with this, KERN_CONT is not as important, but it_is_ meaningful: if you 
want to print out something like "<%d>", then you _have_ to have a 
KERN_xyz header, and if you don't want to force a new line, you have to do

	printk(KERN_CONT "<%d>", n);

because otherwise the printk code will think that what you want to print 
out is the loglevel.

But for all the traditional printk()'s that don't have KERN_CONT (or other 
loglevel info), and print out strings that are not of that "<.>" form, 
they'll still work as they used to.

And no, this does not necessarily fix Arjan's problem: it only adds the 
newline before printk's that _do_ have a KERN_<lvl> format. So now, in 
order to get the extra '\n' after the WARN_ON() line, somebody needs to 
make sure that the printk's in the warning printing have loglevels.

Arjan?

		Linus

---
 include/linux/kernel.h |    2 +-
 kernel/printk.c        |   31 ++++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..066bb1e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -102,7 +102,7 @@ extern const char linux_proc_banner[];
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define	KERN_CONT	""
+#define	KERN_CONT	"<c>"
 
 extern int console_printk[];
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..a87770c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -687,20 +687,33 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				  sizeof(printk_buf) - printed_len, fmt, args);
 
 
+	p = printk_buf;
+
+	/* Do we have a loglevel in the string? */
+	if (p[0] == '<') {
+		unsigned char c = p[1];
+		if (c && p[2] == '>') {
+			switch (c) {
+			case '0' ... '7': /* loglevel */
+				current_log_level = c - '0';
+				if (!new_text_line) {
+					emit_log_char('\n');
+					new_text_line = 1;
+				}
+			/* Fallthrough - skip the loglevel */
+			case 'c': /* KERN_CONT */
+				p += 3;
+				break;
+			}
+		}
+	}
+
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
 	 * appropriate log level tags, we insert them here
 	 */
-	for (p = printk_buf; *p; p++) {
+	for ( ; *p; p++) {
 		if (new_text_line) {
-			/* If a token, set current_log_level and skip over */
-			if (p[0] == '<' && p[1] >= '0' && p[1] <= '7' &&
-			    p[2] == '>') {
-				current_log_level = p[1] - '0';
-				p += 3;
-				printed_len -= 3;
-			}
-
 			/* Always output the token */
 			emit_log_char('<');
 			emit_log_char(current_log_level + '0');
