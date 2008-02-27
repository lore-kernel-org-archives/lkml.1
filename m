Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbYB0B7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbYB0B7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYB0B7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:59:08 -0500
Received: from mail.mizi.com ([61.107.31.33]:43999 "EHLO mail.mizi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYB0B7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:59:05 -0500
Message-ID: <47C4C3D4.8010902@mizi.com>
Date: Wed, 27 Feb 2008 10:58:44 +0900
From: Louis JANG <louis@mizi.com>
Organization: MIZI Research, Inc.
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Dave Young <hidave.darkstar@gmail.com>, linux-bluetooth@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, bmidgley@gmail.com,
       David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [Bluez-devel] forcing SCO connection patch
References: <47666E1F.2000902@mizi.com>	 <a8e1da0802242330l765b8b1ava62b857baf8a5568@mail.gmail.com>	 <47C28A33.4070102@mizi.com> <a8e1da0802250155u1b7af481va203849f68d9106b@mail.gmail.com> <47C2A7FA.2060902@mizi.com> <70692DDF-93B7-447E-ABEE-3CDBD94F15F1@holtmann.org> <47C38D40.3040809@mizi.com> <B96BD3FE-F490-4AD5-9315-ECD42CE9C728@holtmann.org>
In-Reply-To: <B96BD3FE-F490-4AD5-9315-ECD42CE9C728@holtmann.org>
Content-Type: multipart/mixed;
 boundary="------------040708040207060503030706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040708040207060503030706
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit

Marcel Holtmann ¾´ ±Û:
> Hi Loius,
>
>>>> --- linux-2.6.23/net/bluetooth/hci_event.c.orig 2008-02-25
>>>> 17:17:11.000000000 +0900
>>>> +++ linux-2.6.23/net/bluetooth/hci_event.c 2008-02-25
>>>> 17:30:23.000000000 +0900
>>>> @@ -1313,8 +1313,17 @@
>>>> hci_dev_lock(hdev);
>>>>
>>>> conn = hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr);
>>>> - if (!conn)
>>>> - goto unlock;
>>>> + if (!conn) {
>>>> + if (ev->link_type != ACL_LINK) {
>>>> + __u8 link_type = (ev->link_type == ESCO_LINK) ? SCO_LINK :
>>>> ESCO_LINK;
>>>> +
>>>> + conn = hci_conn_hash_lookup_ba(hdev, link_type, &ev->bdaddr);
>>>> + if (conn)
>>>> + conn->type = ev->link_type;
>>>> + }
>>>> + if (!conn)
>>>> + goto unlock;
>>>> + }
>>>
>>> NAK. There is no need to check for ACL_LINK. The sync_complete will
>>> only be called for SCO or eSCO connections.
>> I see. I removed this check line in the patch.
>>
>> Thanks.
>> Louis JANG
>> Signed-off-by: Louis JANG <louis@mizi.com>
>> --- linux-2.6.23/net/bluetooth/hci_event.c.orig 2008-02-26
>> 12:46:36.000000000 +0900
>> +++ linux-2.6.23/net/bluetooth/hci_event.c 2008-02-26
>> 12:47:23.000000000 +0900
>> @@ -1313,8 +1313,15 @@
>> hci_dev_lock(hdev);
>>
>> conn = hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr);
>> - if (!conn)
>> - goto unlock;
>> + if (!conn) {
>> + __u8 link_type = (ev->link_type == ESCO_LINK) ? SCO_LINK : ESCO_LINK;
>> +
>> + conn = hci_conn_hash_lookup_ba(hdev, link_type, &ev->bdaddr);
>> + if (conn)
>> + conn->type = ev->link_type;
>> + else
>> + goto unlock;
>> + }
>>
>> if (!ev->status) {
>> conn->handle = __le16_to_cpu(ev->handle);
>
> do something like this:
>
> if (!conn) {
> ....
>
> conn = ....
> if (!conn)
> goto unlock;
>
> conn->type = ev->link_type;
> }
>
> And include a description when submitting a patch.
>
> Regards
>
> Marcel
I changed code with this style and included patch description.
Thanks

Louis JANG

--------------040708040207060503030706
Content-Type: text/plain;
 name="patch_hci_event.c5"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch_hci_event.c5"

VGhpcyBwYXRjaCBpcyB0byBoYW5kbGUgZGlmZmVyZW50IHR5cGUgb2Ygc3luY2hyb25vdXMg
bGluayBpcyAKZXN0YWJpbGlzaGVkIHdpdGggaXRzIHJlcXVlc3QuCgpTaWduZWQtb2ZmLWJ5
OiBMb3VpcyBKQU5HIDxsb3Vpc0BtaXppLmNvbT4KLS0tIGxpbnV4LTIuNi4yMy9uZXQvYmx1
ZXRvb3RoL2hjaV9ldmVudC5jLm9yaWcJMjAwOC0wMi0yNiAxMjo0NjozNi4wMDAwMDAwMDAg
KzA5MDAKKysrIGxpbnV4LTIuNi4yMy9uZXQvYmx1ZXRvb3RoL2hjaV9ldmVudC5jCTIwMDgt
MDItMjcgMTA6NDg6MjkuMDAwMDAwMDAwICswOTAwCkBAIC0xMzEzLDggKzEzMTMsMTUgQEAK
IAloY2lfZGV2X2xvY2soaGRldik7CiAKIAljb25uID0gaGNpX2Nvbm5faGFzaF9sb29rdXBf
YmEoaGRldiwgZXYtPmxpbmtfdHlwZSwgJmV2LT5iZGFkZHIpOwotCWlmICghY29ubikKLQkJ
Z290byB1bmxvY2s7CisJaWYgKCFjb25uKSB7CisJCV9fdTggbGlua190eXBlID0gKGV2LT5s
aW5rX3R5cGUgPT0gRVNDT19MSU5LKSA/IFNDT19MSU5LIDogRVNDT19MSU5LOworCisJCWNv
bm4gPSBoY2lfY29ubl9oYXNoX2xvb2t1cF9iYShoZGV2LCBsaW5rX3R5cGUsICZldi0+YmRh
ZGRyKTsKKwkJaWYgKCFjb25uKQorCQkJZ290byB1bmxvY2s7CisKKwkJY29ubi0+dHlwZSA9
IGV2LT5saW5rX3R5cGU7CisJfQogCiAJaWYgKCFldi0+c3RhdHVzKSB7CiAJCWNvbm4tPmhh
bmRsZSA9IF9fbGUxNl90b19jcHUoZXYtPmhhbmRsZSk7Cg==
--------------040708040207060503030706--
