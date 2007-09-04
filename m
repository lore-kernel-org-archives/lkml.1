Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbXIDOCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbXIDOCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 10:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbXIDOCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 10:02:40 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64338 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbXIDOCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 10:02:39 -0400
To: paul.moore@hp.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 15/15] LSM expansion for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <46CED214.6050505@gmail.com>
	<200708280921.48867.paul.moore@hp.com>
	<200709032215.DCF36819.SLQtHFMFOOFOVJ@I-love.SAKURA.ne.jp>
	<200709040753.32204.paul.moore@hp.com>
In-Reply-To: <200709040753.32204.paul.moore@hp.com>
Message-Id: <200709042302.CDE26023.MJOOLQVFFOtHSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Tue, 4 Sep 2007 23:02:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for your comment.

Hmm, I can't understand why I have to perform access control at "enqueue" time.

What I want to do is
  allow process1 receive UDP packets from 10.0.0.1 port 1024
  allow process2 receive UDP packets from 10.0.0.2 port 2048
when there is no guarantee that process1 and process2 are not sharing a socket.

If there is guarantee that process1 and process2 are not sharing a socket,
I can do it using netfilter.

My case is that process1 and process2 might share a socket
but allow administrator give process1 and process2 different region of interests.

> As mentioned before that problem with enforcing access control at "dequeue" 
> time is that the system has already accepted the packet from the remote 
> host - how do you plan to deal with these unacceptable/bad packets sitting on 
> a socket, waiting to be read by a process which does not have access to them?  
Just drop unacceptable/bad packet when a process attempted to pick up a packet
that is not region of interest for the process;
with a price of being unable to pick up packets that are region of interest
for other process that are sharing that socket.
But processes that administrator gives different region of interests
seldom shares a socket, the administrator seldom pays this price.

> What about connection oriented sockets where the remote host will assume 
> everything is okay and continue blasting the machine with more, illegal 
> packets?  If you aren't going to allow the socket/application to read the 
> packet, never allow the system to accept it in the first place.
I don't plan to drop connection oriented socket's packets at skb_recv_datagram().
TOMOYO Linux drops UDP or RAW packet at skb_recv_datagram()
and disconnects TCP connection at socket_post_accept().
In both cases, no uninterested data is picked up by userland process.

Sockets deliver packets between two host's kernel space,
but have no concern about delivered packets has been picked up.
It is sender process's business to verify that
receiver process has successfully picked up packets
which sender process has sent.

> The *preferable* solution, as previously stated before by several people, is 
> to investigate other access control methods like the netfilter userspace 
> queue mechanism.  At the very least, please explain how the approaches we 
> proposed will not accomplish what you require.
According to Patrick McHardy's posting at
http://www.mail-archive.com/linux-security-module@vger.kernel.org/msg00999.html
netfilter *socket filters* cannot know final recipient process.
Can netfilter *userspace queue mechanism* know final recipient process?

Regards.
