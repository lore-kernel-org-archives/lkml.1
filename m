Return-Path: <linux-kernel-owner+w=401wt.eu-S934337AbZDHQPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbZDHQPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763741AbZDHQPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:15:25 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39439 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760906AbZDHQPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=G/3qt/BmAWBgz7alDfCI+hZuXPMzyoK9CsxIpCJ4uvm4vha7g4C6UMaA5QGqLylWa7
         +sAALmbIQhWl03fy86kmu041MuJPUpeC0X1wHfpPRhhTHnuhxRujRMphGB0ivwm+9VJw
         ZXBvmOYFdoG7Myj0m1o59rHaTEo9c583b5M7Y=
MIME-Version: 1.0
In-Reply-To: <20090408074832.GA11097@elte.hu>
References: <49DC367A.90603@gawab.com> <20090408063240.GQ5178@kernel.dk>
	 <20090408064733.GA16984@elte.hu>
	 <19f34abd0904080027h5b7d2acfp7fdf774e67917175@mail.gmail.com>
	 <20090408074021.GU5178@kernel.dk> <20090408074832.GA11097@elte.hu>
Date: Wed, 8 Apr 2009 18:15:21 +0200
Message-ID: <19f34abd0904080915t1a47cab4jbfe748eeaa47d675@mail.gmail.com>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Arjan van de Ven <arjan@infradead.org>,
       Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: multipart/mixed; boundary=0016e6d77d9b3c3f8004670d700b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d77d9b3c3f8004670d700b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

2009/4/8 Ingo Molnar <mingo@elte.hu>:
>
> * Jens Axboe <jens.axboe@oracle.com> wrote:
>
>> On Wed, Apr 08 2009, Vegard Nossum wrote:

>> > Would you please try this patch? It has the same symptoms as a few
>> > other reports, only that this is 32-bit (and that makes it a bit
>> > different).
>> >
>> > http://marc.info/?l=linux-kernel&m=123909566829773&w=2
>> >
>> > I think Len Brown has applied it to the ACPI tree already.
>>
>> Works for me!
>
> My 'boot hang' problem is independent of that bug i think.

I agree.

The problem is that you have two async port probes:

[   24.177306] calling  1_async_port_probe+0x0/0xaa @ 2841
[   24.177825] calling  2_async_port_probe+0x0/0xaa @ 2842

of which only the first completes, because the first async call itself
tries to flush the async list while holding a lock (the
&shost->scan_mutex in __scsi_add_device), causing deadlock.

In short, I don't think we should call async_synchronize_full() from
scsi_complete_async_scans() at all. I'm including a more detailed
description/justification in the patch (attached).

Arjan, can you comment?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

--0016e6d77d9b3c3f8004670d700b
Content-Type: application/octet-stream; 
	name="0001-scsi-don-t-wait-for-async-operations-in-scsi_comple.patch"
Content-Disposition: attachment; 
	filename="0001-scsi-don-t-wait-for-async-operations-in-scsi_comple.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fta80t3r0

