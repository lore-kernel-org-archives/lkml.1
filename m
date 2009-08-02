Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZHBQqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZHBQqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZHBQqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:46:03 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53743 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZHBQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ti/eLMXbHtlsJ0/AHQeDXacAADJzd3MnAtHPwwkm6EVXjrwQX+35TfaQidWo7+nCsp
         OZTTMypHZ6IOnjT3jYy1c/PAa0Pvx+6o3PlEGS/ktFppFhsEyfOfp88XKB9haMAMrlsn
         Wc3L1O2eydOUiagWbLz3jVXsK/anGZWX2xLx4=
Message-ID: <4A75C2C3.3070501@gmail.com>
Date: Sun, 02 Aug 2009 17:45:55 +0100
From: Dave <kilroyd@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090328)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kilroyd@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] locking: Check spinlock_t/rwlock_t argument
 type on non-SMP builds too
References: <1248286295-8304-1-git-send-email-kilroyd@googlemail.com> <tip-02626aa5ecc03f94585164b97bedabe15302e3c3@git.kernel.org> <20090802134054.GA14026@elte.hu>
In-Reply-To: <20090802134054.GA14026@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for David Kilroy <kilroyd@googlemail.com> wrote:
> 
>> Commit-ID:  02626aa5ecc03f94585164b97bedabe15302e3c3
>> Gitweb:     http://git.kernel.org/tip/02626aa5ecc03f94585164b97bedabe15302e3c3
>> Author:     David Kilroy <kilroyd@googlemail.com>
>> AuthorDate: Wed, 22 Jul 2009 19:11:35 +0100
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Sun, 2 Aug 2009 14:59:29 +0200
>>
>> locking: Check spinlock_t/rwlock_t argument type on non-SMP builds too
> 
> -tip testing found UP crashes and i bisected it down to:
> 
>  02626aa5ecc03f94585164b97bedabe15302e3c3 is first bad commit
>  commit 02626aa5ecc03f94585164b97bedabe15302e3c3
>  Author: David Kilroy <kilroyd@googlemail.com>
>  Date:   Wed Jul 22 19:11:35 2009 +0100
> 
>     locking: Check spinlock_t/rwlock_t argument type on non-SMP builds too
> 
> the crash looks like this:
> 
> [   55.257999] ip[3699]: segfault at 31108c6d80 ip 00000031108c6d80 sp 00007fff4aa183d8 error 14
> 
> sometimes it's just a spontaneous reboot with no log message.


Crap. Looking really carefully:

+static inline int _spin_trylock_bh(spinlock_t *lock)
+{ __LOCK(lock); return 1; }

Should have been:

+static inline int _spin_trylock_bh(spinlock_t *lock)
+{ __LOCK_BH(lock); return 1; }

I can't say if that's definitely causing your issue, but it's certainly
wrong. I'll go through it all again, and send a v3 of the patch.


Dave.
