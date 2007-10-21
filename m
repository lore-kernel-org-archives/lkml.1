Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbXJULyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbXJULyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXJULyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:54:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39288 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXJULya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:54:30 -0400
Message-ID: <471B3DD3.3080107@bull.net>
Date: Sun, 21 Oct 2007 13:53:55 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: IceDove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] KVM updates for Linux 2.6.24-rc review
References: <1192964892617-git-send-email-avi@qumranet.com> <471B340C.5010800@qumranet.com>
In-Reply-To: <471B340C.5010800@qumranet.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/10/2007 14:01:02,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/10/2007 14:01:03,
	Serialize complete at 21/10/2007 14:01:03
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity a écrit :
> Avi Kivity wrote:
>> The following patches fix fallout from the main 2.6.24 KVM merge.  An
>> exception is the movnti emulation patch, which adds support for Linux
>> 2.6.16 guests.
>>
>> The patches can be found in kvm.git in the branch kvm-updates-2.6.24.
>> There is also a branch kvm-updates-2.6.25 which will form the basis of
>> the next merge window submission.
>>
>> Please review the patches and let me know if something is wrong or if
>> a patch is missing.
>>
>>   
> 
> 
> Laurent, I believe the following patch (in kvm-updates-2.6.25) needs to 
> go into 2.6.24 as well.  Can you comment on this?

What kind of comment do you want ?
What are the requirements to go in 2.6.24 instead of 2.6.25 ?

Is a bug correction enough ? :-P

This patch correct a bad behavior of x86_emulate_insn() in case of error with a 
REP prefix.

This patch is needed because, without it, when REP prefix is used with an 
instruction failing for some reasons (like IO or page fault) we don't restore 
all modified registers (like RSI and RDI), but only ECX and EIP, so when we 
re-enter in x86_emulate_insn() we modify again an already modified value. 
Moreover, this patch manages correctly the case where the instruction fails in 
writeback().


>> commit 6de232e39be372f85bea96eb741962acc7fcb1f7
>> Author: Laurent Vivier <Laurent.Vivier@bull.net>
>> Date:   Mon Oct 1 11:01:06 2007 +0200
>>
>>     KVM: x86 emulator: Correct management of REP prefix
>>
>>     This patch corrects some errors appearing when we have an 
>> emulation failure
>>     on an operation using REP prefix.
>>
>>     When x86_emulate_insn() fails, saving EIP and ECX is not enough as 
>> emulation
>>     should have modified other registers like RSI or RDI. Moreover, 
>> the emulation
>>     can fail on the writeback, and in this case we are not able to 
>> restore
>>     registers.
>>
>>     At beginning of x86_emulate_insn(), we restore registers from vcpu 
>> as they were
>>     not modified by x86d_decode_insn() and we save EIP to be able to 
>> restore it
>>     in case of failure.
>>
> 


-- 
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond

