Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYGJRWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYGJRWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYGJRWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:22:09 -0400
Received: from gw.goop.org ([64.81.55.164]:53993 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYGJRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:22:08 -0400
Message-ID: <48764530.7000909@goop.org>
Date: Thu, 10 Jul 2008 10:21:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487637DE.1050706@zytor.com> <48763A5E.7080105@linux-foundation.org> <48763B36.80104@zytor.com> <48763D1C.8040206@linux-foundation.org>
In-Reply-To: <48763D1C.8040206@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> H. Peter Anvin wrote:
>   
>> Christoph Lameter wrote:
>>     
>>> H. Peter Anvin wrote:
>>>
>>>       
>>>> No, since the *addresses* can be arbitrary.  The current issue is about
>>>> *offsets.*
>>>>         
>>> Well those are intimately connected.
>>>       
>> Not really, since gs_base is an arbitrary 64-bit pointer.
>>     
>
> The current scheme ties the offsets to kernel code addresses.
>   

This is getting very frustrating.  We've been going around and around on 
this point, what, 5 or 6 times at least.

The base address of the percpu area and the offsets from that base are 
completely independent values.

The offset is limited to 2G.  The 2G limit applies regardless of how you 
compute your effective address.  It doesn't matter if its absolute.  It 
doesn't matter if it's rip-relative.  It doesn't matter if it's 
zero-based.  Small absolute addresses generate exactly the same form as 
large absolute addresses.  There is no 8-bit or 16-bit address mode.

The base is arbitrary.  It can be any canonical address at all.  It has 
no effect on how you compute your offset.

The addressing modes:

    * ABS
    * off(%rip)

Are exactly equivalent in what offsets they can generate, so long as *at 
link time* the percpu *symbols* are within 2G of the code addressing 
them.  *After* the addressing mode has generated an effective address 
(by whatever means it likes), the %gs: override applies the segment 
base, which can therefore offset the effective address to anywhere at all.

    J
