Return-Path: <linux-kernel-owner+w=401wt.eu-S1761124AbYGAQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761124AbYGAQ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbYGAQ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:27:47 -0400
Received: from gw.goop.org ([64.81.55.164]:60043 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774AbYGAQ1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:27:45 -0400
Message-ID: <486A5AFC.1090707@goop.org>
Date: Tue, 01 Jul 2008 09:27:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org> <m1skuuov4t.fsf@frodo.ebiederm.org>
In-Reply-To: <m1skuuov4t.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> No, the original crash being discussed was a GP fault in head_64.S as it tries
>> to initialize the kernel segments.  The cause was that the prototype GDT is all
>> zero, even though it's an initialized variable, and inspection of vmlinux shows
>> that it has the right contents.  But somehow it's either 1) getting zeroed on
>> load, or 2) is loaded to the wrong place.
>>
>> The zero-based PDA mechanism requires the introduction of a new ELF segment
>> based at vaddr 0 which is sufficiently unusual that it wouldn't surprise me if
>> its triggering some toolchain bug.
>>     
>
> Agreed.  Given the previous description my hunch is that the bug is occurring
> during objcopy.  If vmlinux is good and the compressed kernel is bad.
>
> It should be possible to look at vmlinux.bin and see if that was generated
> properly.
>
>   
>> Mike: what would happen if the PDA were based at 4k rather than 0?  The stack
>> canary would still be at its small offset (0x20?), but it doesn't need to be
>> initialized.  I'm not sure if doing so would fix anything, however.
>>     
>
> I'm dense today.  Why are we doing a zero based pda?  That seems the most
> likely culprit of linker trouble, and we should be able to  put a smaller
> offset in the segment register to allow for everything to work as expected.
>   

The only reason we need to do a zero-based PDA is because of the 
boneheaded gcc/x86_64 ABI decision to put the stack canary at a fixed 
offset from %gs (all they had to do was define it as a weak symbol we 
could override).  If we want to support stack-protector and unify the 
handling of per-cpu variables, we need to rebase the per-cpu area at 
zero, starting with the PDA.

My own inclination would be to drop stack-protector support until gcc 
gets fixed, rather than letting it prevent us from unifying an area 
which is in need of unification...

    J
