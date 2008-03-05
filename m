Return-Path: <linux-kernel-owner+w=401wt.eu-S934877AbYCEAMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877AbYCEAMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYCEAMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:12:25 -0500
Received: from gw.goop.org ([64.81.55.164]:44789 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYCEAMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:12:25 -0500
Message-ID: <47CDE42F.8080400@goop.org>
Date: Tue, 04 Mar 2008 16:07:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
References: <47CDBB87.8090906@goop.org> <200803050106.31609.ak@suse.de>
In-Reply-To: <200803050106.31609.ak@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Won't this leave a stale tlb on the old processor?
>>     
>
> __set_fixmap should be only used in early boot, so it's always
> on CPU 0

vdso32-setup.c:map_compat_vdso() uses it to create the compat vdso 
mapping, which typically happens on the first execve(), and could happen 
if you turn compat vdso off and on during runtime.  (It follows the call 
with flush_tlb_all(), so there's no risk of stray tlb entries in this case.)

But that answers my broader question about how __set_fixmap can get away 
with just flushing on the current cpu; I'll add a preempt disable 
bracket to keep everyone happy.

Any opinions on set_pte_at(&init_mm, ...) without holding any locks?  
All ok?

    J
