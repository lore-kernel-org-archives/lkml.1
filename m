Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYFIUQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYFIUQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYFIUQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:16:31 -0400
Received: from smtp20.orange.fr ([80.12.242.26]:34494 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYFIUQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:16:30 -0400
X-ME-UUID: 20080609201626626.990341C000B6@mwinf2003.orange.fr
Message-ID: <484D8F7E.4070104@cosmosbay.com>
Date: Mon, 09 Jun 2008 22:15:58 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
References: <20080530035620.587204923@sgi.com>	<20080529215827.b659d032.akpm@linux-foundation.org>	<4846AFCF.30500@sgi.com> <4848CC22.6090109@cosmosbay.com>	<Pine.LNX.4.64.0806091136410.30727@schroedinger.engr.sgi.com> <87abhuqv7p.fsf@basil.nowhere.org>
In-Reply-To: <87abhuqv7p.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> Christoph Lameter <clameter@sgi.com> writes:
> 
>> The problem is that offsets relative to %gs or %fs are limited by the 
>> small memory model that is chosen.
> 
> Actually they are not. If you really want you can do 
> movabs $64bit,%reg ; op ...,%gs:(%reg) 
> It's just not very efficient compared to small (or rather kernel) model
> and also older binutils didn't support large model.
> 

I am not sure Christoph was refering to actual instructions.

I was suggesting using for static percpu (vmlinux or modules) :

vmlinux : (offset31 computed by linker at vmlinux link edit time)
incl  %gs:offset31

modules : (offset31 computed at module load time by module loader)
incl %gs:offset31

(If we make sure all this stuff is allocated in first chunk)

And for dynamic percpu :

movq   field(%rdi),%rax
incl    %gs:(%rax)   /* full 64bits 'offsets' */

I understood (but might be wrong again) that %gs itself could not be used with an offset > 2GB, because
the way %gs segment is setup. So in the 'dynamic percpu' case, %rax should not exceed 2^31





