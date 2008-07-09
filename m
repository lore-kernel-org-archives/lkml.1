Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYGIRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYGIRwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYGIRwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:52:07 -0400
Received: from gw.goop.org ([64.81.55.164]:33927 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYGIRwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:52:05 -0400
Message-ID: <4874FAB2.5080401@goop.org>
Date: Wed, 09 Jul 2008 10:51:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org>
In-Reply-To: <4874F7D9.5060607@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> What is the point of the pda_X interface? It does not exist on 32 bit.
> The pda wastes the GS segment register on a small memory area. This patchset
> makes the GS segment usable to reach all of the per cpu area by placing
> the pda into the per cpu area. Thus the pda_X interface becomes obsolete
> and the 32 bit per cpu stuff becomes usable under 64 bit unifying both
> architectures.
>   

I think we agree on the desired outcome.  I just disagree with the path 
to getting there.

>> I think we should start devolving things out of the pda in the other
>> direction: make a series where each patch takes a member of struct
>> x8664_pda, converts it to a per-cpu variable (where possible, the same
>> one that 32-bit uses), and updates all the references accordingly.  When
>> the pda is as empty as it can be, we can look at removing the
>> pda-specific interfaces.
>>     
>
> This patchset places the whole x8664_pda structure into the per cpu area and makes the pda macros operate on the x8664_pda structure in the per cpu area. Not sure why you want to go through the churn of doing it for each object separately.
>   

No, it's not churn doing it object at a time.  If you convert 
pda.pcurrent into a percpu current_task variable, then at one stroke 
you've 1) shrunk the pda, 2) unified with i386.  If you go through the 
process of converting all the read_pda(pcurrent) references into 
x86_read_percpu(pda.pcurrent) then that's a pure churn patch.  It 
doesn't get rid of the pda variable, it doesn't unify with i386.  All it 
does is remove a reference to a macro which was fairly inoffensive in 
the first place.

Once the pda has shrunk as much as it can (which remove everything 
except stack_canary, I think), then remove all the X_pda macros, since 
there won't be any users anyway.

    J
