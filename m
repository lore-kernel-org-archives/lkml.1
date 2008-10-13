Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYJMKo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYJMKo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYJMKoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:44:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:17316 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbYJMKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KgQ9l6E5jZ4eDeJH/5debBrPfg9M4W4E18hB92WVE4pbHHfLdpUoQV5c893O4Y0ptH
         B9/wprsOazVQ4AECRO6G2mdasYHJ9eAJqMOo1fYvK7iz/thHP3YHj+A+PTV6HXxQxgTx
         q5eea+h1MYJo6Pbzd5IVJz/OP2dfXf1TiPWqI=
Message-ID: <8bd0f97a0810130344hf84e80ag115a791291ceb606@mail.gmail.com>
Date: Mon, 13 Oct 2008 06:44:16 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin OTP Char Driver: add writing support of OTP
Cc: "Bryan Wu" <cooloney@kernel.org>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48F3246F.2060104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223889199-31658-1-git-send-email-cooloney@kernel.org>
	 <48F316C4.1070603@gmail.com>
	 <8bd0f97a0810130243q39581ef5y704c500c8ac3ee1c@mail.gmail.com>
	 <48F31BF9.6030109@gmail.com>
	 <8bd0f97a0810130307i29e76f6w62f9797b561b4c6f@mail.gmail.com>
	 <48F3246F.2060104@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 06:35, Jiri Slaby wrote:
> On 10/13/2008 12:07 PM, Mike Frysinger wrote:
>>> But is this OK to you:
>>> PROCESS 1                       PROCESS 2
>>> lock
>>>  set allow_writes
>>> write
>>>   check allow_writes
>>>   be interrupted
>>>                                whatever
>>>                                unlock
>>>                                    unset allow_writes
>>>                                sleep
>>>   mutex lock
>>>   the processing...
>>
>> i dont see a problem here.  there is no loss of data, hardware
>> failure, software crashes, etc...  in other words, there is no
>> misbehavior.
>
> I see no purpose of allow_writes then. Why is it there? I don't need to call
> memlock if anybody else did and I raced with him. Also when somebody else
> unlocks after finishing of writes I can start failing in the middle of my writes
> -- this doesn't have anything to do with locking, but with the design, the one
> global variable.

the write bit is per-device, not per-process. so the fact you've
narrowed down a race condition to two instructions doesnt matter, the
behavior is the same.  one process can unlock the hardware while
another process (which did not unlock) now has access.  or vice versa.
 the lock is to prevent in inadvertent writes.  considering such
inadvertent writes could make the processor unbootable, it's a simple
safety measure which is quite common when dealing with storage
technology like this (just look at some of the other drivers in the
char subdir).  an application that wants to write must first enable
write access, do the write, and then disable write access.  the
scenario you describe isnt a realistic use case, so no point in
accounting for it.  OTP writes are very rare outside of development if
they occur at all (which is why there's a Kconfig option to just
disable it completely).
-mike
