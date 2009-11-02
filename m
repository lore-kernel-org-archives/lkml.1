Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZKBAxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZKBAxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZKBAxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:53:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbZKBAxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:53:50 -0500
Date: Sun, 1 Nov 2009 16:53:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wpa2 hangs v2.6.32-rc5-402-gb6727b1. Revert
 7d930bc33653d5592dc386a76a38f39c2e962344  fixed it.
In-Reply-To: <b6a2187b0911011612v4a874640s62105a7323b01ad0@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0911011641101.31845@localhost.localdomain>
References: <Pine.LNX.4.64.0911012318000.3549@boston.corp.fedex.com>  <1257089345.3555.158.camel@johannes.local> <b6a2187b0911011612v4a874640s62105a7323b01ad0@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Nov 2009, Jeff Chua wrote:
> 
> I don't know how to redirect the console dump to a file. So, attached is
> what it displayed taken from a camera.

That decodes to 

cfg80211_conn_work+89:

   3:	89 ef                	mov    %ebp,%edi
   5:	e8 6f be 41 e1       	callq  0xffffffffe141be79
   a:	48 8b 43 20          	mov    0x20(%rbx),%rax
   e:	f6 40 48 01          	testb  $0x1,0x48(%rax)
  12:	74 5d                	je     0x71
  14:	83 bb 8c 00 00 00 01 	cmpl   $0x1,0x8c(%rbx)
  1b:	75 54                	jne    0x71
  1d:	48 ?? 50 08          	???    0x8(%rax) ???? uncertain instruction ????
  21:*	8b 02                	mov    (%rdx),%eax     <-- trapping instruction
  23:	41 89 45 00          	mov    %eax,0x0(%r13)
  27:	66 8b 42 04          	mov    0x4(%rdx),%ax
  2b:	66 41 89 45 04       	mov    %ax,0x4(%r13)
  30:	e8 f5 ea ff ff       	callq  0xffffffffffffeb2a

trace:
  __cfg80111_scan_done
  worker_thread

which looks like it matches this code:

        movq    %r14, %rdi      # D.43604,
        call    mutex_lock      #
        movq    32(%rbx), %rax  # <variable>.netdev, <variable>.netdev
        testb   $1, 72(%rax)    #, <variable>.state
        je      .L215   #,
        cmpl    $1, 140(%rbx)   #, <variable>.sme_state
        jne     .L215   #,
        movq    144(%rbx), %rax # <variable>.conn, <variable>.conn
        movq    %rbx, %rdi      # wdev,
        movq    8(%rax), %rax   # <variable>.params.bssid, <variable>.params.bssid
        movl    (%rax), %edx    #* <variable>.params.bssid, tmp74
        movl    %edx, 0(%r13)   # tmp74, bssid
        movw    4(%rax), %ax    #, tmp75
        movw    %ax, 4(%r13)    # tmp75, bssid
        call    cfg80211_conn_do_work   #

ie it looks like 'conn->params.bssid' is NULL and we oops when we try to 
load bssid from there. The code is:

	memcpy(bssid, wdev->conn->params.bssid, ETH_ALEN);

where ETH_ALEN is 6 bytes, so the memcpy is inlined..

And yes, that "memcpy()" was added in that buggy commit. 

So reverting 7d930bc33653d5592dc386a76a38f39c2e962344 is the correct thing 
to do. Or somebody needs to fix that piece-of-shit code.

		Linus
