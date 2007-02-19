Return-Path: <linux-kernel-owner+w=401wt.eu-S965061AbXBSWHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061AbXBSWHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965099AbXBSWHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:07:41 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:46484 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965061AbXBSWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:07:39 -0500
In-Reply-To: <87vehzqwf6.fsf@duaron.myhome.or.jp>
References: <6EF4DB85-C7D4-445B-B9B5-0D22D5D893CD@kernel.crashing.org> <87vehzqwf6.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <48F02683-BD10-4515-BCDF-53DB8F6167AA@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
Date: Mon, 19 Feb 2007 16:06:36 -0600
To: Linux Kernel list <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 18, 2007, at 10:10 AM, OGAWA Hirofumi wrote:

> Kumar Gala <galak@kernel.crashing.org> writes:
>
>> I'm seeing an issue with a stock 2.6.20 kernel running on an embedded
>> PPC.  I've got a usb flash drive plugged in and the filesystem on the
>> drive is vfat.  Running with 64M and no swap.
>>
>> If I execute a series of large (100M+) ftruncate() on the disk the
>> kernel will hang and never return.  It seems to be stuck in the idle
>> loop().
>>
>> The following is the test program I'm running:
>>
>> #include <sys/mman.h>
>> #include <sys/types.h>
>> #include <sys/stat.h>
>> #include <fcntl.h>
>> #include <stdio.h>
>> #include <unistd.h>
>> #include <errno.h>
>>
>> void usage (void)
>> {
>>          printf ("truncate_test <filename> <size>\n\n");
>> }
>>
>> int main(int argc, char *argv[])
>> {
>>          int fd, i;
>>          int ret = 0;
>>          unsigned int len;
>>
>>          if (argc != 3) {
>>                  printf("Invalid number of arguments\n\n");
>>                  usage();
>>                  exit(1);
>>          }
>>
>>          fd = open(argv[1], O_CREAT|O_RDWR|O_TRUNC, S_IRWXU);
>>          len = strtoul(argv[2], NULL, 0);
>>
>>          ret = ftruncate(fd, len);
>>
>>          if (ret)
>>                  printf ("ftruncate ret = %d %d\n", ret, errno);
>>
>>          close(fd);
>>
>>          return ret;
>> }
>>
>> I usually run the following twice to get the hang state:
>>
>> time ./trunc_test bar 100000000 &
>> time ./trunc_test baz 100000000 &
>>
>> I was wondering if anyone had any suggestions on what to poke at next
>> to try and figure out what is going on.

So I realized I could use sysrq to provide some more debug  
information.  When the system locks up I get the following output  
from 't'

