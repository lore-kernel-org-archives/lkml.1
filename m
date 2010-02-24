Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0BXHLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:11:11 -0500
Received: from toro.web-alm.net ([62.245.132.31]:44973 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab0BXHLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:11:09 -0500
Message-ID: <4B84CFCB.4010001@osadl.org>
Date: Wed, 24 Feb 2010 08:05:47 +0100
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
Subject: Re: [patch] latency_hist: fix small memory leak
References: <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain> <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain> <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain> <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain> <20100222132743.GB5416@bicker>
In-Reply-To: <20100222132743.GB5416@bicker>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 02:27 PM, Dan Carpenter wrote:
> index_ptr needs to be freed on the error path.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/kernel/trace/latency_hist.c b/kernel/trace/latency_hist.c
> index b3b5ea2..8edc70c 100644
> --- a/kernel/trace/latency_hist.c
> +++ b/kernel/trace/latency_hist.c
> @@ -204,8 +204,10 @@ static void *l_start(struct seq_file *m, loff_t *pos)
>  			   , my_hist->beyond_hist_bound_samples
>  			   , MAX_ENTRY_NUM, "samples");
>  	}
> -	if (index >= MAX_ENTRY_NUM)
> +	if (index >= MAX_ENTRY_NUM) {
> +		kfree(index_ptr);
>  		return NULL;
> +	}
>  
>  	*index_ptr = index;
>  	return index_ptr;
Thanks a lot for spotting this leak. We even don't need to allocate the
memory, if index >= MAX_ENTRY_NUM.

This patch applies to 2.6.31.12-rt21 and 2.6.33-rc8-rt (rt/head).

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

Index: head/kernel/trace/latency_hist.c
===================================================================
--- head.orig/kernel/trace/latency_hist.c
+++ head/kernel/trace/latency_hist.c
@@ -218,13 +218,10 @@ void notrace latency_hist(int latency_ty

 static void *l_start(struct seq_file *m, loff_t *pos)
 {
-	loff_t *index_ptr = kmalloc(sizeof(loff_t), GFP_KERNEL);
+	loff_t *index_ptr = NULL;
 	loff_t index = *pos;
 	struct hist_data *my_hist = m->private;

-	if (!index_ptr)
-		return NULL;
-
 	if (index == 0) {
 		char minstr[32], avgstr[32], maxstr[32];

@@ -263,10 +260,12 @@ static void *l_start(struct seq_file *m,
 			   MAX_ENTRY_NUM - my_hist->offset,
 			   "samples");
 	}
-	if (index >= MAX_ENTRY_NUM)
-		return NULL;
+	if (index < MAX_ENTRY_NUM) {
+		index_ptr = kmalloc(sizeof(loff_t), GFP_KERNEL);
+		if (index_ptr)
+			*index_ptr = index;
+	}

-	*index_ptr = index;
 	return index_ptr;
 }

