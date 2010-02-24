Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0BXHVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:21:04 -0500
Received: from toro.web-alm.net ([62.245.132.31]:45064 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab0BXHVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:21:00 -0500
Message-ID: <4B84D20B.9080600@osadl.org>
Date: Wed, 24 Feb 2010 08:15:23 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
References: <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain> <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain> <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain> <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain> <20100222132927.GC5416@bicker>
In-Reply-To: <20100222132927.GC5416@bicker>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------070709000706030204010109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070709000706030204010109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 02/22/2010 02:29 PM, Dan Carpenter wrote:
> kernel/trace/latency_hist.c
>    373  static ssize_t
>    374  latency_hist_show_maxlatproc(struct file *filp, char __user *ubuf,
>    375                        size_t cnt, loff_t *ppos)
>    376  {
>    377          char buf[1024];
> 
> This is a large buffer to put on the stack.
Thanks!

Remove stack allocation of buffer space, use dyn memory instead.
Use a better assumption to estimate the required buffer space.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>


--------------070709000706030204010109
Content-Type: text/x-patch;
 name="histogram-maxlatproc-use-dyn-mem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="histogram-maxlatproc-use-dyn-mem.patch"

Subject: histogram-maxlatproc-use-dyn-mem.patch
From: Carsten Emde <C.Emde@osadl.org>
Date: Wed, 24 Feb 2010 07:49:33 +0100

Remove stack allocation of buffer space, use dyn memory instead.
Use a better assumption to estimate the required buffer space. 

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>

Index: head/kernel/trace/latency_hist.c
===================================================================
--- head.orig/kernel/trace/latency_hist.c
+++ head/kernel/trace/latency_hist.c
@@ -442,13 +442,19 @@ static ssize_t do_pid(struct file *file,
 static ssize_t
 show_maxlatproc(struct file *file, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
-	char buf[1024];
 	int r;
 	struct maxlatproc_data *mp = file->private_data;
+	int strmaxlen = TASK_COMM_LEN + 32;
+	char *buf = kmalloc(strmaxlen, GFP_KERNEL);
 
-	r = snprintf(buf, sizeof(buf), "%d %d %ld %s\n",
+	if (buf == NULL)
+		return -ENOMEM;
+
+	r = snprintf(buf, strmaxlen, "%d %d %ld %s\n",
 	    mp->pid, MAX_RT_PRIO-1 - mp->prio, mp->latency, mp->comm);
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	kfree(buf);
+	return r;
 }
 #endif
 

--------------070709000706030204010109--
