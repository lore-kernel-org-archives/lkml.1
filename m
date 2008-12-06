Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbYLFHlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbYLFHlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYLFHlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:41:04 -0500
Received: from vps1.tull.net ([66.180.172.116]:54201 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750863AbYLFHlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:41:01 -0500
Date: Sat, 6 Dec 2008 18:40:58 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] Sample refactor of socket.c to use	recursive printk
Message-ID: <20081206074058.GE5957@mail.local.tull.net>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net> <20081206070023.29149.92171.stgit@marcab.local.tull.net> <24518.1228547914@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24518.1228547914@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 02:18:34AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 06 Dec 2008 18:00:23 +1100, Nick Andrew said:
> > Sample refactor of socket.c to use recursive printk
> 
> I think we'd all appreciate it a lot if, instead of pointless code churn
> in socket.c, you used it to fix an *actual* problem - like any of the
> many places where we have issues with interleaved output in dmesg because
> a function had to use 2 or 3 printk calls to build up a line.

Fair enough, socket.c was only how I tested if it works, I never intended
it to be committed anywhere.

> In your 0/3 you point at sound/core/misc.c and drivers/cpufreq/cpufreq.c,
> both of those would be better than socket.c

Ok. This is how those two files would change, after Matt Mackall's patch
is applied. In each case we end up with a single printk, no interleaved
output, the code's smaller, still readable.

Nick.
---

 drivers/cpufreq/cpufreq.c |    3 +--
 sound/core/misc.c         |   14 +++++---------
 2 files changed, 6 insertions(+), 11 deletions(-)


diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index bc8bebc..27b323f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -234,8 +234,7 @@ void cpufreq_debug_printk(unsigned int type, const char *prefix,
 		spin_unlock_irqrestore(&disable_ratelimit_lock, flags);
 
 		va_start(args, fmt);
-		printk(KERN_DEBUG "%s: ", prefix);
-		vprintk(fmt, args);
+		printk(KERN_DEBUG "%s: %v", prefix, fmt, args);
 		va_end(args);
 	}
 }
diff --git a/sound/core/misc.c b/sound/core/misc.c
index 38524f6..ba9655f 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -39,16 +39,14 @@ void snd_verbose_printk(const char *file, int line, const char *format, ...)
 {
 	va_list args;
 	
+	va_start(args, format);
 	if (format[0] == '<' && format[1] >= '0' && format[1] <= '7' && format[2] == '>') {
 		char tmp[] = "<0>";
 		tmp[1] = format[1];
-		printk("%sALSA %s:%d: ", tmp, file, line);
-		format += 3;
+		printk("%sALSA %s:%d: %v", tmp, file, line, format + 3, args);
 	} else {
-		printk("ALSA %s:%d: ", file, line);
+		printk("ALSA %s:%d: %v", file, line, format, args);
 	}
-	va_start(args, format);
-	vprintk(format, args);
 	va_end(args);
 }
 
@@ -60,16 +58,14 @@ void snd_verbose_printd(const char *file, int line, const char *format, ...)
 {
 	va_list args;
 	
+	va_start(args, format);
 	if (format[0] == '<' && format[1] >= '0' && format[1] <= '7' && format[2] == '>') {
 		char tmp[] = "<0>";
 		tmp[1] = format[1];
-		printk("%sALSA %s:%d: ", tmp, file, line);
-		format += 3;
+		printk("%sALSA %s:%d: %v", tmp, file, line, format + 3, args);
 	} else {
 		printk(KERN_DEBUG "ALSA %s:%d: ", file, line);
 	}
-	va_start(args, format);
-	vprintk(format, args);
 	va_end(args);
 
 }
