Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYAJQiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYAJQiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759815AbYAJQiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:38:04 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:59508 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754AbYAJQiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:38:02 -0500
Message-ID: <478649D8.9080209@BitWagon.com>
Date: Thu, 10 Jan 2008 08:37:44 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: STT_FUNC for assembler checksum and semaphore ops" in git-x86
References: <20080109215725.GA18185@basil.nowhere.org> <20080110074201.GA12585@uranus.ravnborg.org>
In-Reply-To: <20080110074201.GA12585@uranus.ravnborg.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>+       .type csum_partial, @function
>> ENTRY(csum_partial)
>>+       .type csum_partial, @function
>> ENTRY(csum_partial)
>>        CFI_STARTPROC
>>        pushl %esi
>>@@ -141,11 +142,13 @@ ENTRY(csum_partial)
>>        ret
>>        CFI_ENDPROC
>> ENDPROC(csum_partial)
>>+       .size csum_partial, . - csum_partial

>>AK [Andi Kleen]:
>>Better option would be to just add to ENTRY/ENDPROC ...

> John got more or less same comment from me [Sam Ravnborg] - but
> I did not hear further.
> As it stands out now it not nice.

It does look ugly.  But .size and .type are oriented towards static
description, while the dwarf2 CurrentFrameInfo (CFI) annotations
are oriented towards dynamic traceback and unwinding.  Forcing the
coupling between static and dynamic annotation might lead to trouble
when the fast path to 'ret' is in the middle, and code for the slow
path appears after the 'ret'; or when a recursive tail 'falls
through" into the entry point.

A quick test shows that multiple .size pseudo-ops for the same symbol
are accepted (the last one wins) so default coupling can be overridden.

I'll test revised macros and report shortly.

-- 
John Reiser, jreiser@BitWagon.com
