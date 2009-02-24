Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZBXLNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZBXLNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 06:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZBXLMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 06:12:53 -0500
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:34444 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbZBXLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 06:12:52 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-04.arcor-online.net DC30233A88E
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Performance regression in write() syscall
To: Andi Kleen <andi@firstfloor.org>, Salman Qazi <sqazi@google.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Reply-To: 7eggert@gmx.de
Date: Tue, 24 Feb 2009 12:12:42 +0100
References: <c8UUh-6G-3@gated-at.bofh.it> <c92fh-3uD-15@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LbvDO-0001O1-Ov@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
> On Mon, Feb 23, 2009 at 06:03:04PM -0800, Salman Qazi wrote:

>> @@ -192,14 +192,20 @@ static inline int __copy_from_user_nocache(void *dst,
>> const void __user *src,
>>  unsigned size)
>>  {
>>  might_sleep();
>> -    return __copy_user_nocache(dst, src, size, 1);
>> +    if (likely(size >= PAGE_SIZE))
>> +            return __copy_user_nocache(dst, src, size, 1);
>> +    else
>> +            return __copy_from_user(dst, src, size);
> 
> I think you disabled it completely, the kernel never really does
> any copies larger than page size because all its internal objects
> are page sized only.
> 
> That check would need to be higher up the VFS stack (above filemap.c code)
> before the copies are split up.

It's bigger-or-equal, so this test is correct.

