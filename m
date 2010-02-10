Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab0BJUyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:54:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:47472 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab0BJUyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:54:44 -0500
From: Lubos Lunak <l.lunak@suse.cz>
To: David Rientjes <rientjes@google.com>
Subject: Re: Improving OOM killer
Date: Wed, 10 Feb 2010 21:54:43 +0100
User-Agent: KMail/1.9.10
Cc: Rik van Riel <riel@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
References: <201002012302.37380.l.lunak@suse.cz> <4B6B4500.3010603@redhat.com> <alpine.DEB.2.00.1002041410300.16391@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002041410300.16391@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002102154.43231.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 of February 2010, David Rientjes wrote:
> On Thu, 4 Feb 2010, Rik van Riel wrote:
> > The goal of the OOM killer is to kill some process, so the
> > system can continue running and automatically become available
> > again for whatever workload the system was running.
> >
> > Killing the parent process of one of the system daemons does
> > not achieve that goal, because you now caused a service to no
> > longer be available.
>
> The system daemon wouldn't be killed, though.  You're right that this
> heuristic would prefer the system daemon slightly more as a result of the
> forkbomb penalty, but the oom killer always attempts to sacrifice a child
> with a seperate mm before killing the selected task.  Since the forkbomb
> heuristic only adds up those children with seperate mms, we're guaranteed
> to not kill the daemon itself.

 Which however can mean that not killing this system daemon will be traded for 
DoS-ing the whole system, if the daemon keeps spawning new children as soon 
as the OOM killer frees up resources for them.

 This looks like wrong solution to me, it's like trying to save a target by 
shooting all incoming bombs instead of shooting the bomber. If the OOM 
situation is caused by one or a limited number of its children, or if the 
system daemon is not reponsible for the forkbomb (e.g. it's only a subtree of 
its children), then it won't be selected for killing anyway. If it is 
responsible for the forkbomb, the OOM killer can trying killing the bombs 
forever to no avail.

-- 
 Lubos Lunak
 openSUSE Boosters team, KDE developer
 l.lunak@suse.cz , l.lunak@kde.org
