Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZKTO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZKTO2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZKTO2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:28:24 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:60743 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbZKTO2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:28:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uvtaRedAtc4VZaIEokefNbEFuGN3yjyP6oh0q0UrraeOau/7vJAZWhxp+vJQYqyZ3f
         qlg3C4fH04lmm+GDngjL4yhAblwCFxzr7//tB4KbGOtQi4yzJcMmo+1gjQ5ReBn79xzU
         N/tXVqu+4V7TVxAy0nCFEj6TWk4A+/mrSt5Y8=
MIME-Version: 1.0
In-Reply-To: <20091120141840.GA5872@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091118153227.GA5796@redhat.com>
	 <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
	 <20091118225626.GA2974@redhat.com>
	 <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com>
	 <20091120141840.GA5872@redhat.com>
Date: Fri, 20 Nov 2009 15:28:27 +0100
Message-ID: <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: multipart/mixed; boundary=0016e6d261d509798c0478ce4a7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d261d509798c0478ce4a7d
Content-Type: text/plain; charset=UTF-8

Hi Vivek,
On Fri, Nov 20, 2009 at 3:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Corrado,
>
> I liked the idea of putting all the sync-noidle queues together in root
> group to achieve better throughput and implemeted a small patch.
>
> It works fine for random readers. But when I do multiple direct random writers
> in one group vs a random reader in other group, I am getting strange
> behavior. Random reader moves to root group as sync-noidle workload. But
> random writers are largely sync queues in remain in other group. But many
> a times also jump into root group and preempt random reader.

can you try the attached patches?
They fix the problems you identified about no-idle preemption, and
deep seeky queues.
With those, you should not see this jumping any more.
I'll send them to Jens as soon has he comes back from vacation.

Corrado

> Anyway, with 4 random writers and 1 random reader running for 30 seconds
> in root group I get following.
>
> rw: 59,963KB/s
> rr: 66KB/s
>
> But if these are put in seprate groups test1 and test2 then
>
> rw: 30,587KB/s
> rr: 23KB/s
>
> I can understand the drop in rw throughput as it has been put under a
> group of weight 500. But rr will run in root group with weight 1000 and
> should have received much higher BW, instead it ends up loosing.
>
> Staring hard at blktrace output to figure out what's happening. One thing
> noticeable so far is that without cgroup stuff we seem to be interleaving
> dispatch from random reader and random writer much better as compared to
> with cgroup stuff.
>
> Thanks
> Vivek
>

--0016e6d261d509798c0478ce4a7d
Content-Type: application/octet-stream; 
	name="0001-cfq-iosched-fix-no-idle-preemption-logic.patch"
Content-Disposition: attachment; 
	filename="0001-cfq-iosched-fix-no-idle-preemption-logic.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g291ivix0

RnJvbSAzY2UyYjY5N2I5ZGQxYmYwN2JhM2MxNjFlZWI0MjY0Y2MxYTIxYWEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGNvcnJhZG9AZXQyLihub25lKT4K
RGF0ZTogRnJpLCAyMCBOb3YgMjAwOSAxNDo0MzowMiArMDEwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBjZnEtaW9zY2hlZDogZml4IG5vLWlkbGUgcHJlZW1wdGlvbiBsb2dpYwoKQW4gaW5jb21pbmcg
bm8taWRsZSBxdWV1ZSBzaG91bGQgcHJlZW1wdCB0aGUgYWN0aXZlIG5vLWlkbGUgcXVldWUKb25s
eSBpZiB0aGUgYWN0aXZlIHF1ZXVlIGlzIGlkbGluZyBkdWUgdG8gc2VydmljZSB0cmVlIGVtcHR5
LgpUaGlzIGNoYW5nZSBzaG91bGQgYWZmZWN0IG9ubHkgbm9uLU5DUSByb3RhdGlvbmFsIGRldmlj
ZXMsIHNpbmNlCmZvciB0aG9zZSBvbmVzIHdlIGludHJvZHVjZSBhZGRpdGlvbmFsLCBzbWFsbCBp
ZGxlcywgdGhhdCBzaG91bGRuJ3QKYmUgcHJlZW1wdGVkLgoKUmVwb3J0ZWQtYnk6IFZpdmVrIEdv
eWFsIDx2Z295YWxAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogQ29ycmFkbyBab2Njb2xvIDxj
em9jY29sb0BnbWFpbC5jb20+Ci0tLQogYmxvY2svY2ZxLWlvc2NoZWQuYyB8ICAgIDUgKysrLS0K
IDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMgYi9ibG9jay9jZnEtaW9zY2hlZC5jCmluZGV4IDY5
MjVhYjkuLmE4ZjdhMjYgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMKKysrIGIvYmxv
Y2svY2ZxLWlvc2NoZWQuYwpAQCAtMjQwMSw4ICsyNDAxLDkgQEAgY2ZxX3Nob3VsZF9wcmVlbXB0
KHN0cnVjdCBjZnFfZGF0YSAqY2ZxZCwgc3RydWN0IGNmcV9xdWV1ZSAqbmV3X2NmcXEsCiAJaWYg
KGNmcV9jbGFzc19pZGxlKGNmcXEpKQogCQlyZXR1cm4gdHJ1ZTsKIAotCWlmIChjZnFkLT5zZXJ2
aW5nX3R5cGUgPT0gU1lOQ19OT0lETEVfV09SS0xPQUQKLQkgICAgJiYgbmV3X2NmcXEtPnNlcnZp
Y2VfdHJlZSA9PSBjZnFxLT5zZXJ2aWNlX3RyZWUpCisJaWYgKGNmcWQtPnNlcnZpbmdfdHlwZSA9
PSBTWU5DX05PSURMRV9XT1JLTE9BRCAmJgorCSAgICBjZnFxX3R5cGUobmV3X2NmcXEpID09IFNZ
TkNfTk9JRExFX1dPUktMT0FEICYmCisJICAgIG5ld19jZnFxLT5zZXJ2aWNlX3RyZWUtPiBjb3Vu
dCA9PSAxKQogCQlyZXR1cm4gdHJ1ZTsKIAogCS8qCi0tIAoxLjYuMi41Cgo=
--0016e6d261d509798c0478ce4a7d
Content-Type: application/octet-stream; 
	name="0002-cfq-iosched-idling-on-deep-seeky-sync-queues.patch"
