Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbZDUBs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbZDUBs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZDUBsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:48:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:30782 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZDUBsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=pEZOpN97EHUNGDggm4jESGCtmObO3kOz4OiSQl34ouGGcAp4+r5ukfd07BUpG8cjyu
         qUfxzF8IKVvixl7SnBoFZnjIn7tVFVgvg0MTC+dJJ14G4vsu87srqC7CvLvdlwyB6HcE
         rmlachE6K/epON34X7VUkX7t9amgAyxrbV6tk=
Subject: [BUG] 2.6.29.1-rt8, undefined reference to hrtimer_wait_for_timer
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
In-Reply-To: <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 21 Apr 2009 09:47:40 +0800
Message-Id: <1240278460.27360.8.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when using patch-2.6.29.1-rt8 with CONFIG_PREEMPT_SOFTIRQS=y, but not
enable PREEMPT_RT, there will be an error when linking kernel:

undefined reference to hrtimer_wait_for_timer

I found that, hrtimer_wait_for_timer is only defined when PREEMPT_RT is
enabled, but in include/linux/hrtimer.h, the source code is like this:

#ifdef CONFIG_PREEMPT_SOFTIRQS
 extern void hrtimer_wait_for_timer(const struct hrtimer *timer);
#else
# define hrtimer_wait_for_timer(timer) do { cpu_relax(); } while (0)

a possible fix should be:

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 8bafa35..1c1cdf3 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -366,7 +366,7 @@ static inline int hrtimer_restart(struct hrtimer
*timer)
 }
 
 /* Softirq preemption could deadlock timer removal */
-#ifdef CONFIG_PREEMPT_SOFTIRQS
+#if defined(CONFIG_PREEMPT_SOFTIRQS) && defined(CONFIG_PREEMPT_RT)
   extern void hrtimer_wait_for_timer(const struct hrtimer *timer);
 #else
 # define hrtimer_wait_for_timer(timer) do { cpu_relax(); } while (0)

-- 
Wu Zhangjin
DSLab, Lanzhou University, China
www.lemote.com, Jiangsu Province, China

