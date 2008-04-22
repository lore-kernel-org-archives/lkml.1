Return-Path: <linux-kernel-owner+w=401wt.eu-S1763993AbYDVNMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763993AbYDVNMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762212AbYDVNMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:12:31 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:64460 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167AbYDVNM3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:12:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIFAIqBDUhMROPA/2dsb2JhbACBUqsB
Date: Tue, 22 Apr 2008 09:12:26 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, akpm@osdl.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080422131226.GA20591@Krystal>
References: <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz> <480CA337.3090709@zytor.com> <20080421150825.GA4070@Krystal> <480CADD3.3010209@zytor.com> <20080421154756.GA2424@Krystal> <20080421172327.GA32278@elf.ucw.cz> <480CCEB0.8040401@zytor.com> <20080421174239.GA14718@Krystal> <480CD5FF.3050708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <480CD5FF.3050708@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:04:57 up 53 days,  9:15,  5 users,  load average: 0.19, 0.42,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> * H. Peter Anvin (hpa@zytor.com) wrote:
>>> Pavel Machek wrote:
>>>>> There is also the page fault case. I think putting this test in
>>>>> ret_from_exception would be both safe (it is executed for any
>>>>> exception return) and fast (exceptions are rare).
>>>> Eh? I thought that page fault is one of the hottest paths in kernel
>>>> (along with syscall and packet receive/send)...
>>>> 								Pavel
>> On x86_64, we can pinpoint only the page faults returning to the kernel,
>> which are rare and only caused by vmalloc accesses. Ideally we could do
>> the same on x86_32.
>
> Pinpoint, how?  Ultimately you need a runtime test, and you better be 
> showing that people are going to die unless before you add a cycle to the 
> page fault path.  I'm only slightly exaggerating that.
>

On x86_32, ret_from_exception identifies the return path taken to return
from an exception. By dulicating the check_userspace code both in the
ret_from_intr and in the ret_from_exception (that's only 4
instructions), we can know if we are in the specific condition of
returning to the kernel from an exception without any supplementary
test. Therefore, we can do the nmi nesting test only in the specific
return-to-kernel-from-exception case without slowing down any critical
code.

Something similar is done on x86_64. That will appear in my next
version.

Thanks,

Mathieu

> 	-hpa
>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
