Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbXJRFJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbXJRFJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXJRFJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:09:12 -0400
Received: from rtr.ca ([76.10.145.34]:3050 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbXJRFJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:09:10 -0400
Message-ID: <4716EA75.3080901@rtr.ca>
Date: Thu, 18 Oct 2007 01:09:09 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org> <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org> <4716DB9A.2060809@rtr.ca> <4716DE82.2050006@rtr.ca> <4716E720.1010506@rtr.ca>
In-Reply-To: <4716E720.1010506@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Mark Lord wrote:
>>> Linus Torvalds wrote:
>>>>
>>>> On Wed, 17 Oct 2007, Mark Lord wrote:
>>>>> It would be good to have something soon-ish.
>>>>> This "dead at boot time" issue is impacting the general ability to 
>>>>> test
>>>>> patches against latest -git in time for the current merge window.
>>>>
>>>> In the meantime, does the patch I sent out help people? I'd like to 
>>>> get feedback, but I'm a lazy bum, and don't use DEBUG_PAGEALLOC 
>>>> myself, so I was hoping that people who actually see this could 
>>>> comment on my untested suggestion.
>>>
>>> Oh.. so this bug is supposed to only bite with DEBUG_PAGEALLOC=y ??
>>>
>>> Then something else is broken, perhaps.  I just saw a long traceback
>>> scroll off the top of the screen, with lots of bio_* functions in the 
>>> list
>>> and assumed it was the same bug.
>>>
>>> Mmm.. I'll get out the camera and try it again now..
>>
>> Okay, mine is dying with EIP at blk_rq_map_sg+0xcb/0x160.
>>
>> Screen photo is at http://rtr.ca/recent/2.6.23-git12-crash.jpg,
>> but the top was cut off (isn't there a new config option or patch
>> to do double-columns or scrollback or something ???.
> 
> I tried the fancy "boot_delay=nnn" feature, but that doesn't slow down
> the tracebacks at all.  So I hardcoded some mdelay(1000) lines into
> the traceback code, and here's the top part of the oops now:
> 
>   http://rtr.ca/recent/2.6.23-git12-crash2.jpg
...

And, yes, I make that out as being this line from blk_rq_map_sg():

    next_sg = sg_next(sg);

"objdump -d" output from my actual kernel:

00003ce0 <blk_rq_map_sg>:
    3ce0:       55                      push   %ebp
    3ce1:       57                      push   %edi
    3ce2:       56                      push   %esi
    3ce3:       53                      push   %ebx
    3ce4:       83 ec 24                sub    $0x24,%esp
    3ce7:       89 44 24 04             mov    %eax,0x4(%esp)
    3ceb:       8b 98 44 01 00 00       mov    0x144(%eax),%ebx
    3cf1:       83 e3 01                and    $0x1,%ebx
    3cf4:       89 5c 24 14             mov    %ebx,0x14(%esp)
    3cf8:       8b 52 34                mov    0x34(%edx),%edx
    3cfb:       c7 44 24 10 00 00 00    movl   $0x0,0x10(%esp)
    3d02:       00
    3d03:       85 d2                   test   %edx,%edx
    3d05:       89 54 24 1c             mov    %edx,0x1c(%esp)
    3d09:       0f 84 f4 00 00 00       je     3e03 <blk_rq_map_sg+0x123>
    3d0f:       89 cb                   mov    %ecx,%ebx
    3d11:       31 ff                   xor    %edi,%edi
    3d13:       89 4c 24 0c             mov    %ecx,0xc(%esp)
    3d17:       8b 44 24 1c             mov    0x1c(%esp),%eax
    3d1b:       0f b7 48 16             movzwl 0x16(%eax),%ecx
    3d1f:       8b 50 2c                mov    0x2c(%eax),%edx
    3d22:       89 4c 24 18             mov    %ecx,0x18(%esp)
    3d26:       0f b7 40 14             movzwl 0x14(%eax),%eax
    3d2a:       39 c1                   cmp    %eax,%ecx
    3d2c:       0f 8d be 00 00 00       jge    3df0 <blk_rq_map_sg+0x110>
    3d32:       8d 04 49                lea    (%ecx,%ecx,2),%eax
    3d35:       8d 34 82                lea    (%edx,%eax,4),%esi
    3d38:       0f b6 44 24 14          movzbl 0x14(%esp),%eax
    3d3d:       88 44 24 23             mov    %al,0x23(%esp)
    3d41:       eb 05                   jmp    3d48 <blk_rq_map_sg+0x68>
    3d43:       89 f7                   mov    %esi,%edi
    3d45:       83 c6 0c                add    $0xc,%esi
    3d48:       80 7c 24 23 00          cmpb   $0x0,0x23(%esp)
    3d4d:       8b 6e 04                mov    0x4(%esi),%ebp
    3d50:       74 4e                   je     3da0 <blk_rq_map_sg+0xc0>
    3d52:       85 ff                   test   %edi,%edi
    3d54:       74 4a                   je     3da0 <blk_rq_map_sg+0xc0>
    3d56:       8b 54 24 0c             mov    0xc(%esp),%edx
    3d5a:       8b 44 24 04             mov    0x4(%esp),%eax
    3d5e:       8b 4a 0c                mov    0xc(%edx),%ecx
    3d61:       01 e9                   add    %ebp,%ecx
    3d63:       89 4c 24 08             mov    %ecx,0x8(%esp)
    3d67:       3b 88 94 01 00 00       cmp    0x194(%eax),%ecx
    3d6d:       77 31                   ja     3da0 <blk_rq_map_sg+0xc0>
    3d6f:       8b 15 00 00 00 00       mov    0x0,%edx
    3d75:       8b 0f                   mov    (%edi),%ecx
    3d77:       8b 47 04                mov    0x4(%edi),%eax
    3d7a:       29 d1                   sub    %edx,%ecx
    3d7c:       c1 f9 05                sar    $0x5,%ecx
    3d7f:       c1 e1 0c                shl    $0xc,%ecx
    3d82:       03 4f 08                add    0x8(%edi),%ecx
    3d85:       8d 3c 01                lea    (%ecx,%eax,1),%edi
    3d88:       8b 06                   mov    (%esi),%eax
    3d8a:       29 d0                   sub    %edx,%eax
    3d8c:       c1 f8 05                sar    $0x5,%eax
    3d8f:       c1 e0 0c                shl    $0xc,%eax
    3d92:       03 46 08                add    0x8(%esi),%eax
    3d95:       39 c7                   cmp    %eax,%edi
    3d97:       74 76                   je     3e0f <blk_rq_map_sg+0x12f>
    3d99:       8d b4 26 00 00 00 00    lea    0x0(%esi),%esi
    3da0:       8d 43 10                lea    0x10(%ebx),%eax
    3da3:       b9 04 00 00 00          mov    $0x4,%ecx
    3da8:       89 04 24                mov    %eax,(%esp)
    3dab:       8b 43 10                mov    0x10(%ebx),%eax     <<<<--------- dies here
    3dae:       89 df                   mov    %ebx,%edi
    3db0:       89 c2                   mov    %eax,%edx
    3db2:       83 e2 fe                and    $0xfffffffe,%edx
    3db5:       a8 01                   test   $0x1,%al
    3db7:       0f 44 14 24             cmove  (%esp),%edx
    3dbb:       31 c0                   xor    %eax,%eax
    3dbd:       f3 ab                   rep stos %eax,%es:(%edi)
    3dbf:       8b 06                   mov    (%esi),%eax
    3dc1:       89 6b 0c                mov    %ebp,0xc(%ebx)
    3dc4:       89 03                   mov    %eax,(%ebx)
    3dc6:       8b 46 08                mov    0x8(%esi),%eax
    3dc9:       89 43 04                mov    %eax,0x4(%ebx)
    3dcc:       83 44 24 10 01          addl   $0x1,0x10(%esp)
    3dd1:       89 5c 24 0c             mov    %ebx,0xc(%esp)
    3dd5:       89 d3                   mov    %edx,%ebx
    3dd7:       8b 54 24 1c             mov    0x1c(%esp),%edx
