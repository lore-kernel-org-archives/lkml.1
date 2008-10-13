Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYJMKfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYJMKfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYJMKff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:35:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:38661 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYJMKfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=igi0qFRRc7vfwXwLqkCYrmiJm/XAHnWBpahNUjS4Np7Sok3kwMny62CMKywzsY/LRb
         BZcEozAPg0B8Oaozr+tzv0WsJ0Y9hS8lriUf+k/o/7D6vipSEcJKVNiXxKDeZFki3b/G
         2UHitG05UqdT1HwdaO1wTq7ByC3WIYowUBkiY=
Message-ID: <48F3246F.2060104@gmail.com>
Date: Mon, 13 Oct 2008 12:35:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Bryan Wu <cooloney@kernel.org>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Blackfin OTP Char Driver: add writing support of
 OTP
References: <1223889199-31658-1-git-send-email-cooloney@kernel.org>	 <48F316C4.1070603@gmail.com>	 <8bd0f97a0810130243q39581ef5y704c500c8ac3ee1c@mail.gmail.com>	 <48F31BF9.6030109@gmail.com> <8bd0f97a0810130307i29e76f6w62f9797b561b4c6f@mail.gmail.com>
In-Reply-To: <8bd0f97a0810130307i29e76f6w62f9797b561b4c6f@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2008 12:07 PM, Mike Frysinger wrote:
> the pos gets updated every time a half-page gets processed.  so if you
> call write() and tell it to write 128 bytes, but you get an error half
> way through, the pos points right at the place where the error
> occurred.  i dont get what you're asking.

Ah, OK, that's because I don't know exactly what should happen if a write fails.
I though userspace expects the state of the fd to not be touched.

>> But is this OK to you:
>> PROCESS 1                       PROCESS 2
>> lock
>>  set allow_writes
>> write
>>   check allow_writes
>>   be interrupted
>>                                whatever
>>                                unlock
>>                                    unset allow_writes
>>                                sleep
>>   mutex lock
>>   the processing...
> 
> i dont see a problem here.  there is no loss of data, hardware
> failure, software crashes, etc...  in other words, there is no
> misbehavior.

I see no purpose of allow_writes then. Why is it there? I don't need to call
memlock if anybody else did and I raced with him. Also when somebody else
unlocks after finishing of writes I can start failing in the middle of my writes
-- this doesn't have anything to do with locking, but with the design, the one
global variable.
