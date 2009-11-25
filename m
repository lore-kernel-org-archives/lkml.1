Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbZKYJqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbZKYJqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZKYJqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:46:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:57062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZKYJqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:46:46 -0500
Message-ID: <4B0CFCA6.5070708@kernel.org>
Date: Wed, 25 Nov 2009 01:45:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
References: <4B0C7257.3070609@kernel.org> <20091125081832.GA1822@elte.hu> <4B0CF0CA.30807@kernel.org> <20091125180517P.fujita.tomonori@lab.ntt.co.jp> <20091125091026.GA11117@elte.hu>
In-Reply-To: <20091125091026.GA11117@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
>> On Wed, 25 Nov 2009 00:54:34 -0800
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> only remember that SLES 9 SP3 (?) at some point has problem with AMD 
>>> 10h ( quad core version) when memory > 4 g (with USB controller ?) 
>>> because the gart code only check K8 device id, and didn't check 10h 
>>> device id. so gart iommu is not used. and happenly swiotlb code has 
>>> problem with that kernel version.
>>>
>>> thinking we should keep old behavior, until some day we can remove 
>>> them all.
>> Why? We are talking about changing 2.6.33 behavior. swiotlb in 2.6.33 
>> should be the safe option.
> 
> If that behavior was relied on for suspected (or real) bugs in the 
> swiotlb code then i agree that we should do this change. (and fix any 
> bugs if they still occur.)

after look at gart_iommu_hole_init() closely,

should be

for AMD 64bit, MEM > 4g, no AGP, iommu=soft
1. if BIOS have correct gart setting, Kernel will use swiotlb
2. if BIOS does not have correct gart setting, Kernel will use swiotlb

and for the all the cases, the codes after that 
/* Fix up the north bridges */
...

will disable the translation...

so even swiotlb=soft is used, gart_iommu_hole_init() still need to be called. to make sure aperture is disabled somehow.

YH
