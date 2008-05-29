Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYE2Nsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYE2Nsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYE2Ns0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:48:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44327 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbYE2NsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:48:24 -0400
Date: Thu, 29 May 2008 16:48:22 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
In-Reply-To: <20080529130823.GA8364@elte.hu>
Message-ID: <Pine.LNX.4.64.0805291612150.16829@wrl-59.cs.helsinki.fi>
References: <20080526115628.GA31316@elte.hu> <20080529084524.GA24892@elte.hu>
 <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi> <20080529112257.GA18130@elte.hu>
 <20080529130823.GA8364@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Ingo Molnar wrote:

> btw., i now also have a hung socket over real network:
> 
> titan:~> netstat -nt
> Active Internet connections (w/o servers)
> Proto Recv-Q Send-Q Local Address               Foreign Address             State
> tcp        0  86752 10.0.1.14:49921             10.0.1.16:3632              ESTABLISHED
> 
> (the scenario is similar to the incident i've analyzed before, so i wont 
> repeat the tcpdump, etc.)

...Yes, also the previous one you quoted was already over the network.
But I think the key is in the receiving end rather than in the sending 
end. Could try to extract any information about these I mentioned earlier,
to me there are mainly two weird things:

1) Why we see orphaning with data in the first place. I think distcc would 
be interested to read everything, unless some worker crashed in early...
Though some timeout in distcc could explain it as well but I don't know 
too well how distcc does everything...

2) Why the receiving end of the connection is still in ESTABLISHED 
without an owner... If it had some unread data, should be in CLOSE or in 
FIN_WAIT1 otherwise. Ie., tcp_close() would change the state of the flow.

These both basically happen at the receiving end, though if there was 
unread data the RST would also reflected state change to the sending side 
and since there's window, also FIN would be sent right away and 
cause sender to leave ESTABLISHED rather than that FIN would get stuck 
into the tail of the TCP queue.

How to collect the information, I'm not too sure, tcp_close might well 
work as a plain printk because I think it shouldn't be that noisy. But 
that would likely just show that it wasn't called for a stuck receiver
at all, so it would probably end up being a dead-end anyway.

-- 
 i.
