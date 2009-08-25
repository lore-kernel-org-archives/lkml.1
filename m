Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZHYOGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZHYOGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZHYOGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:06:09 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:14397 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbZHYOGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:06:08 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Subject: RE: TCP keepalive timer problem
Date: Tue, 25 Aug 2009 10:05:52 -0400
Message-ID: <0939B589FC103041945B9F13274963E303B1AD89@CORPUSMX90A.corp.emc.com>
In-Reply-To: <4A93E36C.8070502@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: TCP keepalive timer problem
Thread-Index: Acolhe2FnSIlm2wITf6a7TCnCJeWiAABA+Ow
References: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com> <4A93E36C.8070502@gmail.com>
From: <Li_Xin2@emc.com>
To: <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
X-OriginalArrivalTime: 25 Aug 2009 14:05:56.0367 (UTC) FILETIME=[2A4B39F0:01CA258D]
X-EMM-EM: Active
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Thanks for your quick reply, let me explain my problem in detail.

Suppose the client side of communication sets the keep alive socket option, connects to server, then we pulls out the network cable of server box. After the connection is idle for TCP_KEEPIDLE seconds, the first keepalive probe packet is sent, and of course no reply is received. Just after the first probe packet, the client sends some data. No response is received, and as you said, the normal retransmission takes place and no further keepalive probe will be sent. 

	The problem is: application that tries the keepalive mechanism expects communication peer crash detection within TCP_KEEPIDLE + TCP_KEEPCNT * TCP_KEEPINTVL seconds. Application may set relative smaller TCP_KEEPIDLE, TCP_KEEPCNT and TCP_KEEPINTVL value so that peer crash can be detected quickly, for example, 60 seconds. But if the keepalive is intervened with retransmission, the latter takes higher priority, so that peer crash will be detected after 13 to 30 minutes, which may not be acceptable for some applications.

We tried TCP implementation on Windows XP SP3, the keepalive and retransmission don't intervene.

Regards,
Xin Li
EMC Shanghai R&D Centre
Email: Li_Xin2@emc.com
Tel: 86 21 6095 1100 x 2257

-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: 2009Äê8ÔÂ25ÈÕ 21:13
To: Li, Xin
Cc: linux-kernel@vger.kernel.org; Linux Netdev List
Subject: Re: TCP keepalive timer problem

Li_Xin2@emc.com a ¨¦crit :
> Greetings,
> 
> I found one problem in Linux TCP keepalive timer processing, after
> searching on google, I found Daniel Stempel reported the same problem in
> 2007 (http://lkml.indiana.edu/hypermail/linux/kernel/0702.2/1136.html),
> but got no answer. So I have to reraise it.
> 
> Can anyone help answer this two-years long question?
> 
>

You should explain your problem in detail, since Daniel one was probably different.

He mentioned "(timeout is set to e.g. 30 seconds)" which is kind of nasty, given normal one is 7200

If some packets are in flight, keepalive is not fired at all, since normal
retransmits should take place (check tcp_retries2 sysctl).

TCP Keepalive is only fired when no trafic occurred for a long time, only if 
SO_KEEPALIVE socket option was enabled by application.

tcp_retries2 (integer; default: 15)
    The maximum number of times a TCP packet is retransmitted in established state
before giving up. The default value is 15, which corresponds to a duration of
approximately between 13 to 30 minutes, depending on the retransmission timeout.
The RFC 1122 specified minimum limit of 100 seconds is typically deemed too short. 