Content-Disposition: attachment; 
	filename="0002-cfq-iosched-idling-on-deep-seeky-sync-queues.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g291jaqv1

RnJvbSA2NDNkZmQxOWUxMTQzNTIxZTI0YTc2ZDg2NzFjMWMwYjllMWY5MGEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGNvcnJhZG9AZXQyLihub25lKT4K
RGF0ZTogRnJpLCAyMCBOb3YgMjAwOSAxNDo1NTo1NCArMDEwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBjZnEtaW9zY2hlZDogaWRsaW5nIG9uIGRlZXAgc2Vla3kgc3luYyBxdWV1ZXMKClNlZWt5IHN5
bmMgcXVldWVzIHdpdGggbGFyZ2UgZGVwdGggY2FuIGdhaW4gdW5mYWlybHkgYmlnIHNoYXJlIG9m
IGRpc2sKdGltZSwgYXQgdGhlIGV4cGVuc2Ugb2Ygb3RoZXIgc2Vla3kgcXVldWVzLiBUaGlzIHBh
dGNoIGVuc3VyZXMgdGhhdAppZGxpbmcgd2lsbCBiZSBlbmFibGVkIGZvciBxdWV1ZXMgd2l0aCBJ
L08gZGVwdGggYXQgbGVhc3QgNC4KClRoZSByZWFzb25pbmcgYmVoaW5kIHRoZSBkZWNpc2lvbiBp
cyB0aGF0LCBpZiBhbiBhcHBsaWNhdGlvbiBpcyB1c2luZwpsYXJnZSBJL08gZGVwdGgsIGl0IGlz
IGFscmVhZHkgb3B0aW1pemVkIHRvIG1ha2UgZnVsbCB1dGlsaXphdGlvbiBvZgp0aGUgaGFyZHdh
cmUsIGFuZCB0aGVyZWZvcmUgd2UgcmVzZXJ2ZSBhIHNsaWNlIG9mIGV4Y2x1c2l2ZSB1c2UgZm9y
IGl0LgoKU2lnbmVkLW9mZi1ieTogQ29ycmFkbyBab2Njb2xvIDxjem9jY29sb0BnbWFpbC5jb20+
Ci0tLQogYmxvY2svY2ZxLWlvc2NoZWQuYyB8ICAgIDYgKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9ibG9jay9jZnEt
aW9zY2hlZC5jIGIvYmxvY2svY2ZxLWlvc2NoZWQuYwppbmRleCBhOGY3YTI2Li40ZjY3YmMyIDEw
MDY0NAotLS0gYS9ibG9jay9jZnEtaW9zY2hlZC5jCisrKyBiL2Jsb2NrL2NmcS1pb3NjaGVkLmMK
QEAgLTIzNTksOCArMjM1OSwxMCBAQCBjZnFfdXBkYXRlX2lkbGVfd2luZG93KHN0cnVjdCBjZnFf
ZGF0YSAqY2ZxZCwgc3RydWN0IGNmcV9xdWV1ZSAqY2ZxcSwKIAogCWVuYWJsZV9pZGxlID0gb2xk
X2lkbGUgPSBjZnFfY2ZxcV9pZGxlX3dpbmRvdyhjZnFxKTsKIAotCWlmICghYXRvbWljX3JlYWQo
JmNpYy0+aW9jLT5ucl90YXNrcykgfHwgIWNmcWQtPmNmcV9zbGljZV9pZGxlIHx8Ci0JICAgIChz
YW1wbGVfdmFsaWQoY2ZxcS0+c2Vla19zYW1wbGVzKSAmJiBDRlFRX1NFRUtZKGNmcXEpKSkKKwlp
ZiAoY2ZxcS0+cXVldWVkWzBdICsgY2ZxcS0+cXVldWVkWzFdID49IDQpCisJCWVuYWJsZV9pZGxl
ID0gMTsKKwllbHNlIGlmICghYXRvbWljX3JlYWQoJmNpYy0+aW9jLT5ucl90YXNrcykgfHwgIWNm
cWQtPmNmcV9zbGljZV9pZGxlIHx8CisJCSAoc2FtcGxlX3ZhbGlkKGNmcXEtPnNlZWtfc2FtcGxl
cykgJiYgQ0ZRUV9TRUVLWShjZnFxKSkpCiAJCWVuYWJsZV9pZGxlID0gMDsKIAllbHNlIGlmIChz
YW1wbGVfdmFsaWQoY2ljLT50dGltZV9zYW1wbGVzKSkgewogCQlpZiAoY2ljLT50dGltZV9tZWFu
ID4gY2ZxZC0+Y2ZxX3NsaWNlX2lkbGUpCi0tIAoxLjYuMi41Cgo=
--0016e6d261d509798c0478ce4a7d--
