Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbXJUBeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbXJUBeP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbXJUBeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:34:01 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4536 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750761AbXJUBeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:34:00 -0400
Date: Sat, 20 Oct 2007 21:33:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices
In-Reply-To: <1192835183.5418.6.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0710192156460.23656-200000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1609956864-649327256-1192930438=:21971"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1609956864-649327256-1192930438=:21971
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Sat, 20 Oct 2007, Kay Sievers wrote:

> Here is what I see, the error handler hangs without the final put and
> the kobject never gets cleaned up. Note the missing:
>   kobject sdb: cleaning up
> 
> What is your CONFIG_SYSFS_DEPRECATED option? I have it unset, and that
> may be the difference in the behavior if you have it set.

It's unset in my config also.  No, the difference lies somewhere else.
The plug-in parts are the same, but we differ in the remove parts.  On 
your system, unlink_gendisk ends up dropping only one reference instead 
of two.  This suggests that something strange is happening to the 
request_queue on your machine.

Can you try running the attached patch (without the previous patch)?  
It traces the various release routines.  The idea is that both the
scsi_disk and the scsi_device hold references to the request_queue,
and these references get dropped in their respective release routines.

Just for the record, here's what happens with this patch on my system,
without the put_device call in del_gendisk (the patch comments it out).  
I plugged in a USB drive and let things settle down.  Then unplugging
the drive gave this:

[  457.916995] usb 6-4: USB disconnect, address 3
[  457.918459] usb 6-4: unregistering device
[  457.920570] usb 6-4: usb_disable_device nuking all URBs
[  457.920859] usb 6-4: unregistering interface 6-4:1.0
[  457.958990] disk_release: kobj cedcda50

The line above refers to the /dev/sda1 partition.  Ignore it.

[  458.012317] del_gendisk sda, kobj ce8be990, queue cd9b2000, refcount before put_device 2

2 references: one from the scsi_disk and one from the request_queue.

[  458.013133] scsi_disk_release: disk sda, kobj ce8be990, refcount before put_disk 2
[  458.032420] scsi_device_dev_release: rq cd9b2000

These lines show where the two references to the request_queue get 
dropped.  As a result the queue is released, causing the gendisk to be 
released as well:

[  458.032766] blk_release_queue: rq cd9b2000, parent ce8be990
[  458.032973] disk_release: kobj ce8be990
[  458.051641] usb 6-4:1.0: uevent
[  458.052001] usb 6-4:1.0: uevent
[  458.068665] usb 6-4: uevent

If you don't get a similar sequence of events, it must indicate that 
something on your system continues to hold an outstanding reference.  
Maybe an automounter program, or something like that.

Alan Stern

---1609956864-649327256-1192930438=:21971
Content-Type: TEXT/plain; name="disktest.txt"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.0710202133580.21971@netrider.rowland.org>
Content-Description: test patch 2
Content-Disposition: attachment; filename="disktest.txt"

