Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXIDM1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXIDM1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 08:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXIDM1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 08:27:13 -0400
Received: from smtp.cce.hp.com ([161.114.21.25]:27403 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbXIDM1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 08:27:11 -0400
X-Greylist: delayed 2010 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2007 08:27:11 EDT
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [TOMOYO 15/15] LSM expansion for TOMOYO Linux.
Date: Tue, 4 Sep 2007 07:53:31 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
References: <46CED214.6050505@gmail.com> <200708280921.48867.paul.moore@hp.com> <200709032215.DCF36819.SLQtHFMFOOFOVJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200709032215.DCF36819.SLQtHFMFOOFOVJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709040753.32204.paul.moore@hp.com>
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.9.4.42925
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 9:15:27 am Tetsuo Handa wrote:
> Hello.

Hi.

> Paul Moore wrote:
> > I apologize for not recognizing your approach from our earlier discussion
> > on the LSM mailing list in July.  Unfortunately, I have the same
> > objections to these changes that I did back then and from what I can
> > recall of the discussion the rest of the kernel networking community
> > agreed that these changes are not the preferred way of solving this
> > problem.  We offered suggestions on how to accomplish your goals in a way
> > that would be acceptable upstream and I would encourage you to
> > investigate those options further.
>
> When I proposed a patch in July, I was patching at post-copy_to_user() step
> (i.e. after sock_recvmsg()).
> This approach messed up user-supplied buffer.
>
> This time, I'm patching at pre-copy_to_user() step
> (i.e. at skb_recv_datagram()).
> This approach doesn't mess up user-supplied buffer.
> I think this is a cleaner way than the previous patch.

It might be cleaner than your previous patch but it ignores some of the more 
important points that were brought up by the community in previous 
discussions.

> Although read() gets an error when select() said "read ready",
> I can't find other place to use for accomplishing my goals.
>
> By the way, similar thing can happen when select() against
> a file descriptor said "read ready" but read() gets an error
> if security policy or security-id of the file has changed
> between select() and read(), isn't it?
> And such behavior is acceptable, isn't it?
> If such behavior can happen and is acceptable and *preferable*,
> I think checking permission at dequeue time (i.e. skb_recv_datagram())
> is *preferable* way than checking permission at enqueue time
> (i.e. socket_sock_rcv_skb()).

As mentioned before that problem with enforcing access control at "dequeue" 
time is that the system has already accepted the packet from the remote 
host - how do you plan to deal with these unacceptable/bad packets sitting on 
a socket, waiting to be read by a process which does not have access to them?  
What about connection oriented sockets where the remote host will assume 
everything is okay and continue blasting the machine with more, illegal 
packets?  If you aren't going to allow the socket/application to read the 
packet, never allow the system to accept it in the first place.

The *preferable* solution, as previously stated before by several people, is 
to investigate other access control methods like the netfilter userspace 
queue mechanism.  At the very least, please explain how the approaches we 
proposed will not accomplish what you require.

-- 
paul moore
linux security @ hp
