Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXDAKHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXDAKHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 06:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932370AbXDAKHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 06:07:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:41549 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbXDAKHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 06:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=LBpK3f1xaW9/akEA0u3EAqLDCSeD6TvNCkOgAL77E2XmVHLdq9BADj6mENCKxC1iZGVfY9TsP+NSRBIX8J4A3hd/4O7142t6GL+N6G9kyV66YbxmWkc3nrC7eGI/u4arXcs9NCEtNj1d+lSWZDjpzykuTcycX/fTQo5PpzcfDJw=
Message-ID: <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
Date: Sun, 1 Apr 2007 13:06:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <460EA727.8070306@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_55568_8770468.1175422019392"
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
	 <460EA727.8070306@gmail.com>
X-Google-Sender-Auth: 231a1b3dc156577b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_55568_8770468.1175422019392
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 3/31/07, Rene Herman <rene.herman@gmail.com> wrote:
> There's quite a bit of noise in dmesg though. Repeated 5 times:
>
> ===BUG: scheduling while atomic: mount/0x00000001/1166
>   [<c1170bff>] __sched_text_start+0x57/0x574
>   [<c1171964>] schedule_timeout+0x70/0x8f
>   [<c10199b2>] process_timeout+0x0/0x5
>   [<c11716a2>] interruptible_sleep_on_timeout+0x5d/0xa5
>   [<c100e695>] default_wake_function+0x0/0xc
>   [<c482b8fb>] mcdx_xfer+0xae/0x2a5 [mcdx]

[snip]

>   [<c482b473>] do_mcdx_request+0x9b/0xd2 [mcdx]
>   [<c1096d06>] __generic_unplug_device+0x1d/0x1f
>   [<c1096d19>] generic_unplug_device+0x11/0x29

Looks like mcdx_xfer is sleeping while holding q->queue_lock. The
attached (untested) patch should fix it.

------=_Part_55568_8770468.1175422019392
Content-Type: application/octet-stream; 
	name=mcdx-drop-queue_lock-before-sleeping
Content-Transfer-Encoding: base64
X-Attachment-Id: f_1bw1xbn
Content-Disposition: attachment; filename="mcdx-drop-queue_lock-before-sleeping"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2Ryb20vbWNkeC5jIGIvZHJpdmVycy9jZHJvbS9tY2R4LmMK
aW5kZXggZjU3NDk2Mi4uZTE0ZGMwMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9jZHJvbS9tY2R4LmMK
KysrIGIvZHJpdmVycy9jZHJvbS9tY2R4LmMKQEAgLTU3NywxMSArNTc3LDE0IEBAIHN0YXRpYyB2
b2lkIGRvX21jZHhfcmVxdWVzdChyZXF1ZXN0X3F1ZXVlX3QgKiBxKQogCWlmICghcmVxKQogCQly
ZXR1cm47CiAKKwlzcGluX3VubG9ja19pcnEocS0+cXVldWVfbG9jayk7CisKIAlzdHVmZnAgPSBy
ZXEtPnJxX2Rpc2stPnByaXZhdGVfZGF0YTsKIAogCWlmICghc3R1ZmZwLT5wcmVzZW50KSB7CiAJ
CXh3YXJuKCJkb19yZXF1ZXN0KCk6IGJhZCBkZXZpY2U6ICVzXG4iLHJlcS0+cnFfZGlzay0+ZGlz
a19uYW1lKTsKIAkJeHRyYWNlKFJFUVVFU1QsICJlbmRfcmVxdWVzdCgwKTogYmFkIGRldmljZVxu
Iik7CisJCXNwaW5fbG9ja19pcnEocS0+cXVldWVfbG9jayk7CiAJCWVuZF9yZXF1ZXN0KHJlcSwg
MCk7CiAJCXJldHVybjsKIAl9CkBAIC01ODksNiArNTkyLDcgQEAgc3RhdGljIHZvaWQgZG9fbWNk
eF9yZXF1ZXN0KHJlcXVlc3RfcXVldWVfdCAqIHEpCiAJaWYgKHN0dWZmcC0+YXVkaW8pIHsKIAkJ
eHdhcm4oImRvX3JlcXVlc3QoKSBhdHRlbXB0IHRvIHJlYWQgZnJvbSBhdWRpbyBjZFxuIik7CiAJ
CXh0cmFjZShSRVFVRVNULCAiZW5kX3JlcXVlc3QoMCk6IHJlYWQgZnJvbSBhdWRpb1xuIik7CisJ
CXNwaW5fbG9ja19pcnEocS0+cXVldWVfbG9jayk7CiAJCWVuZF9yZXF1ZXN0KHJlcSwgMCk7CiAJ
CXJldHVybjsKIAl9CkBAIC01OTksNiArNjAzLDcgQEAgc3RhdGljIHZvaWQgZG9fbWNkeF9yZXF1
ZXN0KHJlcXVlc3RfcXVldWVfdCAqIHEpCiAJaWYgKHJlcS0+Y21kICE9IFJFQUQpIHsKIAkJeHdh
cm4oImRvX3JlcXVlc3QoKTogbm9uLXJlYWQgY29tbWFuZCB0byBjZCEhXG4iKTsKIAkJeHRyYWNl
KFJFUVVFU1QsICJlbmRfcmVxdWVzdCgwKTogd3JpdGVcbiIpOworCQlzcGluX2xvY2tfaXJxKHEt
PnF1ZXVlX2xvY2spOwogCQllbmRfcmVxdWVzdChyZXEsIDApOwogCQlyZXR1cm47CiAJfQpAQCAt
NjEzLDYgKzYxOCw3IEBAIHN0YXRpYyB2b2lkIGRvX21jZHhfcmVxdWVzdChyZXF1ZXN0X3F1ZXVl
X3QgKiBxKQogCQkJCQkgIHJlcS0+bnJfc2VjdG9ycyk7CiAKIAkJCWlmIChpID09IC0xKSB7CisJ
CQkJc3Bpbl9sb2NrX2lycShxLT5xdWV1ZV9sb2NrKTsKIAkJCQllbmRfcmVxdWVzdChyZXEsIDAp
OwogCQkJCWdvdG8gYWdhaW47CiAJCQl9CkBAIC02MjAsMTAgKzYyNiwxMiBAQCBzdGF0aWMgdm9p
ZCBkb19tY2R4X3JlcXVlc3QocmVxdWVzdF9xdWV1ZV90ICogcSkKIAkJCXJlcS0+bnJfc2VjdG9y
cyAtPSBpOwogCQkJcmVxLT5idWZmZXIgKz0gKGkgKiA1MTIpOwogCQl9CisJCXNwaW5fbG9ja19p
cnEocS0+cXVldWVfbG9jayk7CiAJCWVuZF9yZXF1ZXN0KHJlcSwgMSk7CiAJCWdvdG8gYWdhaW47
CiAKIAkJeHRyYWNlKFJFUVVFU1QsICJlbmRfcmVxdWVzdCgxKVxuIik7CisJCXNwaW5fbG9ja19p
cnEocS0+cXVldWVfbG9jayk7CiAJCWVuZF9yZXF1ZXN0KHJlcSwgMSk7CiAJfQogCg==
------=_Part_55568_8770468.1175422019392--