RnJvbSBiZDEyZGU0ZTQwNzQzZDk0ZWI5MGNhYWQ3YzQ5ZDA1ZTRhMDQ1YjFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWZWdhcmQgTm9zc3VtIDx2ZWdhcmQubm9zc3VtQGdtYWlsLmNv
bT4KRGF0ZTogV2VkLCA4IEFwciAyMDA5IDE4OjA1OjQzICswMjAwClN1YmplY3Q6IFtQQVRDSF0g
c2NzaTogZG9uJ3Qgd2FpdCBmb3IgYXN5bmMgb3BlcmF0aW9ucyBpbiBzY3NpX2NvbXBsZXRlX2Fz
eW5jX3NjYW5zKCkKCnNjc2lfY29tcGxldGVfYXN5bmNfc2NhbnMoKSBjYW5ub3QgY2FsbCBhc3lu
Y19zeW5jaHJvbml6ZV9mdWxsKCkgYmVjYXVzZQppdCBtYXkgaG9sZCB0aGUgJnNob3N0LT5zY2Fu
X211dGV4IChpbiBfX3Njc2lfYWRkX2RldmljZSgpLCBmb3IgZXhhbXBsZSkuCgpJIHRoaW5rIGl0
IHdhcyBhbiBlcnJvciB0byBpbnRyb2R1Y2UgdGhlIGNhbGwgdG8gYXN5bmNfc3luY2hyb25pemVf
ZnVsbCgpCmluIHRoZSBmaXJzdCBwbGFjZSwgYmVjYXVzZSBhY2NvcmRpbmcgdG8gc2NzaV9jb21w
bGV0ZV9hc3luY19zY2FucygpLCB3ZQpzaG91bGQgb25seSB3YWl0IGZvciB0aG9zZSBob3N0cyB3
aGljaCBoYXZlIHN0YXJ0ZWQgc2Nhbm5pbmcsIGFuZCBub3QKYWxsIG9mIHRoZW06CgovKioKICog
c2NzaV9jb21wbGV0ZV9hc3luY19zY2FucyAtIFdhaXQgZm9yIGFzeW5jaHJvbm91cyBzY2FucyB0
byBjb21wbGV0ZQogKgogKiBXaGVuIHRoaXMgZnVuY3Rpb24gcmV0dXJucywgYW55IGhvc3Qgd2hp
Y2ggc3RhcnRlZCBzY2FubmluZyBiZWZvcmUKICogdGhpcyBmdW5jdGlvbiB3YXMgY2FsbGVkIHdp
bGwgaGF2ZSBmaW5pc2hlZCBpdHMgc2Nhbi4gIEhvc3RzIHdoaWNoCiAqIHN0YXJ0ZWQgc2Nhbm5p
bmcgYWZ0ZXIgdGhpcyBmdW5jdGlvbiB3YXMgY2FsbGVkIG1heSBvciBtYXkgbm90IGhhdmUKICog
ZmluaXNoZWQuCiAqLwoKVGhvc2UgYXN5bmMgY2FsbHMgd2hpY2ggaGF2ZSBub3QgZXZlbiBzdGFy
dGVkIHdpbGwgbm90IGNvdW50IGFzIGhhdmluZwpzdGFydGVkIGJ5IHRoZSBzY3NpIGNvZGUgZWl0
aGVyLCBzbyBldmVuIHdpdGhvdXQgdGhpcyBjYWxsLCB3ZSBhcmUKZW50aXJlbHkgd2l0aGluIHRo
ZSBzcGVjaWZpY2F0aW9uIG9mIHdoYXQgdGhlIGZ1bmN0aW9uIGlzIHN1cHBvc2VkIHRvCmRvLgoK
VGhpcyBzaG91bGQgZml4IHRoZSBkZWFkbG9jayBhbmQgbm90IGludHJvZHVjZSBhbnkgcmVncmVz
c2lvbnMuCgpSZXBvcnRlZC1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGVsdGUuaHU+ClNpZ25lZC1v
ZmYtYnk6IFZlZ2FyZCBOb3NzdW0gPHZlZ2FyZC5ub3NzdW1AZ21haWwuY29tPgotLS0KIGRyaXZl
cnMvc2NzaS9zY3NpX3NjYW4uYyB8ICAgIDIgLS0KIDEgZmlsZXMgY2hhbmdlZCwgMCBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX3Nj
YW4uYyBiL2RyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYwppbmRleCBhMTRkMjQ1Li42ZjUxY2E0IDEw
MDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9zY2FuLmMKKysrIGIvZHJpdmVycy9zY3NpL3Nj
c2lfc2Nhbi5jCkBAIC0xODAsOCArMTgwLDYgQEAgaW50IHNjc2lfY29tcGxldGVfYXN5bmNfc2Nh
bnModm9pZCkKIAlzcGluX3VubG9jaygmYXN5bmNfc2Nhbl9sb2NrKTsKIAogCWtmcmVlKGRhdGEp
OwotCS8qIFN5bmNocm9uaXplIGFzeW5jIG9wZXJhdGlvbnMgZ2xvYmFsbHkgKi8KLQlhc3luY19z
eW5jaHJvbml6ZV9mdWxsKCk7CiAJcmV0dXJuIDA7CiB9CiAKLS0gCjEuNi4wLjYKCg==
--0016e6d77d9b3c3f8004670d700b--
