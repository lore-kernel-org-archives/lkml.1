Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0BHUjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:39:12 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:48515 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab0BHUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:39:10 -0500
Date: Mon, 8 Feb 2010 21:39:09 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100208203909.GA6003@rhlx01.hs-esslingen.de>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain> <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208194734.GA20316@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I'm having trouble pinpointing the reason for the issue
(after all divisor is not 0 but likely NSEC_PER_SEC,
as likely called by time.h timespec_add_ns() --> __iter_div_u64_rem()),
here comes timekeeping_forward_now in its entire glory (objdump -D vmlinux):

c104505a <timekeeping_forward_now>:
c104505a:       55                      push   %ebp
c104505b:       89 e5                   mov    %esp,%ebp
c104505d:       57                      push   %edi
c104505e:       56                      push   %esi
c104505f:       53                      push   %ebx
c1045060:       83 ec 18                sub    $0x18,%esp
c1045063:       e8 5c dc fb ff          call   c1002cc4 <mcount>
c1045068:       8b 1d d8 20 46 c1       mov    0xc14620d8,%ebx
c104506e:       89 d8                   mov    %ebx,%eax
c1045070:       ff 53 10                call   *0x10(%ebx)
c1045073:       8b 4b 1c                mov    0x1c(%ebx),%ecx
c1045076:       89 c6                   mov    %eax,%esi
c1045078:       89 d7                   mov    %edx,%edi
c104507a:       2b 73 40                sub    0x40(%ebx),%esi
c104507d:       1b 7b 44                sbb    0x44(%ebx),%edi
c1045080:       21 f1                   and    %esi,%ecx
c1045082:       89 4d ec                mov    %ecx,-0x14(%ebp)
c1045085:       8b 73 20                mov    0x20(%ebx),%esi
c1045088:       89 43 40                mov    %eax,0x40(%ebx)
c104508b:       89 53 44                mov    %edx,0x44(%ebx)
c104508e:       a1 08 21 46 c1          mov    0xc1462108,%eax
c1045093:       21 fe                   and    %edi,%esi
c1045095:       8b 3d c0 20 46 c1       mov    0xc14620c0,%edi
c104509b:       89 45 e4                mov    %eax,-0x1c(%ebp)
c104509e:       8b 4d e4                mov    -0x1c(%ebp),%ecx
c10450a1:       8b 45 ec                mov    -0x14(%ebp),%eax
c10450a4:       f7 65 e4                mull   -0x1c(%ebp)
c10450a7:       0f af ce                imul   %esi,%ecx
c10450aa:       89 45 e4                mov    %eax,-0x1c(%ebp)
c10450ad:       8b 45 e4                mov    -0x1c(%ebp),%eax
c10450b0:       01 ca                   add    %ecx,%edx
c10450b2:       8b 0d dc 20 46 c1       mov    0xc14620dc,%ecx
c10450b8:       89 55 e8                mov    %edx,-0x18(%ebp)
c10450bb:       8b 55 e8                mov    -0x18(%ebp),%edx
c10450be:       0f ad d0                shrd   %cl,%edx,%eax
c10450c1:       d3 ea                   shr    %cl,%edx
c10450c3:       f6 c1 20                test   $0x20,%cl
c10450c6:       74 04                   je     c10450cc <timekeeping_forward_now+0x72>
c10450c8:       89 d0                   mov    %edx,%eax
c10450ca:       31 d2                   xor    %edx,%edx
c10450cc:       89 45 dc                mov    %eax,-0x24(%ebp)
c10450cf:       a1 c4 20 46 c1          mov    0xc14620c4,%eax
c10450d4:       89 55 e0                mov    %edx,-0x20(%ebp)
c10450d7:       99                      cltd
c10450d8:       01 45 dc                add    %eax,-0x24(%ebp)
c10450db:       11 55 e0                adc    %edx,-0x20(%ebp)
c10450de:       31 c9                   xor    %ecx,%ecx
c10450e0:       8b 45 dc                mov    -0x24(%ebp),%eax
c10450e3:       8b 55 e0                mov    -0x20(%ebp),%edx
c10450e6:       eb 09                   jmp    c10450f1 <timekeeping_forward_now+0x97>
c10450e8:       05 00 36 65 c4          add    $0xc4653600,%eax
c10450ed:       83 d2 ff                adc    $0xffffffff,%edx
c10450f0:       41                      inc    %ecx
c10450f1:       83 fa 00                cmp    $0x0,%edx
c10450f4:       77 f2                   ja     c10450e8 <timekeeping_forward_now+0x8e>
c10450f6:       3d ff c9 9a 3b          cmp    $0x3b9ac9ff,%eax
c10450fb:       77 eb                   ja     c10450e8 <timekeeping_forward_now+0x8e>
c10450fd:       8b 15 0c 21 46 c1       mov    0xc146210c,%edx
c1045103:       8d 3c 39                lea    (%ecx,%edi,1),%edi
c1045106:       89 3d c0 20 46 c1       mov    %edi,0xc14620c0
c104510c:       31 ff                   xor    %edi,%edi
c104510e:       a3 c4 20 46 c1          mov    %eax,0xc14620c4
c1045113:       89 55 e4                mov    %edx,-0x1c(%ebp)
c1045116:       8b 43 24                mov    0x24(%ebx),%eax
c1045119:       31 d2                   xor    %edx,%edx
c104511b:       89 55 e0                mov    %edx,-0x20(%ebp)
c104511e:       0f af f0                imul   %eax,%esi
c1045121:       89 45 dc                mov    %eax,-0x24(%ebp)
c1045124:       8b 45 ec                mov    -0x14(%ebp),%eax
c1045127:       f7 65 dc                mull   -0x24(%ebp)
c104512a:       01 f2                   add    %esi,%edx
c104512c:       8b 35 10 21 46 c1       mov    0xc1462110,%esi
c1045132:       89 45 ec                mov    %eax,-0x14(%ebp)
c1045135:       8b 45 ec                mov    -0x14(%ebp),%eax
c1045138:       89 55 f0                mov    %edx,-0x10(%ebp)
c104513b:       8b 4b 28                mov    0x28(%ebx),%ecx
c104513e:       8b 55 f0                mov    -0x10(%ebp),%edx
c1045141:       0f ad d0                shrd   %cl,%edx,%eax
c1045144:       d3 ea                   shr    %cl,%edx
c1045146:       f6 c1 20                test   $0x20,%cl
c1045149:       0f 45 c2                cmovne %edx,%eax
c104514c:       0f 45 d7                cmovne %edi,%edx
c104514f:       89 c1                   mov    %eax,%ecx
c1045151:       89 f7                   mov    %esi,%edi
c1045153:       8b 45 e4                mov    -0x1c(%ebp),%eax
c1045156:       89 d3                   mov    %edx,%ebx
c1045158:       c1 ff 1f                sar    $0x1f,%edi
c104515b:       01 f1                   add    %esi,%ecx
c104515d:       11 fb                   adc    %edi,%ebx
c104515f:       31 d2                   xor    %edx,%edx
c1045161:       eb 0a                   jmp    c104516d <timekeeping_forward_now+0x113>
c1045163:       81 c1 00 36 65 c4       add    $0xc4653600,%ecx
c1045169:       83 d3 ff                adc    $0xffffffff,%ebx
c104516c:       42                      inc    %edx
c104516d:       83 fb 00                cmp    $0x0,%ebx
c1045170:       77 f1                   ja     c1045163 <timekeeping_forward_now+0x109>
c1045172:       81 f9 ff c9 9a 3b       cmp    $0x3b9ac9ff,%ecx
c1045178:       77 e9                   ja     c1045163 <timekeeping_forward_now+0x109>
c104517a:       89 45 e4                mov    %eax,-0x1c(%ebp)
c104517d:       8d 04 02                lea    (%edx,%eax,1),%eax
c1045180:       a3 0c 21 46 c1          mov    %eax,0xc146210c
c1045185:       89 0d 10 21 46 c1       mov    %ecx,0xc1462110
c104518b:       83 c4 18                add    $0x18,%esp
c104518e:       5b                      pop    %ebx
c104518f:       5e                      pop    %esi
c1045190:       5f                      pop    %edi
c1045191:       5d                      pop    %ebp
c1045192:       c3                      ret


Note that I got a gcc 4.4 (4.4.2) upgrade, but the problems also occurred
at least one build earlier (i.e. with 4.3.4 as standard compiler),
as also confirmed by the dpkg installation log and the kernel package timestamp.



Plus I'm still wondering how - if it got stuck during boot with an
excessively tough division and NMI watchdog triggered -
then later in userspace clocksource_mutex was still stuck.

And I need to point at nmi_watchdog=2 again, with the CPU being lapic
capable but the BIOS not so much, AFAIR.

Thanks for the very responsive help!

Andreas Mohr
