Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZHZV0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZHZV0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZHZV0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:26:20 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:57607 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbZHZV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:26:20 -0400
Date: Wed, 26 Aug 2009 23:30:24 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Dillow <dave@thedillows.org>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Reduce looping in the interrupt handler.
Message-ID: <20090826213024.GA20428@electric-eye.fr.zoreil.com>
References: <m1r5v0ogvw.fsf@fess.ebiederm.org> <1251169150.4023.11.camel@obelisk.thedillows.org> <m1prajabk8.fsf@fess.ebiederm.org> <1251232848.9607.15.camel@lap75545.ornl.gov> <m1k50r8u4p.fsf@fess.ebiederm.org> <20090825221903.GA13630@electric-eye.fr.zoreil.com> <m1iqgbknun.fsf_-_@fess.ebiederm.org> <1251294974.14241.9.camel@obelisk.thedillows.org> <1251295175.14241.11.camel@obelisk.thedillows.org> <m11vmy737x.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vmy737x.fsf@fess.ebiederm.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> :
[...]
> It is a bit weird but it also means we aren't playing silly games
> with status inside the loop.  So if we go through the loop we ack
> everything in status.

I fear we have some longstanding problem anyway :

1. quiescent state
2. packets are received
3. rtl8169_interrupt schedules napi, clears IntrStatus and exits
4. packets are received and some non-napi event happens
5. rtl8169_interrupt wakes up, reads IntrStatus and goes on...
6. rtl8169_poll wakes up, processes Rx and Tx napi events and goes on...
7. tp->intr_mask still equals ~tp->napi_event : rtl8169_interrupt
   handler does not even try to schedule napi.
8. more packets are received
9. rtl8169_interrupt clears IntrStatus
a. rtl8169_poll reenables napi scheduling, updates IntrMask and exits
b. rtl8169_interrupt reads a perfectly clean IntrStatus and exits

-- 
Ueimor
