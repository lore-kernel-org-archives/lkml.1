Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618Ab0ALTYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0ALTYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059Ab0ALTYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:24:48 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:49651 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab0ALTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:24:48 -0500
Message-ID: <4B4CCC7B.8040609@gmail.com>
Date: Tue, 12 Jan 2010 20:24:43 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: James Kosin <JKosin@intcomgrp.com>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: arm: Optimization for ethernet MAC handling at91_ether.c
References: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com> <4B4CA4E5.7030800@gmail.com> <3DBBD805E3BA064A87F551C0E8BD36740289740E@MAILSRV.intcomgrp.com> <4B4CBA93.4090909@gmail.com> <3DBBD805E3BA064A87F551C0E8BD367402897418@MAILSRV.intcomgrp.com> <3DBBD805E3BA064A87F551C0E8BD36740289741C@MAILSRV.intcomgrp.com>
In-Reply-To: <3DBBD805E3BA064A87F551C0E8BD36740289741C@MAILSRV.intcomgrp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 12 Jan 2010 20:24:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/01/2010 20:03, James Kosin a écrit :
> 
> Scratch that.  The interrupt doesn't queue up or send another packet directly.  So, it wouldn't help on performance here.  But, may in other implementations that queue/transmit packets in the ISR.  At least in the case where the transmitter is limited to one.
> 

It could, at least on SMP. tx completion wakes a blocked sender, while
this cpu continue with RX handling (possibly expensive)

But even on UP, doing tx completion before rx handling allows
a better reuse of skb just freed (and partly present in cpu cache, if available).

Start of IRQ

1) tx completion
    -> free a skb

2) rx handling:
    -> allocate an skb, kmalloc() reuses previous one, still in cpu cache.

End of IRQ