SW5kZXg6IDIuNi4yMy9ibG9jay9nZW5oZC5jDQo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09DQotLS0gMi42LjIzLm9yaWcvYmxvY2svZ2VuaGQuYw0KKysrIDIu
Ni4yMy9ibG9jay9nZW5oZC5jDQpAQCAtNDk2LDYgKzQ5Niw3IEBAIHN0YXRp
YyB2b2lkIGRpc2tfcmVsZWFzZShzdHJ1Y3QgZGV2aWNlICoNCiB7DQogCXN0
cnVjdCBnZW5kaXNrICpkaXNrID0gZGV2X3RvX2Rpc2soZGV2KTsNCiANCisJ
cHJpbnRrKEtFUk5fSU5GTyAiZGlza19yZWxlYXNlOiBrb2JqICVwXG4iLCAm
ZGlzay0+ZGV2LmtvYmopOw0KIAlrZnJlZShkaXNrLT5yYW5kb20pOw0KIAlr
ZnJlZShkaXNrLT5wYXJ0KTsNCiAJZnJlZV9kaXNrX3N0YXRzKGRpc2spOw0K
SW5kZXg6IDIuNi4yMy9ibG9jay9sbF9yd19ibGsuYw0KPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQ0KLS0tIDIuNi4yMy5vcmlnL2Jsb2NrL2xsX3J3X2Jsay5j
DQorKysgMi42LjIzL2Jsb2NrL2xsX3J3X2Jsay5jDQpAQCAtMTc4MSw2ICsx
NzgxLDggQEAgc3RhdGljIHZvaWQgYmxrX3JlbGVhc2VfcXVldWUoc3RydWN0
IGtvYg0KIAkJY29udGFpbmVyX29mKGtvYmosIHN0cnVjdCByZXF1ZXN0X3F1
ZXVlLCBrb2JqKTsNCiAJc3RydWN0IHJlcXVlc3RfbGlzdCAqcmwgPSAmcS0+
cnE7DQogDQorCXByaW50ayhLRVJOX0lORk8gImJsa19yZWxlYXNlX3F1ZXVl
OiBycSAlcCwgcGFyZW50ICVwXG4iLA0KKwkJCXEsIHEtPmtvYmoucGFyZW50
KTsNCiAJYmxrX3N5bmNfcXVldWUocSk7DQogDQogCWlmIChybC0+cnFfcG9v
bCkNCkluZGV4OiAyLjYuMjMvZHJpdmVycy9zY3NpL3Njc2lfc3lzZnMuYw0K
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIDIuNi4yMy5vcmlnL2RyaXZl
cnMvc2NzaS9zY3NpX3N5c2ZzLmMNCisrKyAyLjYuMjMvZHJpdmVycy9zY3Np
L3Njc2lfc3lzZnMuYw0KQEAgLTIzOCw2ICsyMzgsOCBAQCBzdGF0aWMgdm9p
ZCBzY3NpX2RldmljZV9kZXZfcmVsZWFzZV91c2VyDQogCWxpc3RfZGVsKCZz
ZGV2LT5zdGFydmVkX2VudHJ5KTsNCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZShzZGV2LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiANCisJcHJpbnRr
KEtFUk5fSU5GTyAic2NzaV9kZXZpY2VfZGV2X3JlbGVhc2U6IHJxICVwXG4i
LA0KKwkJCXNkZXYtPnJlcXVlc3RfcXVldWUpOw0KIAlpZiAoc2Rldi0+cmVx
dWVzdF9xdWV1ZSkgew0KIAkJc2Rldi0+cmVxdWVzdF9xdWV1ZS0+cXVldWVk
YXRhID0gTlVMTDsNCiAJCS8qIHVzZXIgY29udGV4dCBuZWVkZWQgdG8gZnJl
ZSBxdWV1ZSAqLw0KSW5kZXg6IDIuNi4yMy9mcy9wYXJ0aXRpb25zL2NoZWNr
LmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSAyLjYuMjMub3JpZy9m
cy9wYXJ0aXRpb25zL2NoZWNrLmMNCisrKyAyLjYuMjMvZnMvcGFydGl0aW9u
cy9jaGVjay5jDQpAQCAtNTE2LDUgKzUxNiw5IEBAIHZvaWQgZGVsX2dlbmRp
c2soc3RydWN0IGdlbmRpc2sgKmRpc2spDQogCXN5c2ZzX3JlbW92ZV9saW5r
KCZibG9ja19kZXByLCBkaXNrLT5kZXYuYnVzX2lkKTsNCiAjZW5kaWYNCiAJ
ZGV2aWNlX2RlbCgmZGlzay0+ZGV2KTsNCi0JcHV0X2RldmljZSgmZGlzay0+
ZGV2KTsNCisJcHJpbnRrKEtFUk5fSU5GTyAiZGVsX2dlbmRpc2sgJXMsIGtv
YmogJXAsIHF1ZXVlICVwLCAiDQorCQkJInJlZmNvdW50IGJlZm9yZSBwdXRf
ZGV2aWNlICVkXG4iLA0KKwkJCWRpc2stPmRldi5idXNfaWQsICZkaXNrLT5k
ZXYua29iaiwgZGlzay0+cXVldWUsDQorCQkJYXRvbWljX3JlYWQoJmRpc2st
PmRldi5rb2JqLmtyZWYucmVmY291bnQpKTsNCisvLwlwdXRfZGV2aWNlKCZk
aXNrLT5kZXYpOw0KIH0NCkluZGV4OiAyLjYuMjMvZHJpdmVycy9zY3NpL3Nk
LmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSAyLjYuMjMub3JpZy9k
cml2ZXJzL3Njc2kvc2QuYw0KKysrIDIuNi4yMy9kcml2ZXJzL3Njc2kvc2Qu
Yw0KQEAgLTE3MzgsNiArMTczOCwxMCBAQCBzdGF0aWMgdm9pZCBzY3NpX2Rp
c2tfcmVsZWFzZShzdHJ1Y3QgY2xhDQogCXNwaW5fdW5sb2NrKCZzZF9pbmRl
eF9sb2NrKTsNCiANCiAJZGlzay0+cHJpdmF0ZV9kYXRhID0gTlVMTDsNCisJ
cHJpbnRrKEtFUk5fSU5GTyAic2NzaV9kaXNrX3JlbGVhc2U6IGRpc2sgJXMs
IGtvYmogJXAsICINCisJCQkicmVmY291bnQgYmVmb3JlIHB1dF9kaXNrICVk
XG4iLA0KKwkJCWRpc2stPmRldi5idXNfaWQsICZkaXNrLT5kZXYua29iaiwN
CisJCQlhdG9taWNfcmVhZCgmZGlzay0+ZGV2LmtvYmoua3JlZi5yZWZjb3Vu
dCkpOw0KIAlwdXRfZGlzayhkaXNrKTsNCiAJcHV0X2RldmljZSgmc2RrcC0+
ZGV2aWNlLT5zZGV2X2dlbmRldik7DQogDQo=
---1609956864-649327256-1192930438=:21971--
