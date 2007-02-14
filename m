Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbXBNMnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbXBNMnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932232AbXBNMnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:43:21 -0500
Received: from smtp8-g19.free.fr ([212.27.42.65]:41810 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229AbXBNMnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:43:20 -0500
Message-ID: <45D303F5.20209@yahoo.fr>
Date: Wed, 14 Feb 2007 13:43:33 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
References: <20070213142035.GF638@elte.hu>
In-Reply-To: <20070213142035.GF638@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------000408090606040406060005"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000408090606040406060005
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Ingo Molnar a écrit :
> +	if (unlikely(signal_pending(t) || need_resched()))
> +		goto stop;
>   

So, this is how you'll prevent me from running an infinite loop ;-)
The attached patch adds a cond_resched() instead, to allow infinite
loops without DoS. I dropped the unlikely() as it's already in the
definition of signal_pending().

> +asmlinkage long sys_async_wait(unsigned long min_wait_events)
>   

Here I would expect:

    sys_async_wait_for_all(struct syslet_atom *atoms, long nr_atoms)

and

    sys_async_wait_for_any(struct syslet_atom *atoms, long nr_atoms).

This way syslets can be used by different parts of a program without
having them waiting for each other.

Thanks.

-- 
Guillaume


--------------000408090606040406060005
Content-Type: text/x-patch;
 name="cond_resched.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cond_resched.diff"

--- linux-2.6/kernel/async.c
+++ linux-2.6/kernel/async.c
@@ -433,9 +433,10 @@
 
 	last_uatom = uatom;
 	ret = __exec_atom(t, &atom);
-	if (unlikely(signal_pending(t) || need_resched()))
+	if (signal_pending(t))
 		goto stop;
 
+	cond_resched();
 	uatom = next_uatom(&atom, uatom, ret);
 	if (uatom)
 		goto run_next;




--------------000408090606040406060005--
