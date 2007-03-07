Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXCGUav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXCGUav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965639AbXCGUau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:30:50 -0500
Received: from gw.goop.org ([64.81.55.164]:56697 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965632AbXCGUau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:30:50 -0500
Message-ID: <45EF20F7.1050307@goop.org>
Date: Wed, 07 Mar 2007 12:30:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com> <20070307155553.06c82ca1.sfr@canb.auug.org.au> <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com> <20070307233833.f1482f86.sfr@canb.auug.org.au> <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org> <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Wed, 7 Mar 2007, Linus Torvalds wrote:
>
>   
>> On Wed, 7 Mar 2007, Stephen Rothwell wrote:
>>     
>>> You probably need the queue anyway because the real time signals are
>>> supposed to queue.
>>>       
>> Davide - the *real* problem is (I think) that you try to allow signals to 
>> be returned *both* by signalfd() and as a real signal.
>>
>> That's wrong, wrong, wrong.
>>
>> My original patch used "dequeue_signal()" to dequeue signals. Trust me, I 
>> did that for a reason. Your re-design to think that you can get the signal 
>> without using the real signal dequeueing is simply broken.
>>     
>
> I think having the ability to have both can be usefull, so the idea of 
> having multiple listeners fd (that both would not work with the single 
> queue since they'd racing over dequeue_signal).
>   

Do you have a specific use-case in mind?  Because I don't think this is
very useful at all; in fact it may be the opposite of useful.

Generally signals are "owned" by one particular piece of code, and if
you want to distribute the event further then you do that in the app, as
you have to do with a normal signal handler.  This code is the fd-based
analog of sigtimedwait, and so it should behave basically the same way. 
If multiple threads call sigtimedwait on the same signal set, then one
and only one will receive each signal.  This is good, because it means
you can have a thread pool processing signals (and other events) knowing
that there won't be duplicate processing.

I haven't looked at your code in detail, but it isn't clear from your
description whether you can have multiple signalfds for different
(distinct) sets of signals.  That would be useful as a first level of
demultiplexing between multiple user-mode signal consumers.  If you
allow that, you need to decide whether a read/poll on a signalfd blocks
until the head queued signal is part of the signal set, or if any queued
signal is in the set.

    J
