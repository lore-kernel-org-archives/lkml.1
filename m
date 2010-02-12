Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0BLN4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 08:56:35 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:55610 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab0BLN4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 08:56:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vMn8+tX9Xp6oPSt5h/URTnOxhHxrUSE2f7nOrN1Ge8mV++tXP+jlB9E+04YWedPazl
         osHY2P4itEyEiWdJlaLTDb6lv4nfdc82vtqtDnwOSPociB2J48S+8saliLsuRN6MVd4T
         5G8ciuka7AjJ9bqGzBNu4GsAGVpTFGoHlAoe4=
Subject: Re: [patch 4/7 -mm] oom: badness heuristic rewrite
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002100228540.8001@chino.kir.corp.google.com>
	 <4B73833D.5070008@redhat.com>
	 <alpine.DEB.2.00.1002102332200.22152@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 22:56:24 +0900
Message-ID: <1265982984.6207.29.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David. 

On Thu, 2010-02-11 at 01:14 -0800, David Rientjes wrote:
> > > +/*
> > > + * Tasks that fork a very large number of children with seperate address
> > > spaces
> > > + * may be the result of a bug, user error, or a malicious application.  The
> > > oom
> > > + * killer assesses a penalty equaling
> > 
> > It could also be the result of the system getting many client
> > connections - think of overloaded mail, web or database servers.
> > 
> 
> True, that's a great example of why child tasks should be sacrificed for 
> the parent: if the oom killer is being called then we are truly overloaded 
> and there's no shame in killing excessive client connections to recover, 
> otherwise we might find the entire server becoming unresponsive.  The user 
> can easily tune to /proc/sys/vm/oom_forkbomb_thres to define what 
> "excessive" is to assess the penalty, if any.  I'll add that to the 
> comment if we require a second revision.
> 

I am worried about opposite case.

If forkbomb parent makes so many children in a short time(ex, 2000 per
second) continuously and we kill a child continuously not parent, system
is almost unresponsible, I think.  
I suffered from that case in LTP and no swap system.
It might be a corner case but might happen in real. 

I think we could have two types of forkbomb. 

Normal forkbomb : apache, DB server and so on. 
Buggy forkbomb: It's mistake of user. 

We can control normal forkbomb by oom_forkbomb_thres.
But how about handling buggy forkbomb?

If we make sure this task is buggy forkbomb, it would be better to kill
it. But it's hard to make sure it's a buggy forkbomb.

Could we solve this problem by following as?
If OOM selects victim and then the one was selected victim right before
and it's repeatable 5 times for example, then we kill the victim(buggy
forkbom) itself not child of one. It is assumed normal forkbomb is
controlled by admin who uses oom_forkbomb_thres well. So it doesn't
happen selecting victim continuously above five time.


-- 
Kind regards,
Minchan Kim


