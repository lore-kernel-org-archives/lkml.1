Return-Path: <linux-kernel-owner+w=401wt.eu-S1422958AbXCOQxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422958AbXCOQxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXCOQxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:53:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47325 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030603AbXCOQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:53:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelianov <xemul@sw.ru>
Cc: vatsa@in.ibm.com, Herbert Poetzl <herbert@13thfloor.at>,
       containers@lists.osdl.org, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7] Resource counters
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru>
	<45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru>
	<20070309163711.GA3647@MAIL.13thfloor.at>
	<m1fy8bwqps.fsf@ebiederm.dsl.xmission.com>
	<20070312011612.GD21861@MAIL.13thfloor.at>
	<m1bqixtsr1.fsf@ebiederm.dsl.xmission.com>
	<20070313152150.GK8755@MAIL.13thfloor.at> <45F6C611.7070400@sw.ru>
	<20070313160707.GF19939@in.ibm.com> <45F7A04B.6000504@sw.ru>
Date: Thu, 15 Mar 2007 10:51:46 -0600
In-Reply-To: <45F7A04B.6000504@sw.ru> (Pavel Emelianov's message of "Wed, 14
	Mar 2007 10:12:11 +0300")
Message-ID: <m18xdyphzx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov <xemul@sw.ru> writes:

> Srivatsa Vaddagiri wrote:
>> On Tue, Mar 13, 2007 at 06:41:05PM +0300, Pavel Emelianov wrote:
>>>> right, but atomic ops have much less impact on most
>>>> architectures than locks :)
>>> Right. But atomic_add_unless() is slower as it is
>>> essentially a loop. See my previous letter in this sub-thread.
>> 
>> If I am not mistaken, you shouldn't loop in normal cases, which means
>> it boils down to a atomic_read() + atomic_cmpxch()
>> 
>> 
>
> So does the lock - in a normal case (when it's not
> heavily contented) it will boil down to atomic_dec_and_test().
>
> Nevertheless, making charge like in this patchset
> requires two atomic ops with atomic_xxx and only
> one with spin_lock().

To be very clear.  If you care about optimization cache lines
and lock hold times (to keep contention down) are the important
things.

With spin locks you have to be a little more careful to put them
on the same cache line as your data and to keep should hold times
short.  With atomic ops you get that automatically.

There is really no significant advantage in either approach.
The number of atomic ops doesn't matter.  You bring in
the cache line and manipulate it.  The expensive part is
acquiring the cache line exclusively.  This is expensive even if
things are never contended but there are many users.

Sorry for the rant, but I just wanted to set the record straight.
spin_locks vs atomic ops is a largely meaningless debate.

Eric
