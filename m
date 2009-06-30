Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbZF3Olp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbZF3Olp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZF3Olh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:41:37 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38699 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZF3Olg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:41:36 -0400
Date: Tue, 30 Jun 2009 16:41:36 +0200
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: aeriksson2@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.5 oops
Message-ID: <20090630144136.GA11986@gambetta>
References: <20090630071009.B4E4F33C0ED@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630071009.B4E4F33C0ED@tippex.mynet.homeunix.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 30, 2009 at 09:10:09AM +0200, aeriksson2@gmail.com wrote:
> 
> One of my machines was found dead this morning. Looking at the logs picked up
> by another machine, I found this:
> 
> Jun 30 00:05:52 tv BUG: unable to handle kernel paging request at 0007a2cd
								    ^^^^^^^^
[...]
> Jun 30 00:05:52 tv EAX: 0007a2cd EBX: f6031688 ECX: 0007a2cd EDX: fffffffe
			  ^^^^^^^^

[...]
> Jun 30 00:05:52 tv Code: 0e 89 c7 89 d0 f2 ae 74 05 bf 01 00 00 00 4f 89 f8 5f c3 85 c9 57 89 c7 89 d0 74 05 f2 ae 75 01 4f 89 f8 5f c3 89 
> c1 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 c3 90 55 89 d5 57 56 

Disassembling the above yields:
 804a058:       89 d0                   mov    %edx,%eax
 804a05a:       74 05                   je     804a061 <x+0x21>
 804a05c:       f2 ae                   repnz scas %es:(%edi),%al
 804a05e:       75 01                   jne    804a061 <x+0x21>
 804a060:       4f                      dec    %edi
 804a061:       89 f8                   mov    %edi,%eax
 804a063:       5f                      pop    %edi
 804a064:       c3                      ret    
 804a065:       89 c1                   mov    %eax,%ecx
 804a067:       89 c8                   mov    %ecx,%eax
 804a069:       eb 06                   jmp    804a071 <x+0x31> 
 804a06b:       80 38 00                cmpb   $0x0,(%eax)		 <== EIP
 804a06e:       74 07                   je     804a077 <x+0x37>
 804a070:       40                      inc    %eax
 804a071:       4a                      dec    %edx
 804a072:       83 fa ff                cmp    $0xffffffff,%edx
 804a075:       75 f4                   jne    804a06b <x+0x2b>
 804a077:       29 c8                   sub    %ecx,%eax
 804a079:       c3                      ret    
 804a07a:       90                      nop    
 804a07b:       55                      push   %ebp

A dereferencing which is more inline with the paging request noted above
(compared to the push noted below).
I guess it would be helpful if you could point to the right function
using the above.

Regards,
Frederik


> Jun 30 00:05:52 tv EIP: [<c021dc80>]  SS:ESP 0068:f600fcd4
> Jun 30 00:05:52 tv ---[ end trace 423b4bc611ce6147 ]---
> 
> 
> I have no idea where that garbage at the top came from. Runing it though 
> ksymoops yields:
> >>EIP; c021dc80 <strnlen+6/16>   <=====
> 
> Trace; c021ce61 <string+27/6d>
> Trace; c021d194 <vsnprintf+2ed/731>
> Trace; c0180571 <seq_printf+25/41>
> Trace; c019e809 <show_stat+42d/740>
> Trace; c03219e6 <sock_aio_read+ec/fa>
> Trace; c016d9df <do_sync_read+c0/107>
> Trace; c038af32 <__mutex_lock_slowpath+1e4/1ec>
> Trace; c018080c <seq_read+160/327>
> Trace; c01806ac <seq_read+0/327>
> Trace; c019937c <proc_reg_read+58/6b>
> Trace; c0199324 <proc_reg_read+0/6b>
> Trace; c016e247 <vfs_read+81/f4>
> Trace; c016e352 <sys_read+3c/63>
> Trace; c0102c81 <sysenter_do_call+12/21>
> 
> Code;  c021dc80 <strnlen+6/16>
> 00000000 <_EIP>:
> Code;  c021dc80 <strnlen+6/16>   <=====
>    0:   0e                        push   %cs   <=====
> Code;  c021dc81 <strnlen+7/16>
>    1:   89 c7                     mov    %eax,%edi
> Code;  c021dc83 <strnlen+9/16>
>    3:   89 d0                     mov    %edx,%eax
> Code;  c021dc85 <strnlen+b/16>
>    5:   f2 ae                     repnz scas %es:(%edi),%al
> Code;  c021dc87 <strnlen+d/16>
>    7:   74 05                     je     e <_EIP+0xe>
> Code;  c021dc89 <strnlen+f/16>
>    9:   bf 01 00 00 00            mov    $0x1,%edi
> Code;  c021dc8e <strnlen+14/16>
>    e:   4f                        dec    %edi
> Code;  c021dc8f <strnlen+15/16>
>    f:   89 f8                     mov    %edi,%eax
> Code;  c021dc91 <strstr+1/34>
>   11:   5f                        pop    %edi
> Code;  c021dc92 <strstr+2/34>
>   12:   c3                        ret    
> Code;  c021dc93 <strstr+3/34>
>   13:   85 c9                     test   %ecx,%ecx
> Code;  c021dc95 <strstr+5/34>
>   15:   57                        push   %edi
> Code;  c021dc96 <strstr+6/34>
>   16:   89 c7                     mov    %eax,%edi
> Code;  c021dc98 <strstr+8/34>
>   18:   89 d0                     mov    %edx,%eax
> Code;  c021dc9a <strstr+a/34>
>   1a:   74 05                     je     21 <_EIP+0x21>
> Code;  c021dc9c <strstr+c/34>
>   1c:   f2 ae                     repnz scas %es:(%edi),%al
> Code;  c021dc9e <strstr+e/34>
>   1e:   75 01                     jne    21 <_EIP+0x21>
> Code;  c021dca0 <strstr+10/34>
>   20:   4f                        dec    %edi
> Code;  c021dca1 <strstr+11/34>
>   21:   89 f8                     mov    %edi,%eax
> Code;  c021dca3 <strstr+13/34>
>   23:   5f                        pop    %edi
> Code;  c021dca4 <strstr+14/34>
>   24:   c3                        ret    
> Code;  c021dca5 <strstr+15/34>
>   25:   89 00                     mov    %eax,(%eax)
> 
> Jun 30 00:05:52 tv EIP: [<c021dc80>]  SS:ESP 0068:f600fcd4
> 
> 
> Any ideas what happened?
> 
> /Anders
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
