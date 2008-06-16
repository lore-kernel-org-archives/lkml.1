Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYFPEjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYFPEjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 00:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYFPEjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 00:39:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:46621 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYFPEjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 00:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=HhU79K7BMgIehoaIat1Kh7jFuCI7UW9uPKSBtY3bXBfZMEUsbo25dmyhz8imRCZQT0
         eNhYASfKDXSw+r08rSDDOgcwDpV/9m9O4nl2LHNt5RvJlVhSfJ1bR74n35mv6YQ0PH40
         SQ0oaBHjwq+CjF5p7Q1L5bFjsVx3mRsc1XPd8=
Message-ID: <86802c440806152139q13c2a2fay2c518f5b95c3d9ed@mail.gmail.com>
Date: Sun, 15 Jun 2008 21:39:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high pages init
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440806152046s71916de8g6f8e3e8d272d336a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_11775_20759570.1213591149091"
References: <200806132005.45836.yhlu.kernel@gmail.com>
	 <200806140056.32601.yhlu.kernel@gmail.com>
	 <20080614082343.GB11277@elte.hu>
	 <86802c440806140205g3ff113ffq39272c18ef5b9654@mail.gmail.com>
	 <1213579241.2433.7.camel@caritas-dev.intel.com>
	 <86802c440806152046s71916de8g6f8e3e8d272d336a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_11775_20759570.1213591149091
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Jun 15, 2008 at 8:46 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sun, Jun 15, 2008 at 6:20 PM, Huang, Ying <ying.huang@intel.com> wrote:
>> On Sat, 2008-06-14 at 02:05 -0700, Yinghai Lu wrote:
>>> On Sat, Jun 14, 2008 at 1:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>> >
>>> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>> >
>>> >> use early_node_map to init high pages, so can remove page_is_ram and
>>> >> page_is_reserved_early in the big loop with add_one_highpage
>>> >>
>>> >> also remove the page_is_reserved_early that is not needed.
>>> >
>>> > applied to tip/x86/mpparse for testing, thanks.
>>> >
>>> > Andrew: mm/page_alloc.c modification.
>>>
>>> Ying Huang,
>>>
>>> I removed page_is_reserved_early....it cause init highmem take extra
>>> time on my big box.
>>
>> OK.
>>
>>> please check efi_reserve_early that is calling reserve_early. so need
>>> to make sure "EFI memmap" is reserved in itself...otherwise you may
>>> need to update e820 table by add_memory_region (....,
>>> E820_RESERVED)...
>>
>> EFI memmap may be in highmem, it can not be reserved by bootmem
>> allocator on i386. So I think it is necessary to have an early highmem
>> allocator. It can be used for EFI memory map and linked list of setup
>> data which comes from boot-loader and may be located in highmem.
>>
>> As for the implementation, what about adding a remove_active_range()
>> which operate on early_node_map and an early_res_to_early_node_map()?
>
> don't need,
> EFI memmap should be reserved in e820map, so it should not show up in
> early_node_map.
> if it is not reserved in e820map, you could use e820_add_region or
> e820_update_range make it reserved

something like attached patch

YH

------=_Part_11775_20759570.1213591149091
Content-Type: text/x-patch; name=efi_memmap.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhikuiag0
Content-Disposition: attachment; filename=efi_memmap.patch

W1BBVENIXSB4ODY6IHJlc2VydmUgZWZpIG1hcCBpdHNlbGYgaW4gZTgyMCBtYXAKClNpZ25lZC1v
ZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rZXJuZWwvZWZpLmMgYi9hcmNoL3g4Ni9rZXJuZWwvZWZpLmMKaW5kZXggZDVjN2Zj
ZC4uZjA4NjliYiAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2VmaS5jCisrKyBiL2FyY2gv
eDg2L2tlcm5lbC9lZmkuYwpAQCAtMjM1LDYgKzIzNSw4IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBh
ZGRfZWZpX21lbW1hcCh2b2lkKQogCQkJZTgyMF90eXBlID0gRTgyMF9SRVNFUlZFRDsKIAkJZTgy
MF9hZGRfcmVnaW9uKHN0YXJ0LCBzaXplLCBlODIwX3R5cGUpOwogCX0KKwllODIwX2FkZF9yZWdp
b24obWVtbWFwLnBoeXNfbWFwLCBtZW1tYXAubnJfbWFwICogbWVtbWFwLmRlc2Nfc2l6ZSwKKwkJ
CUU4MjBfUkVTRVJWRUQpOwogCXNhbml0aXplX2U4MjBfbWFwKGU4MjAubWFwLCBBUlJBWV9TSVpF
KGU4MjAubWFwKSwgJmU4MjAubnJfbWFwKTsKIH0KIApkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2Vy
bmVsL3NldHVwXzY0LmMgYi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXBfNjQuYwppbmRleCBkZTI2NDVl
Li41ZmEyNDFlIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvc2V0dXBfNjQuYworKysgYi9h
cmNoL3g4Ni9rZXJuZWwvc2V0dXBfNjQuYwpAQCAtMzcwLDYgKzM3MCw5IEBAIHZvaWQgX19pbml0
IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAogCWVhcmx5X2dhcnRfaW9tbXVfY2hlY2so
KTsKIAorCWlmIChlZmlfZW5hYmxlZCkKKwkJZWZpX2luaXQoKTsKKwogCWU4MjBfcmVnaXN0ZXJf
YWN0aXZlX3JlZ2lvbnMoMCwgMCwgLTFVTCk7CiAJLyoKIAkgKiBwYXJ0aWFsbHkgdXNlZCBwYWdl
cyBhcmUgbm90IHVzYWJsZSAtIHRodXMKQEAgLTM5Miw4ICszOTUsNiBAQCB2b2lkIF9faW5pdCBz
ZXR1cF9hcmNoKGNoYXIgKipjbWRsaW5lX3ApCiAJY2hlY2tfZWZlcigpOwogCiAJbWF4X3Bmbl9t
YXBwZWQgPSBpbml0X21lbW9yeV9tYXBwaW5nKDAsIChlbmRfcGZuIDw8IFBBR0VfU0hJRlQpKTsK
LQlpZiAoZWZpX2VuYWJsZWQpCi0JCWVmaV9pbml0KCk7CiAKIAl2c21wX2luaXQoKTsKIAo=
------=_Part_11775_20759570.1213591149091--
