Return-Path: <linux-kernel-owner+w=401wt.eu-S1752422AbXJADP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbXJADP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 23:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXJADPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 23:15:19 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:46169 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbXJADPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 23:15:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 30 Sep 2007 20:15:10 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
In-Reply-To: <200710010058.49242.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0709301709490.19355@alien.or.mcafeemobile.com>
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
 <200709300131.49320.vda.linux@googlemail.com>
 <Pine.LNX.4.64.0709301605340.19355@alien.or.mcafeemobile.com>
 <200710010058.49242.vda.linux@googlemail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Denys Vlasenko wrote:

> My use case is: I want to do a nonblocking read on descriptor 0 (stdin).
> It may be a pipe or a socket.
> 
> There may be other processes which share this descriptor with me,
> I simply cannot know that. And they, too, may want to do reads on it.
> 
> I want to do nonblocking read in such a way that neither those other
> processes will ever see fd switching to O_NONBLOCK and back, and
> I also want to be safe from other processes doing the same.
> 
> I don't see how this can be done using standard unix primitives.

Indeed. You could simulate non-blocking using poll with zero timeout, but 
if another task may read/write on it, your following read/write may end up 
blocking even after a poll returned the required events.
One way to solve this would be some sort of readx/writex where you pass an 
extra flags parameter (this could be done with sys_indirect, assuming 
we'll ever get that mainline) where you specify the non-blocking 
requirement for-this-call, and not as global per-file flag. Then, of 
course, you'll have to modify all the "file->f_flags & O_NONBLOCK" tests 
(and there are many of them) to check for that flag too (that can be a 
per task_struct flag).



- Davide