[  496.901002] Show State
[  496.903356]
[  496.903360]                          free                         
sibling
[  496.911532]   task             PC    stack   pid father child  
younger older
[  496.918486] init          S 3009C7EC     0     1      0      
2               (NOTLB)
[  496.926169] Call Trace:
[  496.928611] [C3FC7DA0] [C006F03C] __link_path_walk+0xd24/0x112c  
(unreliable)
[  496.935687] [C3FC7E60] [C00083AC] __switch_to+0x28/0x40
[  496.940931] [C3FC7E80] [C01F4B78] schedule+0x324/0x6bc
[  496.946086] [C3FC7EC0] [C001E164] do_wait+0x700/0x100c
[  496.951242] [C3FC7F40] [C000FAD4] ret_from_syscall+0x0/0x38
[  496.956828] --- Exception: c01 at 0x3009c7ec
[  496.961099]     LR = 0x3009c3e0
[  496.964234] ksoftirqd/0   S 00000000     0     2       
1             3       (L-TLB)
[  496.971913] Call Trace:
[  496.974355] [C033DE80] [C0133F64] scsi_io_completion+0x74/0x318  
(unreliable)
[  496.981428] [C033DF40] [C00083AC] __switch_to+0x28/0x40
[  496.986664] [C033DF60] [C01F4B78] schedule+0x324/0x6bc
[  496.991811] [C033DFA0] [C00210CC] ksoftirqd+0xfc/0x114
[  496.996960] [C033DFC0] [C0033E48] kthread+0xf4/0x130
[  497.001941] [C033DFF0] [C001093C] kernel_thread+0x44/0x60
[  497.007350] events/0      S 00000000     0     3       
1             4     2 (L-TLB)
[  497.015030] Call Trace:
[  497.017472] [C033FEE0] [C00083AC] __switch_to+0x28/0x40
[  497.022707] [C033FF00] [C01F4B78] schedule+0x324/0x6bc
[  497.027855] [C033FF40] [C002F67C] worker_thread+0x144/0x148
[  497.033435] [C033FFC0] [C0033E48] kthread+0xf4/0x130
[  497.038409] [C033FFF0] [C001093C] kernel_thread+0x44/0x60
[  497.043817] khelper       S 00000000     0     4       
1             5     3 (L-TLB)
[  497.051497] Call Trace:
[  497.053940] [C3FE1E20] [C3FE0000] 0xc3fe0000 (unreliable)
[  497.059351] [C3FE1EE0] [C00083AC] __switch_to+0x28/0x40
[  497.064586] [C3FE1F00] [C01F4B78] schedule+0x324/0x6bc
[  497.069734] [C3FE1F40] [C002F67C] worker_thread+0x144/0x148
[  497.075316] [C3FE1FC0] [C0033E48] kthread+0xf4/0x130
[  497.080291] [C3FE1FF0] [C001093C] kernel_thread+0x44/0x60
[  497.085697] kthread       S 00000000     0     5      1    37      
617     4 (L-TLB)
[  497.093378] Call Trace:
[  497.095820] [C3FCBE20] [00001032] 0x1032 (unreliable)
[  497.100881] --- Exception: c3fcbef0 at __switch_to+0x28/0x40
[  497.106545]     LR = 0xc3fcbef0
[  497.109681] [C3FCBEE0] [C00083AC] __switch_to+0x28/0x40 (unreliable)
[  497.116051] [C3FCBF00] [C01F4B78] schedule+0x324/0x6bc
[  497.121201] [C3FCBF40] [C002F67C] worker_thread+0x144/0x148
[  497.126783] [C3FCBFC0] [C0033E48] kthread+0xf4/0x130
[  497.131758] [C3FCBFF0] [C001093C] kernel_thread+0x44/0x60
[  497.137165] kblockd/0     S 00000000     0    37      5             
41       (L-TLB)
[  497.144845] Call Trace:
[  497.147286] [C3D9FE20] [C3EBF490] 0xc3ebf490 (unreliable)
[  497.152697] [C3D9FEE0] [C00083AC] __switch_to+0x28/0x40
[  497.157933] [C3D9FF00] [C01F4B78] schedule+0x324/0x6bc
[  497.163082] [C3D9FF40] [C002F67C] worker_thread+0x144/0x148
[  497.168663] [C3D9FFC0] [C0033E48] kthread+0xf4/0x130
[  497.173637] [C3D9FFF0] [C001093C] kernel_thread+0x44/0x60
[  497.179045] khubd         S 00000000     0    41      5             
53    37 (L-TLB)
[  497.186726] Call Trace:
[  497.189167] [C0341E00] [C3F03900] 0xc3f03900 (unreliable)
[  497.194578] [C0341EC0] [C00083AC] __switch_to+0x28/0x40
[  497.199813] [C0341EE0] [C01F4B78] schedule+0x324/0x6bc
[  497.204961] [C0341F20] [C0152288] hub_thread+0xb40/0xcc0
[  497.210283] [C0341FC0] [C0033E48] kthread+0xf4/0x130
[  497.215257] [C0341FF0] [C001093C] kernel_thread+0x44/0x60
[  497.220664] pdflush       D 00000000     0    53      5             
55    41 (L-TLB)
[  497.228344] Call Trace:
[  497.230786] [C3CABD10] [C008E098] __find_get_block+0x10c/0x288  
(unreliable)
[  497.237769] [C3CABDD0] [C00083AC] __switch_to+0x28/0x40
[  497.243004] [C3CABDF0] [C01F4B78] schedule+0x324/0x6bc
[  497.248152] [C3CABE30] [C01F5D6C] schedule_timeout+0x6c/0xd0
[  497.253822] [C3CABE70] [C01F5C9C] io_schedule_timeout+0x30/0x54
[  497.259752] [C3CABE90] [C0050DE4] congestion_wait+0x64/0x8c
[  497.265343] [C3CABEE0] [C004AA9C] background_writeout+0x44/0xe8
[  497.271274] [C3CABF50] [C004BE04] pdflush+0x16c/0x27c
[  497.276335] [C3CABFC0] [C0033E48] kthread+0xf4/0x130
[  497.281311] [C3CABFF0] [C001093C] kernel_thread+0x44/0x60
[  497.286718] kswapd0       D 00000000     0    55      5             
56    53 (L-TLB)
[  497.294399] Call Trace:
[  497.296841] [C3DEFB70] [C0025FE8] run_timer_softirq+0x20/0x230  
(unreliable)
[  497.303823] [C3DEFC30] [C00083AC] __switch_to+0x28/0x40
[  497.309058] [C3DEFC50] [C01F4B78] schedule+0x324/0x6bc
[  497.314207] [C3DEFC90] [C01F5D6C] schedule_timeout+0x6c/0xd0
[  497.319876] --- Exception: c3defd60 at 0xc3deff40
[  497.324582]     LR = 0xc3dee000
[  497.327718] [C3DEFCD0] [C01F5C9C] io_schedule_timeout+0x30/0x54  
(unreliable)
[  497.334783] [C3DEFCF0] [C0050DE4] congestion_wait+0x64/0x8c
[  497.340367] [C3DEFD40] [C004A9F0] throttle_vm_writeout+0x1c/0x84
[  497.346384] [C3DEFD60] [C004F33C] shrink_zone+0xbb0/0xfe4
[  497.351792] [C3DEFF10] [C004FD10] kswapd+0x2d4/0x424
[  497.356767] [C3DEFFC0] [C0033E48] kthread+0xf4/0x130
[  497.361741] [C3DEFFF0] [C001093C] kernel_thread+0x44/0x60
[  497.367151] aio/0         S 00000000     0    56      5            
670    55 (L-TLB)
[  497.374832] Call Trace:
[  497.377272] [C3CADE20] [00000020] 0x20 (unreliable)
[  497.382162] [C3CADEE0] [C00083AC] __switch_to+0x28/0x40
[  497.387398] [C3CADF00] [C01F4B78] schedule+0x324/0x6bc
[  497.392547] [C3CADF40] [C002F67C] worker_thread+0x144/0x148
[  497.398128] [C3CADFC0] [C0033E48] kthread+0xf4/0x130
[  497.403102] [C3CADFF0] [C001093C] kernel_thread+0x44/0x60
[  497.408508] mtdblockd     S 00000000     0   617      1            
718     5 (L-TLB)
[  497.416191] Call Trace:
[  497.418632] [C3F27E70] [C02A0000] 0xc02a0000 (unreliable)
[  497.424043] [C3F27F30] [C00083AC] __switch_to+0x28/0x40
[  497.429278] [C3F27F50] [C01F4B78] schedule+0x324/0x6bc
[  497.434425] [C3F27F90] [C013FAAC] mtd_blktrans_thread+0x250/0x340
[  497.440534] [C3F27FF0] [C001093C] kernel_thread+0x44/0x60
[  497.445941] scsi_eh_0     D 00000000     0   670      5            
671    56 (L-TLB)
[  497.453622] Call Trace:
[  497.456062] [C3F1FDF0] [00000011] 0x11 (unreliable)
[  497.460951] [C3F1FEB0] [C00083AC] __switch_to+0x28/0x40
[  497.466187] [C3F1FED0] [C01F4B78] schedule+0x324/0x6bc
[  497.471335] [C3F1FF10] [C01F50D4] wait_for_completion+0xa0/0x150
[  497.477351] [C3F1FF50] [C016641C] command_abort+0xdc/0x118
[  497.482846] [C3F1FF60] [C0132BC0] scsi_error_handler+0x5f0/0x810
[  497.488868] [C3F1FFC0] [C0033E48] kthread+0xf4/0x130
[  497.493842] [C3F1FFF0] [C001093C] kernel_thread+0x44/0x60
[  497.499249] usb-storage   D 00000000     0   671      5            
773   670 (L-TLB)
[  497.506930] Call Trace:
[  497.509372] [C3F35A60] [C00083AC] __switch_to+0x28/0x40
[  497.514608] [C3F35A80] [C01F4B78] schedule+0x324/0x6bc
[  497.519756] [C3F35AC0] [C01F5D6C] schedule_timeout+0x6c/0xd0
[  497.525426] [C3F35B00] [C01F5C9C] io_schedule_timeout+0x30/0x54
[  497.531356] [C3F35B20] [C0050DE4] congestion_wait+0x64/0x8c
[  497.536941] [C3F35B70] [C004A9F0] throttle_vm_writeout+0x1c/0x84
[  497.542958] [C3F35B90] [C004F33C] shrink_zone+0xbb0/0xfe4
[  497.548367] [C3F35D40] [C004F8F4] try_to_free_pages+0x184/0x2cc
[  497.554298] [C3F35DB0] [C0049AA8] __alloc_pages+0x110/0x2c0
[  497.559878] [C3F35E00] [C0060F84] cache_alloc_refill+0x394/0x694
[  497.565900] [C3F35E30] [C00614A0] __kmalloc+0xc4/0xcc
[  497.570961] [C3F35E40] [C01544D0] usb_alloc_urb+0x1c/0x5c
[  497.576371] [C3F35E50] [C015520C] usb_sg_init+0x1a0/0x2f8
[  497.581779] [C3F35EA0] [C0167318] usb_stor_bulk_transfer_sg+0x8c/ 
0x138
[  497.588317] [C3F35ED0] [C0167960] usb_stor_Bulk_transport+0x140/0x310
[  497.594767] [C3F35F00] [C0167DCC] usb_stor_invoke_transport+0x2c/ 
0x344
[  497.601303] [C3F35F50] [C0166B2C] usb_stor_transparent_scsi_command 
+0x10/0x20
[  497.608449] [C3F35F60] [C0168498] usb_stor_control_thread+0x1f8/0x290
[  497.614900] [C3F35FC0] [C0033E48] kthread+0xf4/0x130
[  497.619876] [C3F35FF0] [C001093C] kernel_thread+0x44/0x60
[  497.625285] sh            D 3009C7EC     0   718      1            
787   617 (NOTLB)
[  497.632968] Call Trace:
[  497.635410] [C3C37A90] [C01339AC] scsi_run_queue+0x220/0x2e0  
(unreliable)
[  497.642216] [C3C37B50] [C00083AC] __switch_to+0x28/0x40
[  497.647452] [C3C37B70] [C01F4B78] schedule+0x324/0x6bc
[  497.652601] [C3C37BB0] [C01F5D6C] schedule_timeout+0x6c/0xd0
[  497.658272] [C3C37BF0] [C01F5C9C] io_schedule_timeout+0x30/0x54
[  497.664202] [C3C37C10] [C0050DE4] congestion_wait+0x64/0x8c
[  497.669786] [C3C37C60] [C004A9F0] throttle_vm_writeout+0x1c/0x84
[  497.675802] [C3C37C80] [C004F33C] shrink_zone+0xbb0/0xfe4
[  497.681211] [C3C37E30] [C004F8F4] try_to_free_pages+0x184/0x2cc
[  497.687141] [C3C37EA0] [C0049AA8] __alloc_pages+0x110/0x2c0
[  497.692723] [C3C37EF0] [C0049C8C] __get_free_pages+0x34/0x74
[  497.698390] [C3C37F00] [C007C3C4] sys_getcwd+0x30/0x2b0
[  497.703629] [C3C37F40] [C000FAD4] ret_from_syscall+0x0/0x38
[  497.709210] --- Exception: c01 at 0x3009c7ec
[  497.713480]     LR = 0x3009a7b0
[  497.716614] pdflush       D 00000000     0   773       
5                 671 (L-TLB)
[  497.724294] Call Trace:
[  497.726737] [C32ADD10] [C008E098] __find_get_block+0x10c/0x288  
(unreliable)
[  497.733718] [C32ADDD0] [C00083AC] __switch_to+0x28/0x40
[  497.738954] [C32ADDF0] [C01F4B78] schedule+0x324/0x6bc
[  497.744102] [C32ADE30] [C01F5D6C] schedule_timeout+0x6c/0xd0
[  497.749772] [C32ADE70] [C01F5C9C] io_schedule_timeout+0x30/0x54
[  497.755702] [C32ADE90] [C0050DE4] congestion_wait+0x64/0x8c
[  497.761285] [C32ADEE0] [C004AC74] wb_kupdate+0xf0/0x160
[  497.766520] [C32ADF50] [C004BE04] pdflush+0x16c/0x27c
[  497.771581] [C32ADFC0] [C0033E48] kthread+0xf4/0x130
[  497.776556] [C32ADFF0] [C001093C] kernel_thread+0x44/0x60
[  497.781965] time          S 3009C7EC     0   787      1   789      
788   718 (NOTLB)
[  497.789648] Call Trace:
[  497.792089] [C03A3E60] [C00083AC] __switch_to+0x28/0x40
[  497.797326] [C03A3E80] [C01F4B78] schedule+0x324/0x6bc
[  497.802474] [C03A3EC0] [C001E164] do_wait+0x700/0x100c
[  497.807630] [C03A3F40] [C000FAD4] ret_from_syscall+0x0/0x38
[  497.813210] --- Exception: c01 at 0x3009c7ec
[  497.817481]     LR = 0x3009c414
[  497.820616] trunc_test    D 300787EC     0   789     
787                     (NOTLB)
[  497.828295] Call Trace:
[  497.830737] [C19B3960] [C0160000] handshake+0x6c/0x9c (unreliable)
[  497.836939] [C19B3A20] [C00083AC] __switch_to+0x28/0x40
[  497.842175] [C19B3A40] [C01F4B78] schedule+0x324/0x6bc
[  497.847323] [C19B3A80] [C01F5D6C] schedule_timeout+0x6c/0xd0
[  497.852994] [C19B3AC0] [C01F5C9C] io_schedule_timeout+0x30/0x54
[  497.858924] [C19B3AE0] [C0050DE4] congestion_wait+0x64/0x8c
[  497.864510] [C19B3B30] [C004A9F0] throttle_vm_writeout+0x1c/0x84
[  497.870525] [C19B3B50] [C004F33C] shrink_zone+0xbb0/0xfe4
[  497.875934] [C19B3D00] [C004F8F4] try_to_free_pages+0x184/0x2cc
[  497.881864] [C19B3D70] [C0049AA8] __alloc_pages+0x110/0x2c0
[  497.887445] [C19B3DC0] [C00447F4] find_or_create_page+0x8c/0xe4
[  497.893386] [C19B3DE0] [C0090DAC] cont_prepare_write+0xac/0x32c
[  497.899321] [C19B3E20] [C00D7A50] fat_prepare_write+0x30/0x40
[  497.905077] [C19B3E30] [C008E68C] __generic_cont_expand+0xa4/0x158
[  497.911268] [C19B3E50] [C00D7254] fat_notify_change+0xf4/0x208
[  497.917109] [C19B3E80] [C007EB24] notify_change+0x1ec/0x1fc
[  497.922695] [C19B3EB0] [C0062DC0] do_truncate+0x58/0x88
[  497.927935] [C19B3F10] [C006316C] do_sys_ftruncate+0x180/0x1a8
[  497.933780] [C19B3F40] [C000FAD4] ret_from_syscall+0x0/0x38
[  497.939361] --- Exception: c01 at 0x300787ec
[  497.943634]     LR = 0x1000073c
[  497.946768] time          S 3009C7EC     0   788      1    
790           787 (NOTLB)
[  497.954450] Call Trace:
[  497.956892] [C1919E60] [C00083AC] __switch_to+0x28/0x40
[  497.962129] [C1919E80] [C01F4B78] schedule+0x324/0x6bc
[  497.967278] [C1919EC0] [C001E164] do_wait+0x700/0x100c
[  497.972431] [C1919F40] [C000FAD4] ret_from_syscall+0x0/0x38
[  497.978011] --- Exception: c01 at 0x3009c7ec
[  497.982282]     LR = 0x3009c414
[  497.985417] trunc_test    D 300787EC     0   790     
788                     (NOTLB)
[  497.993101] Call Trace:
[  497.995542] [C2BFDA00] [C0047E68] mempool_alloc+0x38/0x144  
(unreliable)
[  498.002171] [C2BFDAC0] [C00083AC] __switch_to+0x28/0x40
[  498.007406] [C2BFDAE0] [C01F4B78] schedule+0x324/0x6bc
[  498.012554] [C2BFDB20] [C01F5C48] io_schedule+0x30/0x54
[  498.017790] [C2BFDB40] [C008D01C] sync_buffer+0x68/0x7c
[  498.023026] [C2BFDB50] [C01F5E80] __wait_on_bit+0x98/0xec
[  498.028435] [C2BFDB70] [C01F5F34] out_of_line_wait_on_bit+0x60/0x74
[  498.034713] [C2BFDBC0] [C008CF3C] __wait_on_buffer+0x3c/0x4c
[  498.040382] [C2BFDBD0] [C00916F4] __bread+0xe8/0xf4
[  498.045270] [C2BFDBE0] [C00D5C24] fat_ent_bread+0x48/0xa8
[  498.050678] [C2BFDC00] [C00D6358] fat_ent_read+0x168/0x1f0
[  498.056171] [C2BFDC30] [C00D6690] fat_free_clusters+0x64/0x260
[  498.062011] [C2BFDCC0] [C00D75C4] fat_truncate+0x25c/0x334
[  498.067507] [C2BFDD30] [C0053EE4] vmtruncate+0x184/0x1a4
[  498.072833] [C2BFDD50] [C007E810] inode_setattr+0x7c/0x1a4
[  498.078329] [C2BFDD90] [C00D7314] fat_notify_change+0x1b4/0x208
[  498.084257] [C2BFDDC0] [C007EB24] notify_change+0x1ec/0x1fc
[  498.089840] [C2BFDDF0] [C0062DC0] do_truncate+0x58/0x88
[  498.095077] [C2BFDE50] [C007028C] may_open+0x1fc/0x200
[  498.100230] [C2BFDE70] [C0070380] open_namei+0xf0/0x714
[  498.105465] [C2BFDEB0] [C0063BB8] do_filp_open+0x30/0x78
[  498.110788] [C2BFDF20] [C0064018] do_sys_open+0x70/0xc0
[  498.116023] [C2BFDF40] [C000FAD4] ret_from_syscall+0x0/0x38
[  498.121605] --- Exception: c01 at 0x300787ec
[  498.125878]     LR = 0x30077580

and from 'm'

[  731.834529] Show Memory
[  731.836968] Mem-info:
[  731.839234] DMA per-cpu:
[  731.841768] CPU    0: Hot: hi:   18, btch:   3 usd:   3   Cold:  
hi:    6, btch:   1 usd:   2
[  731.850206] Active:1510 inactive:11309 dirty:7188 writeback:3330  
unstable:0 free:1009 slab:1671 mapped:110 pagetables:19
[  731.861075] DMA free:4036kB min:4096kB low:5120kB high:6144kB  
active:6040kB inactive:45236kB present:65024kB pages_scanned:292  
all_unreclaimable? no
[  731.874363] lowmem_reserve[]: 0 0
[  731.877685] DMA: 1*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB  
1*512kB 1*1024kB 1*2048kB 0*4096kB = 4036kB
[  731.887669] Free swap:            0kB
[  731.893913] 16384 pages of RAM
[  731.896963] 798 reserved pages
[  731.900011] 10946 pages shared
[  731.903058] 0 pages swap cached

It seems like usb-storage and aio are completely off in the weeds.   
Ideas?

If you need any additional debug output let me know.

- k

