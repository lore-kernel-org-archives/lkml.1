Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815Ab0ALTiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0ALTiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778Ab0ALTiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:38:06 -0500
Received: from server109h.appriver.com ([72.32.253.92]:2548 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754721Ab0ALTiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:38:05 -0500
X-Policy: GLOBAL - intcomgrp.com
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G113 G114 G115 G116 G120 G121 G132 G219 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: arm: Optimization for ethernet MAC handling at91_ether.c
Date: Tue, 12 Jan 2010 14:39:43 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD367402897428@MAILSRV.intcomgrp.com>
In-Reply-To: <4B4CCC7B.8040609@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: arm: Optimization for ethernet MAC handling at91_ether.c
Thread-Index: AcqTvSYnsqXGpyumS4KDf5cw0FCxngAAMOfA
References: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com> <4B4CA4E5.7030800@gmail.com> <3DBBD805E3BA064A87F551C0E8BD36740289740E@MAILSRV.intcomgrp.com> <4B4CBA93.4090909@gmail.com> <3DBBD805E3BA064A87F551C0E8BD367402897418@MAILSRV.intcomgrp.com> <3DBBD805E3BA064A87F551C0E8BD36740289741C@MAILSRV.intcomgrp.com> <4B4CCC7B.8040609@gmail.com>
From: "James Kosin" <JKosin@intcomgrp.com>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
>From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
>Sent: Tuesday, January 12, 2010 2:25 PM
>To: James Kosin
>Cc: linux-kernel@vger.kernel.org; Linux Netdev List
>Subject: Re: arm: Optimization for ethernet MAC handling at91_ether.c
>
>Le 12/01/2010 20:03, James Kosin a écrit :
>> 
>> Scratch that.  The interrupt doesn't queue up or send another packet directly.  So, it wouldn't help on performance here.  But, may in other implementations that queue/transmit packets in the ISR.  At least in the case where the transmitter is limited to one.
>> 
>
>It could, at least on SMP. tx completion wakes a blocked sender, while
>this cpu continue with RX handling (possibly expensive)
>
>But even on UP, doing tx completion before rx handling allows
>a better reuse of skb just freed (and partly present in cpu cache, if available).
>
>Start of IRQ
>
>1) tx completion
>    -> free a skb
>
>2) rx handling:
>    -> allocate an skb, kmalloc() reuses previous one, still in cpu cache.
>
>End of IRQ

I think this may work to improve things slightly; since, the transmitter always frees the skb regardless of error or success currently.

What I was proposing was to modify the sequence slightly to be more like this:

1) tx completion
	-> test for TX TUND error
		-> resend the current skb (to avoid having to re-do)
	-> else
		-> test for TX RTRY error
			-> increment error count as before
		-> free the skb

