Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZBIF2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZBIF2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 00:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZBIF15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 00:27:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:48307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZBIF14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 00:27:56 -0500
Date: Sun, 8 Feb 2009 21:27:48 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fastboot: keep at least one thread per cpu during boot
Message-ID: <20090208212748.4b7569b5@infradead.org>
In-Reply-To: <20090209034826.GA4768@nowhere>
References: <20090209034826.GA4768@nowhere>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 04:48:27 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Async threads are created and destroyed depending on the number of
> jobs in queue. It means that several async threads can be created for
> a specific batch of work, then the threads will die after the
> completion of this batch, but they could be needed just after this
> completion for another batch of work. During the boot, such
> repetitive thread creations can be wasteful, that's why this patch
> proposes to keep at least one thread per cpu (if they already have
> been created once). Such a threshold of threads kept alive will
> prevent from a part of the thread creation overhead. This threshold
> will be dropped one the system_state switches from SYSTEM_BOOTING to
> SYSTEM_RUNNING.

I'm not very fond of this to be honest;
at least during boot there's enough activity, and the time is so short
(that's the point of the parallel stuff!) that this will not kick in to
make a difference; specifically, every boot I've seen the number of
threads is highest near the end, and also the total kernel boot time is
below 1.5 seconds or so, not long enough for the threads to die.

Creating a thread is *CHEAP*. Really really cheap. You can do 100
thousands/second on even a modest CPU. If you have a high frequency of
events, you don't want this, sure, and that is why there is a one
second delay to give opportunity for reuse... but really....


Now, if async function calls get used more, I can see the point of
always keeping one thread alive, just for both performance and VM low
memory issues; but that's not what your patch is doing.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
