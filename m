Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0BVN2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:28:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:31639 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab0BVN2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:28:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=PpAp8cGAJpBEbDsMiHCIz5n8Om4+0povl32dHXn8nuh7MXE2FqrE3uNLvJjME59RmX
         HFxdSBgUL0UHEhHNgPo2GzF6kL0/m3G4+ERWfZNFNyoSPIYmHi91B5tOG6MsDsB+qg+t
         GL2ReDSEER5T7pLXXNxiSEgUUjOq4H0CRtb7M=
Date: Mon, 22 Feb 2010 16:27:43 +0300
From: Dan Carpenter <error27@gmail.com>
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
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [patch] latency_hist: fix small memory leak
Message-ID: <20100222132743.GB5416@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	rt-users <linux-rt-users@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
	Clark Williams <williams@redhat.com>,
	Frank Rowand <frank.rowand@am.sony.com>,
	Robin Gareus <robin@gareus.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Philippe Reynes <philippe.reynes@isismpp.fr>,
	Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
	Will Schmidt <will_schmidt@vnet.ibm.com>,
	Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
	Sven-Thorsten Dietrich <sdietrich@novell.com>,
	Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
	John Kacur <jkacur@redhat.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>
References: <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain> <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain> <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain> <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

index_ptr needs to be freed on the error path.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/trace/latency_hist.c b/kernel/trace/latency_hist.c
index b3b5ea2..8edc70c 100644
--- a/kernel/trace/latency_hist.c
+++ b/kernel/trace/latency_hist.c
@@ -204,8 +204,10 @@ static void *l_start(struct seq_file *m, loff_t *pos)
 			   , my_hist->beyond_hist_bound_samples
 			   , MAX_ENTRY_NUM, "samples");
 	}
-	if (index >= MAX_ENTRY_NUM)
+	if (index >= MAX_ENTRY_NUM) {
+		kfree(index_ptr);
 		return NULL;
+	}
 
 	*index_ptr = index;
 	return index_ptr;
