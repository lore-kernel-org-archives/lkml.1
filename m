Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZKGWwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZKGWwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZKGWwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:52:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48746 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZKGWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:52:16 -0500
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] Allow threads to rename siblings via /proc/pid/tasks/tid/comm
From: Andi Kleen <andi@firstfloor.org>
References: <1256347303.5059.26.camel@localhost.localdomain>
	<1257557918.3298.21.camel@localhost.localdomain>
Date: Sat, 07 Nov 2009 23:52:20 +0100
In-Reply-To: <1257557918.3298.21.camel@localhost.localdomain> (john stultz's message of "Fri, 06 Nov 2009 17:38:38 -0800")
Message-ID: <87aayy6j8b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> writes:
> -	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
> +
> +	/*
> +	 * Threads may access current->comm without holding
> +	 * the task lock, so write the string carefully
> +	 * to avoid non-terminating reads. Readers without a lock
> +	 * will get the oldname, the newname or an empty string.
> +	 */
> +	tsk->comm[0] = 0;
> +	wmb();
> +	strlcpy(tsk->comm+1, buf+1, sizeof(tsk->comm)-1);
> +	wmb();
> +	tsk->comm[0] = buf[0];

Is this really safe? 

reader                    writer


read comm[0]
                         set comm[0] to 0
                         overwrites comm[1]
read comm[1]
read comm[2]
                         writes comm[2] to 0 
read comm[3]

...
goes beyond the end
                  
Better way probably is to replace tsk->comm with a pointer
and exchange that using xchg. Drawback: 4-8 bytes more per task.

Or perhaps make comm one byte longer and make sure the last
byte is always 0, but the drawback is that a reader can
read random (but at least safe) junk then.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
