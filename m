Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXBVOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXBVOhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030246AbXBVOhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:37:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030237AbXBVOhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:37:33 -0500
Date: Thu, 22 Feb 2007 15:31:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: johnpol@2ka.mipt.ru, arjan@infradead.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       hch@infradead.org, akpm@zip.com.au, alan@lxorguk.ukuu.org.uk,
       zach.brown@oracle.com, suparna@in.ibm.com, davidel@xmailserver.org,
       jens.axboe@oracle.com, tglx@linutronix.de
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222143145.GA3246@elte.hu>
References: <20070222113148.GA3781@2ka.mipt.ru> <1172145159.3531.253.camel@laptopd505.fenrus.org> <20070222123929.GA5208@2ka.mipt.ru> <20070222.054127.104035694.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222.054127.104035694.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.8 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> If used for networking one could easily make this new interface create 
> an arbitrary number of threads by just opening up that many 
> connections to such a server and just sitting there not reading 
> anything from any of the client sockets.  And this happens 
> non-maliciously for slow clients, whether that is due to application 
> blockage or the characteristics of the network path.

there are two issues on which i'd like to disagree.

Firstly, i dont think you are fully applying the syslet/threadlet model. 
There is no reason why an 'idle' client would have to use up a full 
thread! It all depends on how you use syslets/threadlets, and how 
(frequently) you queue back requests from cachemiss threads back to the 
primary thread. It is only the simplest queueing model where there is 
one thread per request that is currently blocked. Syslets/threadlets do 
/not/ force request processing to be performed in the async context 
forever - the async thread could very much queue it back to the primary 
context. (That's in essence what Tux did.) So the same state-machine 
techniques can be applied on both the syslet and the threadlet model, 
but in much more natural (and thus lower overhead) points: /between/ 
system calls and not in the middle of them. There are a number of 
measures that can be used to keep the number of parallel threads down.

Secondly, even assuming lots of pending requests/async-threads and a 
naive queueing model, an open request will eat up resources on the 
server no matter what. So if your point is that "+4K of kernel stack 
pinned down per open, blocked request makes syslets and threadlets not a 
very good idea", then i'd like to disagree with that: while it wont be 
zero-cost (4K does cost you 400MB of RAM per 100,000 outstanding 
threads), it's often comparable to the other RAM costs that are already 
attached to an open connection.

(let me know if i misunderstood your point.)

	Ingo
