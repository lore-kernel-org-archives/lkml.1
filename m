Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbZBKPzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbZBKPzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZBKPzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:55:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:44318 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZBKPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:55:01 -0500
Subject: Re: [PATCH -v3] futex: fix reference leak
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090211154952.GB24408@elte.hu>
References: <1234190649.16083.44.camel@pc1117.cambridge.arm.com>
	 <1234192363.5951.129.camel@laptop> <1234197950.5951.132.camel@laptop>
	 <1234198023.5951.133.camel@laptop>
	 <1234200538.16083.52.camel@pc1117.cambridge.arm.com>
	 <1234203975.5951.143.camel@laptop>
	 <1234205595.4286.223.camel@localhost.localdomain>
	 <1234205874.5951.151.camel@laptop> <20090211122849.GD16535@elte.hu>
	 <1234366605.23438.179.camel@twins>  <20090211154952.GB24408@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Feb 2009 16:56:42 +0100
Message-Id: <1234367802.23438.183.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 16:49 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > So you prefer this version?
> 
> yes, with s/out_unlock_put_key/err_unlock_put_key. That's the
> only error path that goes via the tail of the function, correct?

Right, but I think one can argue that most of the out* jumps are errors.

The only non-error return is the !unqueue_me() case.

Also, since there's only one user of out_unlock_put_key, we might also
do this:

---
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1220,8 +1220,10 @@ retry:
 		goto out;
 	}
 	ret = -EWOULDBLOCK;
-	if (uval != val)
-		goto out_unlock_put_key;
+	if (uval != val) {
+		queue_unlock(&q, hb);
+		goto out_put_key;
+	}
 
 	/* Only actually queue if *uaddr contained val.  */
 	queue_me(&q, hb);
@@ -1319,10 +1321,6 @@ out_put_key:
 	put_futex_key(fshared, &q.key);
 out:
 	return ret;
-
-out_unlock_put_key:
-	queue_unlock(&q, hb);
-	goto out_put_key;
 }
 
 

