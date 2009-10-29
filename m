Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZJ2Txy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZJ2Txy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZJ2Txx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:53:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZJ2Txx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:53:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BN5jKHEsWq8W090IePxvIedIQbegDSHT9k3Xb9HkmbM9VVSklHpHxmUuolOhYUs0j
	xG1PGyPDUWd/n4KIbsLKQ==
Date: Thu, 29 Oct 2009 12:53:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vedran.furac@gmail.com
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <4AE97861.1070902@gmail.com>
Message-ID: <alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com> <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com> <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com>
 <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com> <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com> <20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com> <4AE97861.1070902@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Vedran Furac wrote:

> But then you should rename OOM killer to TRIPK:
> Totally Random Innocent Process Killer
> 

The randomness here is the order of the child list when the oom killer 
selects a task, based on the badness score, and then tries to kill a child 
with a different mm before the parent.

The problem you identified in http://pastebin.com/f3f9674a0, however, is a 
forkbomb issue where the badness score should never have been so high for 
kdeinit4 compared to "test".  That's directly proportional to adding the 
scores of all disjoint child total_vm values into the badness score for 
the parent and then killing the children instead.

That's the problem, not using total_vm as a baseline.  Replacing that with 
rss is not going to solve the issue and reducing the user's ability to 
specify a rough oom priority from userspace is simply not an option.

> If you have OOM situation and Xorg is the first, that means it's leaking
> memory badly and the system is probably already frozen/FUBAR. Killing
> krunner in that situation wouldn't do any good. From a user perspective,
> nothing changes, system is still FUBAR and (s)he would probably reboot
> cursing linux in the process.
> 

It depends on what you're running, we need to be able to have the option 
of protecting very large tasks on production servers.  Imagine if "test" 
here is actually a critical application that we need to protect, its 
not solely mlocked anonymous memory, but still kill if it is leaking 
memory beyond your approximate 2.5GB.  How do you do that when using rss 
as the baseline?
