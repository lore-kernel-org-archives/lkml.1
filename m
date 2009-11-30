Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbZK3KXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbZK3KXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZK3KXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:23:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:57033 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZK3KXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:23:39 -0500
Subject: Re: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses
 and panics
From: David Woodhouse <dwmw2@infradead.org>
To: dedekind1@gmail.com
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1259571118.7518.56.camel@localhost>
References: <20091012131528.GC25464@elte.hu>
	 <20091012153937.0dcd73e5@marrow.netinsight.se>
	 <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	 <20091012110954.67d7d8d8.akpm@linux-foundation.org>
	 <20091012182346.GH17138@elte.hu>
	 <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	 <20091013151751.59e217a7@marrow.netinsight.se>
	 <20091013152235.188059d2@marrow.netinsight.se>
	 <20091126093657.GA25430@logfs.org> <1259566071.7518.48.camel@localhost>
	 <20091130074603.GA30911@logfs.org>  <1259571118.7518.56.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 10:23:31 +0000
Message-ID: <1259576611.19465.374.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 10:51 +0200, Artem Bityutskiy wrote:
> On Mon, 2009-11-30 at 08:46 +0100, Jörn Engel wrote:
> > On Mon, 30 November 2009 09:27:51 +0200, Artem Bityutskiy wrote:
> > > 
> > > To me it looks like 'log_end' is not supposed to wrap. What makes you
> > > think it can? In which cases it can?
> > 
> > It is a 32bit variable.  Would do you expect happens once you reach
> > 0xffffffff and add 1?
> 
> Yes, now I see log_end is an ever increasing variable.
> 
> How about this patch on top of the existing one (untested):

I suspect you should be modelling this more closely on the code in
do_syslog() for case 3. The end is at (log_end & LOG_BUF_MASK), and you
have (logged_chars) to write.

This mean that you won't write messages to the log which were 'cleared'
by 'dmesg -c', but that's acceptable, I think.

Why are you setting s1 to "" in the case where l1 is zero, btw? Can't it
be NULL?

diff --git a/kernel/printk.c b/kernel/printk.c
index f711b99..d150c57 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1486,26 +1486,33 @@ static const char *kmsg_to_str(enum kmsg_dump_reason reason)
  */
 void kmsg_dump(enum kmsg_dump_reason reason)
 {
-	unsigned long len = ACCESS_ONCE(log_end);
+	unsigned long end;
+	unsigned chars;
 	struct kmsg_dumper *dumper;
 	const char *s1, *s2;
 	unsigned long l1, l2;
 	unsigned long flags;
 
-	s1 = "";
-	l1 = 0;
-	s2 = log_buf;
-	l2 = len;
-
-	/* Have we rotated around the circular buffer? */
-	if (len > log_buf_len) {
-		unsigned long pos = len & LOG_BUF_MASK;
+	/* Theoretically, the log could move on after we do this, but
+	   there's not a log we can do about that. The new messages
+	   will overwrite the start of what we dump. */
+	spin_lock_irqsave(&logbuf_lock, flags);
+	end = log_end & LOG_BUF_MASK;
+	chars = logged_chars;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
 
-		s1 = log_buf + pos;
-		l1 = log_buf_len - pos;
+	if (logged_chars > end) {
+		s1 = log_buf + log_buf_len - logged_chars + end;
+		l1 = logged_chars - end;
 
 		s2 = log_buf;
-		l2 = pos;
+		l2 = end;
+	} else {
+		s1 = "";
+		l1 = 0;
+
+		s2 = log_buf + end - logged_chars;
+		l2 = logged_chars;
 	}
 
 	if (!spin_trylock_irqsave(&dump_list_lock, flags)) {


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

