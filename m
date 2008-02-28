Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbYB1TXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbYB1TXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbYB1TXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:23:24 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42308 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbYB1TXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:23:23 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 28 Feb 2008 11:23:21 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: =?X-UNKNOWN?Q?Chris_=22=A5=AF=22_Heath?= <chris@heathens.co.nz>,
       David Schwartz <davids@webmaster.com>, dada1@cosmosbay.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
Subject: Re: epoll design problems with common fork/exec patterns
In-Reply-To: <cfd18e0f0802280512q43a457d0sc9a8dc83c51e8e1c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802281106050.7660@alien.or.mcafeemobile.com>
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com> 
 <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com> 
 <47C42CA7.4030607@gmail.com>  <Pine.LNX.4.64.0802261049040.27243@alien.or.mcafeemobile.com>
  <1204075804.5238.7.camel@linux.heathens.co.nz> 
 <Pine.LNX.4.64.0802271131180.377@alien.or.mcafeemobile.com>
 <cfd18e0f0802280512q43a457d0sc9a8dc83c51e8e1c@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Michael Kerrisk wrote:

> But it is an ugly inconsistency.  On the one hand, a child process
> cannot add the duplicate file descriptor to the epoll set.  (In every
> other case that I can think of , descriptors duplicated by fork have
> similar semantics to descriptors duplicated by dup() and friends.)  On
> the other hand, the very fact that the child has a duplicate of the
> descriptor means that even if the parent closes its descriptor, then
> epoll_wait() in the parent will continue to receive notifications for
> that descriptor because of the duplicated descriptor in the child.

Have you ever tried to think what it means for different *processes* 
sharing a single epoll fd and doing epoll_wait() over it?
Most common case is a single event fetch thread plus dispatch. Going to 
epoll_wait() over a single epoll fd from many *threads* is very much 
possible, but requires care (news at 11, system software development 
requires care too).
Sharing a single epoll fd (by the means of any process sharing it doing 
add/wait) from different *processes* makes almost no sense at all.
"a child process cannot add the duplicate file descriptor to the epoll 
set" ... how do you expect the parent (that doesn't even have the new fd 
mapped) to react to such events?
If the next question is "But then why we made the epoll fd inheritable?", 
the answer is, because it makes sense in many cases for a parent to hand 
over an fd set to a child.



> The choice of [file *, fd] as the key for epoll sets really does seem
> unfortunate.  Keying on [pid, fd] would have given saner semantics, it
> seems to me.  Obviously it can't be changed now though.

I think we already went over this, and I think I clearly explained you the 
reasons of not hooking into sys_close.



- Davide


