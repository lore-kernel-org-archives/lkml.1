Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYJZWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYJZWs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 18:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYJZWsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 18:48:47 -0400
Received: from web56305.mail.re3.yahoo.com ([216.252.110.229]:41457 "HELO
	web56305.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752738AbYJZWsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 18:48:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=d+zcAVLKgBaBrNsyxW3yaY/egIJ0g4oGY6Jn2eDneQAQ1U9OxzYxZ/zouxiNGc3Hg7QLiYnAE1YpEIO3HnD1mDlb4BduhHUyWDZ+/saLxaMRjvZAtOMHkHk8GW8PZ5Xf+JZlaeyCEvAXJ7Z4mHMDy5oqSq9V8yfhc9wVO9gkMxM=;
X-YMail-OSG: SmdGaeMVM1nPdj1KB4IV74XObXPeqaTER6Og1xGRQS3TG8ZdI9s2YS.DDnBFaXD71QblYU8HuC5Tb6rIopdeHk0O9NooJp5V6oZoj7c1JT9LZWPLJS5lRLnGm61ij6sWPROGrmISjfoQwqRT7XZW1ni4Vqmx3sxqNWqBP7Q-
X-Mailer: YahooMailWebService/0.7.247.3
Date: Sun, 26 Oct 2008 15:48:45 -0700 (PDT)
From: Paul P <ppak_98@yahoo.com>
Reply-To: ppak_98@yahoo.com
Subject: Re: unexpected extra pollout events from epoll
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810261452221.19212@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <99943.65323.qm@web56305.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After that, via epoll_wait(), f_op->poll() is called to get the status of  the file, and since POLLIN|POLLOUT is returned (and since you're listening for EPOLLIN|EPOLLOUT), that gets reported back to you. The POLLOUT event, by meaning a buffer-full->buffer-avail transition, did not really happen, but since POLLOUT is true, that gets reported back too.

Ok, so make sure I understand you correctly, you're saying that currently the kernel doesn't have awareness of the difference between EPOLLIN and EPOLLOUT events because at the time of the event, both EPOLLIN/EPOLLOUT are returned from the kernel and that at least for the near term that's not going to change.  At some point, we can expect the EPOLLOUT to give the correct event, but not till later than .28.

> The best way to do it ATM, is to wait for POLLOUT only when
> really needed.

I'm a little unclear how to do this.  If I set the epoll_wait call to wait for just epollin events, that's fine.  But when I send a large buffer of data and use epoll_ctl to look for epollin|epollout events, don't I have the same problem?  

Let's say I'm sending a large buffer of data and I arm the fd to epollin|epollout (I'm adding an epollin flag because a message could come in while I'm sending)

If an event gets triggered on an fd, then I have no way of knowing if the event is from the socket being available to send data or if there is data waiting to be received since the epollin|epollout flag could be either one.  So what am I to do when I get an event?

Are you saying that I can't do sending and receiving simultaneously with epoll?  If that's the case, then is everyone simply setting the epollout flag when sending and ignoring the possibility of data coming in while data is being sent?

I didn't want to have to manually set fd's with epoll_ctl, but now I guess the epoll_one_shot flag makes more sense.  

Paul


      
