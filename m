Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbZCPOQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbZCPOQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbZCPOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:16:15 -0400
Received: from norkia.v3.sk ([92.240.234.41]:33780 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbZCPOQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:16:14 -0400
Subject: Re: [PATCH] Fix NULL dereference when suspending snd_opl3sa2
From: Lubomir Rintel <lkundrak@v3.sk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-sound@vger.kernel.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1237197709.7210.2.camel@localhost.localdomain>
References: <1237197709.7210.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 15:16:08 +0100
Message-Id: <1237212968.11067.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 11:01 +0100, Lubomir Rintel wrote:
> This should fix the following OOPS:
> http://www.kerneloops.org/raw.php?rawid=80591&msgid=

Wrong, sorry, the disassembly from kerneloops was a bit confusing to me.
Looking at the disassembly of the actual module:

> @@ -553,7 +553,8 @@ static int snd_opl3sa2_suspend(struct snd_card
> *card, pm_message_t state)
>  	struct snd_opl3sa2 *chip = card->private_data;

card must somehow be NULL here:

00000270 <snd_opl3sa2_suspend>:
 270:   53                      push   %ebx
 271:   8b 98 38 01 00 00       mov    0x138(%eax),%ebx
 277:   b9 01 00 00 00          mov    $0x1,%ecx
 27c:   ba 03 00 00 00          mov    $0x3,%edx
 281:   c7 80 a8 01 00 00 00    movl   $0x300,0x1a8(%eax)
 288:   03 00 00 
 28b:   05 bc 01 00 00          add    $0x1bc,%eax
 290:   6a 00                   push   $0x0
 292:   e8 fc ff ff ff          call   293 <snd_opl3sa2_suspend+0x23>
 297:   8b 53 24                mov    0x24(%ebx),%edx
 29a:   89 d0                   mov    %edx,%eax
 29c:   ff 92 d4 00 00 00       call   *0xd4(%edx)
 2a2:   89 d8                   mov    %ebx,%eax
 2a4:   b9 27 00 00 00          mov    $0x27,%ecx
 2a9:   ba 01 00 00 00          mov    $0x1,%edx
 2ae:   e8 72 fe ff ff          call   125 <snd_opl3sa2_write>
 2b3:   58                      pop    %eax
 2b4:   31 c0                   xor    %eax,%eax
 2b6:   5b                      pop    %ebx
 2b7:   c3                      ret    

This is the same issue, with 2.6.28:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=519939

