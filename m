Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbZFOQ7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbZFOQ7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZFOQ67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:58:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbZFOQ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:58:58 -0400
Date: Mon, 15 Jun 2009 09:58:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] WARN(): add a \n to the message printk
In-Reply-To: <alpine.LFD.2.01.0906150933330.3305@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906150945490.3305@localhost.localdomain>
References: <20090615000822.6e6bf282@infradead.org> <alpine.LFD.2.01.0906150933330.3305@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Linus Torvalds wrote:
> 
> On Mon, 15 Jun 2009, Arjan van de Ven wrote:
> >  
> > -	if (args)
> > +	if (args) {
> >  		vprintk(args->fmt, args->args);
> > +		printk("\n");
> > +	}
> 
> I really don't like this. What if the format already does have a '\n'? And 
> what if some other CPU is printing at the same time?
> 
> I'd almost be open to adding a "flags" field to vprintk, and allow setting 
> things like "finish line with \n" there. Or perhaps even better, have a 
> "vprintk_line()" function that does it with no dynamic flags. Maybe make 
> it static, and move all these panic helper funtions into kernel/printk.c 
> (since this really is a special case).	
> 
> I dunno. I'm just throwing out suggestions. I just don't think the above 
> patch is very nice.

Oh, I actually think I have a preference.

I think we should _always_ cause a line break at the beginning of a new 
line, unless the new printk() starts with a KERN_CONT thing.

Right now KERN_CONT is "", but we could easily make it an explicit 
"loglevel" thing. Like this.

NOTE! This is, of course, totally untested. And we're bound to have 
continuation printk's that don't have the KERN_CONT at front, and need 
them added, but I think this is generally a saner model than what we have 
now, or your suggested explicit addition of '\n'.

Basically, it tries to guarantee that new messages always get a newline, 
unless they _explicitly_ say that they don't want one. Doesn't that make 
sense?

		Linus

---
 include/linux/kernel.h |    2 +-
 kernel/printk.c        |   16 +++++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

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
index 5052b54..6f416fd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -691,7 +691,21 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	 * Copy the output into log_buf.  If the caller didn't provide
 	 * appropriate log level tags, we insert them here
 	 */
-	for (p = printk_buf; *p; p++) {
+	p = printk_buf;
+
+	/* Are we continuing a previous printk? */
+	if (!new_text_line) {
+		if (!memcmp(p, KERN_CONT, 3)) {
+			/* We intended to do that continued printk! */
+			p += 3;
+		} else {
+			/* Force a line break */
+			emit_log_char('\n');
+			new_text_line = 1;
+		}
+	}
+
+	for ( ; *p; p++) {
 		if (new_text_line) {
 			/* If a token, set current_log_level and skip over */
 			if (p[0] == '<' && p[1] >= '0' && p[1] <= '7' &&
