Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYCQQn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYCQQn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYCQQnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:43:49 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:59169 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYCQQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:43:48 -0400
Message-ID: <47DE9FB0.5030801@alcatel-lucent.com>
Date: Mon, 17 Mar 2008 11:43:28 -0500
From: Nebojsa Miljanovic <neb@alcatel-lucent.com>
Organization: Lucent Technologies
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.0.1) Gecko/20020823 Netscape/7.0 (CK-LucentTPES)
X-Accept-Language: sr, hr, en, zh, zh-cn, zh-hk, z
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org,
       "Kittlitz, Edward (Ned)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William (Bart)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
References: <47C6FA2A.5030302@alcatel-lucent.com>	<20080228201926.558c4e7c@core>	<47D97DF7.8000702@alcatel-lucent.com> <20080315133426.1f48c99c@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,
thanks. With that additional INFO, I was able to find detailed description of
this denial of service attack (attached below).
Just to clarify. Having this port re-use check prevents folks from launching
this attack as opposed to being victim of it?


2.4 Simultaneous Connections
Occasionally, it is possible that hosts XX and YY both wish to establish a
connection and both of them simultaneously initiate the handshake.  This is
called simultaneous connection establishment [RFC 793]. Both hosts XX and YY
send out SYN's to each other. When the SYN's are received, each receiver sends
out a SYN+ACK. Both hosts XX and YY must detect that the SYN and SYN+ACK
actually refer to the same connection. If both hosts XX and YY detect that the
SYN+ACK belongs to the SYN that was recently sent, they switch off the
connection establishment timer and move directly to the SYN_RECVD state. This
flaw could be used to stall a port on a host, using protocols such as FTP where
the server initiates a connection to the client.

As an example, consider (malicious) host XX which has started an (active) FTP
connection to a server YY. XX and YY are connected using the control-port (21 on
YY). YY initiates the connection establishment procedure to initiate data
transfer with XX.

YY sends a SYN to XX, and makes a transition to SYN_SENT state. YY also starts
the connection establishment timer.
XX receives the SYN, and responds with another SYN.
When YY receives the SYN, it assumes that this is a case of a simultaneous open
connection. So, it sends out SYN_ACK to XX, switches off the connection
establishment timer, and transitions to the state SYN_RCVD.
XX receives the SYN_ACK from YY, but does not send a reply.
Since YY is expecting a SYN_ACK in the SYN_RCVD state, and there is no timer, YY
gets stalled in SYN_RCVD state.
XX was able to create a denial-of-service attack.


Neb


On 3/15/2008 8:34 AM, Alan Cox wrote:
> On Thu, 13 Mar 2008 14:18:15 -0500
> Nebojsa Miljanovic <neb@alcatel-lucent.com> wrote:
> 
> 
>>Alan,
>>I would appreciate it if you could elaborate on the security issue. Can you
>>describe the simultaneous connect scenario?
>>
>>We have a system we are migrating to Linux from Lynx. We have always had the
>>ability to re-use ports. We are wondering if this security issue is something we
>>should take seriously. Or, maybe it is not likely to be seen with our system
>>running well defined set of applications (i.e. not a PC where anybody could run
>>anything).
> 
> 
> See RFC 793. It is permissible for a connection to be created between two
> end points both making a connection (crossing SYN frames are both
> acked). Thus if you allow such reuse it is possible (although usually
> very very hard) to mount a timing based attack.
> 
> It's not a very practical attack in most scenarios so we block it out of
> correctness and concerns for completely robust and proper behaviour
> rather than because it is seen in the wild.
> 
> Alan


