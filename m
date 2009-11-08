Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZKHUo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZKHUo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZKHUo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:44:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:35629 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbZKHUoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:44:25 -0500
Date: Sun, 8 Nov 2009 12:45:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] Allow threads to rename siblings via
 /proc/pid/tasks/tid/comm
Message-ID: <20091108124539.6f81d351@infradead.org>
In-Reply-To: <87aayy6j8b.fsf@basil.nowhere.org>
References: <1256347303.5059.26.camel@localhost.localdomain>
	<1257557918.3298.21.camel@localhost.localdomain>
	<87aayy6j8b.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Nov 2009 23:52:20 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> john stultz <johnstul@us.ibm.com> writes:
> > -	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
> > +
> > +	/*
> > +	 * Threads may access current->comm without holding
> > +	 * the task lock, so write the string carefully
> > +	 * to avoid non-terminating reads. Readers without a lock
> > +	 * will get the oldname, the newname or an empty string.
> > +	 */
> > +	tsk->comm[0] = 0;
> > +	wmb();
> > +	strlcpy(tsk->comm+1, buf+1, sizeof(tsk->comm)-1);
> > +	wmb();
> > +	tsk->comm[0] = buf[0];
> 
> Is this really safe? 
> 
> reader                    writer
> 
> 
> read comm[0]
>                          set comm[0] to 0
>                          overwrites comm[1]
> read comm[1]
> read comm[2]
>                          writes comm[2] to 0 
> read comm[3]
> 
> ...
> goes beyond the end
>                   
> Better way probably is to replace tsk->comm with a pointer
> and exchange that using xchg. Drawback: 4-8 bytes more per task.
> 
> Or perhaps make comm one byte longer and make sure the last
> byte is always 0, but the drawback is that a reader can
> read random (but at least safe) junk then.

another option is to memset the whole thing to 0's.
might sound like overkill, but we're talking 16 bytes here... cheap
enough to do for such a rare case.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
