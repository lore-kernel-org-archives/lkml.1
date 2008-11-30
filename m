Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYK3DVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYK3DVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 22:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYK3DVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 22:21:34 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:41753 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752848AbYK3DVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 22:21:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RogV6Shoc9du9IL9OwYrd6PqO937KJzDtH3Axc4+Sd/FxyY26QVx3ShR4ohmiGhteTX4HQi28s6Ar2RY/pHzpQMBcpwhw6ahz5LeIqQ9KHlKx/tVv9gtmNc8Hzg9uVlyIly1khLu09rcvEA+8BKI3I3FNwpgbce1wsUITHefMLI=  ;
X-YMail-OSG: lvgu2PUVM1kG.tCrzNjwr9OHL.llXJFbcN5C47i3FKJPbW7oG4m0XqDZgckupOLLgFtZbbZnQkRIMInNJNDx9Es61duSs1Xke3ho7l46wPACF1nmZz89DaAPGB05P1LKZ0bAxeQVmNsGBeEKVHfL9xb.
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.28-rc6] when to BUG(), and when to not BUG()
Date: Sat, 29 Nov 2008 19:21:30 -0800
User-Agent: KMail/1.9.10
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811291921.30759.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Provide some basic advice about when to use BUG()/BUG_ON():
never, unless there's really no better option.

This matches my understanding of the standard policy ... which
seems not to be written down so far, outside of LKML messages
that I haven't bookmarked.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
This arguably belongs in patch checklists too... but I figure we
should start by flushing out any contrary opinions.

 include/asm-generic/bug.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -20,6 +20,17 @@ struct bug_entry {
 #define BUGFLAG_WARNING	(1<<0)
 #endif	/* CONFIG_GENERIC_BUG */
 
+/*
+ * Don't use BUG() or BUG_ON() unless there's really no way out; one
+ * example might be detecting data structure corruption in the middle
+ * of an operation that can't be backed out of.  If the (sub)system
+ * can somehow continue operating, perhaps with reduced functionality,
+ * it's probably not BUG-worthy.
+ *
+ * If you're tempted to BUG(), think again:  is completely giving up
+ * really the *only* solution?  There are usually better options, where
+ * users don't need to reboot ASAP and can mostly shut down cleanly.
+ */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
@@ -31,6 +42,12 @@ struct bug_entry {
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
+/*
+ * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
+ * significant issues that need prompt attention if they should ever
+ * appear at runtime.  Use the versions with printk format strings
+ * to provide better diagnostics.
+ */
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_on_slowpath(const char *file, const int line);
