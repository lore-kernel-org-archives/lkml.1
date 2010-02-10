Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0BJDQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:16:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:9521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab0BJDQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:16:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,440,1262592000"; 
   d="scan'208";a="594596891"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: Ian Campbell <Ian.Campbell@citrix.com>, Sheng Yang <sheng@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Date: Tue, 9 Feb 2010 19:16:13 -0800
Subject: RE: [Xen-devel] Re: [PATCH 5/7] xen: Make event channel work with
	PV featured HVM
Thread-Topic: [Xen-devel] Re: [PATCH 5/7] xen: Make event channel work with
	PV featured HVM
Thread-Index: AcqpkIG3MD7aRrLWRAKPuGm27wi78wAWbGzg
Message-ID: <54B2EB610B7F1340BB6A0D4CA04A4F1012BABE0E@orsmsx505.amr.corp.intel.com>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
	<1265616354-7384-6-git-send-email-sheng@linux.intel.com>
	<1265716376.24394.32669.camel@zakaz.uk.xensource.com>
	<201002092046.53222.sheng@linux.intel.com>
 <1265724124.24394.33084.camel@zakaz.uk.xensource.com>
In-Reply-To: <1265724124.24394.33084.camel@zakaz.uk.xensource.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1A3H5mE010332

Ian Campbell wrote on Tue, 9 Feb 2010 at 06:02:04:

> On Tue, 2010-02-09 at 12:46 +0000, Sheng Yang wrote:
>> On Tuesday 09 February 2010 19:52:56 Ian Campbell wrote:
>>> On Mon, 2010-02-08 at 08:05 +0000, Sheng Yang wrote:
>>>> +       if (xen_hvm_pv_evtchn_enabled()) {
>>>> +               if (enable_hvm_pv(HVM_PV_EVTCHN))
>>>> +                       return -EINVAL;
>>>> +[...]
>>>> +               callback_via =
>>>> HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR); +
>>>> set_callback_via(callback_via);
>>>> +
>>>> +               x86_platform_ipi_callback =
> do_hvm_pv_evtchn_intr;
>>> 
>>> Why this indirection via X86_PLATFORM_IPI_VECTOR?
>>> 
>>> Apart from that why not use CALLBACKOP_register subop
>>> CALLBACKTYPE_event pointing to xen_hypervisor_callback the same as a
>>> full PV guest?
>>> 
>>> This would remove all the evtchn related code from HVMOP_enable_pv
>>> which I think should be eventually unnecessary as an independent
>>> hypercall since all HVM guests should simply be PV capable by default
>>> -- the hypervisor only needs to track if the guest has made use of
>>> specific PV functionality, not the umbrella "is PV" state.
>>  The reason is the bounce frame buffer implemented by PV guest to
>> inject a event is too complex here... Basically you need to setup a
>> stack like hardware would do, and return to the certain guest CS:IP to
>> handle this. And you need to take care of every case, e.g. guest in the
>> ring0 or ring3, guest in the interrupt context or not, and the
>> recursion of the handler, and so on.
> 
> The code for all this already exists on both the hypervisor and guest
> side in order to support PV guests, would it not just be a case of
> wiring it up for this case as well?

The code is not so useful for HVM guests. The current PV code uses the ring transition which maintains the processor state in the stack, to switch between the hypervisor and the guest, but HVM VM entry/exit does not use the stack at all. To implement an asynchronous event, i.e. callback handler for HVM, the simplest (and reliable) way is to use the architectural event (i.e. IDT-based). Otherwise, we need to modify various VMCS/VMCB fields (e.g. selectors, segments, stacks, etc.) depending on where the last VM happened using the OS-specific knowledge.

Having said that, the interface and implementation are different. I think we can use the same/similar code that registers the callback handler, by hiding such HVM-specific code from the common code path. 

> 
>> Hardware can easily handle all these elegantly, you just need to inject
>> a vector through hardware provided method. That's much easily and
>> elegant. Take the advantage of hardware is still a part of our target.
>> :)
>  I thought one of the points of this patchset was that there was
> overhead associated with the hardware event injection mechanisms which
> you wanted to avoid?

We need to execute VM entry anyway to call back a handler in the guest kernel. Bypassing IDT vectoring does not help.

Jun
___
Intel Open Source Technology Center



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
