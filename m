Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbXJSRLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbXJSRLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761799AbXJSRLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:11:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43198 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758980AbXJSRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:11:38 -0400
Date: Fri, 19 Oct 2007 13:11:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices
In-Reply-To: <1192803353.3308.14.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0710191303540.3755-200000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1559625215-95352328-1192813896=:3755"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1559625215-95352328-1192813896=:3755
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Fri, 19 Oct 2007, Kay Sievers wrote:

> > Don't you have a USB storage device?  It should be easy for you to test 
> > this on your own system.
> 
> Sure, I have, and tried a lot of times, and all seemed correct here with
> the final put. I don't say that it's the right fix, but without it, the
> disk device object is never released here, it only gets removed from
> sysfs.

Well, attached is a testing patch.  It should apply to 2.6.23 together 
with gregkh-all-2.6.23.  Here's the output on my system using your 
original code:

Plug in USB drive:

[   75.555077] usb-storage: device found at 3
[   75.558052] scsi 0:0:0:0: Direct-Access     UDISK    PDU01_1G 65G2.0  0.00 PQ: 0 ANSI: 2
[   75.568248] usb-storage: device scan complete
[   75.917139] sd 0:0:0:0: [sda] 1967616 512-byte hardware sectors (1007 MB)
[   75.918463] sd 0:0:0:0: [sda] Write Protect is off
[   75.919011] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[   75.919263] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   75.919397] sd_probe: call add_disk
[   75.919615] start of register_disk: 1
[   75.920402] after device_add: 3
[   75.920692] after disk_sysfs_add_subdirs: 5
[   75.921173] after get_capacity: 5
[   75.921461] after bdget_disk: 5
[   75.927996] sd 0:0:0:0: [sda] 1967616 512-byte hardware sectors (1007 MB)
[   75.929405] sd 0:0:0:0: [sda] Write Protect is off
[   75.929801] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[   75.929960] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   75.930202]  sda: sda1
[   75.966112] after blkdev_get: 8
[   75.966648] after blkdev_put: 7
[   75.968997] end of register_disk: 7
[   75.969327] after blk_register_queue: 9
[   75.969823] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   76.448192] sd 0:0:0:0: Attached scsi generic sg0 type 0

Unplug USB drive:

[   92.852078] usb 6-4: USB disconnect, address 3
[   92.853389] usb 6-4: unregistering device
[   92.853507] usb 6-4: usb_disable_device nuking all URBs
[   92.853783] usb 6-4: unregistering interface 6-4:1.0
[   92.863556] sd_remove: call del_gendisk
[   92.864043] start of del_gendisk: 9
[   92.866551] after deleting subpartitions: 7
[   92.866880] after invalidate_partition(0): 7
[   92.867469] after unlink_gendisk: 5
[   92.867738] after kobject_unregister subdirs: 3
[   92.869450] after device_del: 1
[   92.869741] after put_device: 1802201963
[   92.870267] BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
[   92.870494]  printing eip:
[   92.870547] d09639d2
[   92.870597] *pde = 00000000
[   92.870747] Oops: 0000 [#1]
[   92.870797] PREEMPT SMP 
[   92.870915] last sysfs file: /block/sda/sda1/dev
[   92.870968] Modules linked in: sg sd_mod usb_storage scsi_mod fan container battery ac evdev thermal button processor ohci_hcd e100 mii ehci_hcd uhci_hcd pcspkr usbcore
[   92.871749] CPU:    0
[   92.871751] EIP:    0060:[<d09639d2>]    Not tainted VLI
[   92.871753] EFLAGS: 00010202   (2.6.23 #7)
[   92.871905] EIP is at __scsi_disk_get+0xd/0x2a [sd_mod]
[   92.871958] eax: 6b6b6b6b   ebx: 6b6b6b6b   ecx: 00000000   edx: 00000008
[   92.872014] esi: cd7359a0   edi: cd7359a8   ebp: cf6edd6c   esp: cf6edd68
[   92.872069] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[   92.872124] Process khubd (pid: 970, ti=cf6ec000 task=cf6f0a90 task.ti=cf6ec000)
[   92.872179] Stack: 00000000 cf6edd78 d0963a13 cfb32910 cf6edd9c d0963bfd cf6edd9c c0194e69 
[   92.872555]        c032351e 6b6b6b6b cfb32910 cd7359a0 cd7359a8 cf6eddb4 d0964096 d09659fa 
[   92.872932]        cfb32910 d09670a4 00000292 cf6eddc4 c022303e cfb32910 cfb32910 cf6eddd0 
[   92.873310] Call Trace:
[   92.873400]  [<c01050fd>] show_trace_log_lvl+0x1a/0x2f
[   92.873496]  [<c01051af>] show_stack_log_lvl+0x9d/0xa5
[   92.873584]  [<c01053a4>] show_registers+0x1ed/0x32c
[   92.873672]  [<c01055fa>] die+0x117/0x236
[   92.873758]  [<c02ac046>] do_page_fault+0x4c0/0x591
[   92.873849]  [<c02aa69a>] error_code+0x72/0x78
[   92.873936]  [<d0963a13>] scsi_disk_get_from_dev+0x24/0x35 [sd_mod]
[   92.874029]  [<d0963bfd>] sd_shutdown+0xe/0xfd [sd_mod]
[   92.874122]  [<d0964096>] sd_remove+0x40/0x77 [sd_mod]
[   92.874213]  [<c022303e>] __device_release_driver+0x74/0x90
[   92.874306]  [<c022342c>] device_release_driver+0x30/0x47
[   92.874394]  [<c02229c3>] bus_remove_device+0x73/0x82
[   92.874482]  [<c02211ac>] device_del+0x206/0x27c
[   92.874569]  [<d0988b4e>] __scsi_remove_device+0x3c/0x6d [scsi_mod]
[   92.874678]  [<d0986509>] scsi_forget_host+0x30/0x4f [scsi_mod]
[   92.874781]  [<d0981543>] scsi_remove_host+0x6a/0xdf [scsi_mod]
[   92.874882]  [<d099f7b1>] quiesce_and_remove_host+0xa5/0xb5 [usb_storage]
[   92.874983]  [<d099f893>] storage_disconnect+0x11/0x1b [usb_storage]
[   92.875079]  [<d0847a52>] usb_unbind_interface+0x47/0x99 [usbcore]
[   92.875191]  [<c022303e>] __device_release_driver+0x74/0x90
[   92.875280]  [<c022342c>] device_release_driver+0x30/0x47
[   92.875369]  [<c02229c3>] bus_remove_device+0x73/0x82
[   92.875456]  [<c02211ac>] device_del+0x206/0x27c
[   92.875543]  [<d0844fee>] usb_disable_device+0xe2/0x145 [usbcore]
[   92.875648]  [<d08407e6>] usb_disconnect+0xce/0x167 [usbcore]
[   92.875751]  [<d0841b97>] hub_thread+0x646/0xea7 [usbcore]
[   92.875852]  [<c0131c9e>] kthread+0x3b/0x61
[   92.875940]  [<c0104d53>] kernel_thread_helper+0x7/0x10
[   92.876028]  =======================
[   92.876077] Code: e8 e1 6a 86 ef 8b 43 04 05 b0 00 00 00 e8 e6 d1 8b ef 89 d8 e8 45 e6 7f ef 58 5b 5e 5d c3 55 89 e5 53 8b 40 38 85 c0 74 18 89 c3 <8b> 40 04 e8 fb c6 01 00 85 c0 75 0a 8d 43 08 e8 79 fd 8b ef eb 
[   92.878418] EIP: [<d09639d2>] __scsi_disk_get+0xd/0x2a [sd_mod] SS:ESP 0068:cf6edd68


And here is the output with the put_device() call removed (the 
plug-in part is the same as before):

Plug in USB drive:

[   74.683198] usb-storage: device found at 3
[   74.685229] scsi 0:0:0:0: Direct-Access     UDISK    PDU01_1G 65G2.0  0.00 PQ: 0 ANSI: 2
[   74.692196] usb-storage: device scan complete
[   75.018341] sd 0:0:0:0: [sda] 1967616 512-byte hardware sectors (1007 MB)
[   75.019465] sd 0:0:0:0: [sda] Write Protect is off
[   75.019624] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[   75.019745] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   75.019872] sd_probe: call add_disk
[   75.019986] start of register_disk: 1
[   75.020234] after device_add: 3
[   75.020387] after disk_sysfs_add_subdirs: 5
[   75.020519] after get_capacity: 5
[   75.020672] after bdget_disk: 5
[   75.023582] sd 0:0:0:0: [sda] 1967616 512-byte hardware sectors (1007 MB)
[   75.024637] sd 0:0:0:0: [sda] Write Protect is off
[   75.024905] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[   75.025115] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   75.025264]  sda: sda1
[   75.054655] after blkdev_get: 8
[   75.054924] after blkdev_put: 7
[   75.057048] end of register_disk: 7
[   75.057628] after blk_register_queue: 9
[   75.057871] sd 0:0:0:0: [sda] Attached SCSI removable disk
[   75.464875] sd 0:0:0:0: Attached scsi generic sg0 type 0

Unplug USB drive:

[   85.266412] usb 4-4: USB disconnect, address 3
[   85.266719] usb 4-4: unregistering device
[   85.266831] usb 4-4: usb_disable_device nuking all URBs
[   85.266961] usb 4-4: unregistering interface 4-4:1.0
[   85.271229] sd_remove: call del_gendisk
[   85.275622] start of del_gendisk: 9
[   85.276204] after deleting subpartitions: 7
[   85.276336] after invalidate_partition(0): 7
[   85.276512] after unlink_gendisk: 5
[   85.276644] after kobject_unregister subdirs: 3
[   85.276966] after device_del: 1
[   85.277095] scsi_disk_release: call put_disk
[   85.292153] usb 4-4:1.0: uevent
[   85.292468] usb 4-4:1.0: uevent
[   85.293458] usb 4-4: uevent

As you can see, this definitely proves that the final put is done at 
the right time.

See what the patch shows on your system.  One extra thing to check for: 
When you plug in a USB drive, the SCSI core starts up an error-handler 
process for it.  When you unplug the drive, the error-handler task 
should exit.  If it doesn't then there's an extra reference somewhere 
that never got released.

Alan Stern

---1559625215-95352328-1192813896=:3755
Content-Type: TEXT/plain; name="disktest.txt"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.0710191311360.3755@iolanthe.rowland.org>
Content-Description: test patch
Content-Disposition: attachment; filename="disktest.txt"

SW5kZXg6IHVzYi0yLjYvYmxvY2svZ2VuaGQuYw0KPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQ0KLS0tIHVzYi0yLjYub3JpZy9ibG9jay9nZW5oZC5jDQorKysg
dXNiLTIuNi9ibG9jay9nZW5oZC5jDQpAQCAtMTcsNiArMTcsMTAgQEANCiAj
aW5jbHVkZSA8bGludXgvYnVmZmVyX2hlYWQuaD4NCiAjaW5jbHVkZSA8bGlu
dXgvbXV0ZXguaD4NCiANCitleHRlcm4gaW50IGFsYW50ZXN0Ow0KKyNkZWZp
bmUgYWxhbnAobXNnLCBkaXNrKSAgIGlmIChhbGFudGVzdCkgcHJpbnRrKEtF
Uk5fSU5GTyBtc2cgIjogJWRcbiIsIFwNCisJCQlhdG9taWNfcmVhZCgmZGlz
ay0+ZGV2LmtvYmoua3JlZi5yZWZjb3VudCkpDQorDQogZXh0ZXJuIHN0cnVj
dCBjbGFzcyBibG9ja19jbGFzczsNCiBleHRlcm4gc3RydWN0IGRldmljZV90
eXBlIGRpc2tfdHlwZTsNCiBleHRlcm4gc3RydWN0IGRldmljZV90eXBlIHBh
cnRfdHlwZTsNCkBAIC0xODUsNiArMTg5LDcgQEAgdm9pZCBhZGRfZGlzayhz
dHJ1Y3QgZ2VuZGlzayAqZGlzaykNCiAJCQkgICAgZGlzay0+bWlub3JzLCBO
VUxMLCBleGFjdF9tYXRjaCwgZXhhY3RfbG9jaywgZGlzayk7DQogCXJlZ2lz
dGVyX2Rpc2soZGlzayk7DQogCWJsa19yZWdpc3Rlcl9xdWV1ZShkaXNrKTsN
CisJYWxhbnAoImFmdGVyIGJsa19yZWdpc3Rlcl9xdWV1ZSIsIGRpc2spOw0K
IH0NCiANCiBFWFBPUlRfU1lNQk9MKGFkZF9kaXNrKTsNCkluZGV4OiB1c2It
Mi42L2RyaXZlcnMvc2NzaS9zZC5jDQo9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
DQotLS0gdXNiLTIuNi5vcmlnL2RyaXZlcnMvc2NzaS9zZC5jDQorKysgdXNi
LTIuNi9kcml2ZXJzL3Njc2kvc2QuYw0KQEAgLTYyLDYgKzYyLDggQEANCiAN
CiAjaW5jbHVkZSAic2NzaV9sb2dnaW5nLmgiDQogDQorZXh0ZXJuIGludCBh
bGFudGVzdDsNCisNCiBNT0RVTEVfQVVUSE9SKCJFcmljIFlvdW5nZGFsZSIp
Ow0KIE1PRFVMRV9ERVNDUklQVElPTigiU0NTSSBkaXNrIChzZCkgZHJpdmVy
Iik7DQogTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KQEAgLTE2NzcsNyArMTY3
OSwxMCBAQCBzdGF0aWMgaW50IHNkX3Byb2JlKHN0cnVjdCBkZXZpY2UgKmRl
dikNCiAJCWdkLT5mbGFncyB8PSBHRU5IRF9GTF9SRU1PVkFCTEU7DQogDQog
CWRldl9zZXRfZHJ2ZGF0YShkZXYsIHNka3ApOw0KKwlwcmludGsoS0VSTl9J
TkZPICJzZF9wcm9iZTogY2FsbCBhZGRfZGlza1xuIik7DQorCWFsYW50ZXN0
ID0gMTsNCiAJYWRkX2Rpc2soZ2QpOw0KKwlhbGFudGVzdCA9IDA7DQogDQog
CXNkX3ByaW50ayhLRVJOX05PVElDRSwgc2RrcCwgIkF0dGFjaGVkIFNDU0kg
JXNkaXNrXG4iLA0KIAkJICBzZHAtPnJlbW92YWJsZSA/ICJyZW1vdmFibGUg
IiA6ICIiKTsNCkBAIC0xNzA4LDYgKzE3MTMsOCBAQCBzdGF0aWMgaW50IHNk
X3JlbW92ZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCXN0cnVjdCBzY3NpX2Rp
c2sgKnNka3AgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCiANCiAJY2xhc3Nf
ZGV2aWNlX2RlbCgmc2RrcC0+Y2Rldik7DQorCXByaW50ayhLRVJOX0lORk8g
InNkX3JlbW92ZTogY2FsbCBkZWxfZ2VuZGlza1xuIik7DQorCWFsYW50ZXN0
ID0gMTsNCiAJZGVsX2dlbmRpc2soc2RrcC0+ZGlzayk7DQogCXNkX3NodXRk
b3duKGRldik7DQogDQpAQCAtMTcxNiw2ICsxNzIzLDcgQEAgc3RhdGljIGlu
dCBzZF9yZW1vdmUoc3RydWN0IGRldmljZSAqZGV2KQ0KIAljbGFzc19kZXZp
Y2VfcHV0KCZzZGtwLT5jZGV2KTsNCiAJbXV0ZXhfdW5sb2NrKCZzZF9yZWZf
bXV0ZXgpOw0KIA0KKwlhbGFudGVzdCA9IDA7DQogCXJldHVybiAwOw0KIH0N
CiANCkBAIC0xNzM4LDYgKzE3NDYsNyBAQCBzdGF0aWMgdm9pZCBzY3NpX2Rp
c2tfcmVsZWFzZShzdHJ1Y3QgY2xhDQogCXNwaW5fdW5sb2NrKCZzZF9pbmRl
eF9sb2NrKTsNCiANCiAJZGlzay0+cHJpdmF0ZV9kYXRhID0gTlVMTDsNCisJ
cHJpbnRrKEtFUk5fSU5GTyAic2NzaV9kaXNrX3JlbGVhc2U6IGNhbGwgcHV0
X2Rpc2tcbiIpOw0KIAlwdXRfZGlzayhkaXNrKTsNCiAJcHV0X2RldmljZSgm
c2RrcC0+ZGV2aWNlLT5zZGV2X2dlbmRldik7DQogDQpJbmRleDogdXNiLTIu
Ni9mcy9wYXJ0aXRpb25zL2NoZWNrLmMNCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NCi0tLSB1c2ItMi42Lm9yaWcvZnMvcGFydGl0aW9ucy9jaGVjay5jDQor
KysgdXNiLTIuNi9mcy9wYXJ0aXRpb25zL2NoZWNrLmMNCkBAIC0zNiw2ICsz
NiwxMSBAQA0KICNpbmNsdWRlICJrYXJtYS5oIg0KICNpbmNsdWRlICJzeXN2
NjguaCINCiANCitpbnQgYWxhbnRlc3Q7DQorRVhQT1JUX1NZTUJPTChhbGFu
dGVzdCk7DQorI2RlZmluZSBhbGFucChtc2csIGRpc2spICAgaWYgKGFsYW50
ZXN0KSBwcmludGsoS0VSTl9JTkZPIG1zZyAiOiAlZFxuIiwgXA0KKwkJCWF0
b21pY19yZWFkKCZkaXNrLT5kZXYua29iai5rcmVmLnJlZmNvdW50KSkNCisN
CiBleHRlcm4gc3RydWN0IGtvYmplY3QgYmxvY2tfZGVwcjsNCiBleHRlcm4g
c3RydWN0IGNsYXNzIGJsb2NrX2NsYXNzOw0KIA0KQEAgLTM3OCw2ICszODMs
NyBAQCB2b2lkIHJlZ2lzdGVyX2Rpc2soc3RydWN0IGdlbmRpc2sgKmRpc2sp
DQogCXN0cnVjdCBoZF9zdHJ1Y3QgKnA7DQogCWludCBlcnI7DQogDQorCWFs
YW5wKCJzdGFydCBvZiByZWdpc3Rlcl9kaXNrIiwgZGlzayk7DQogCWRpc2st
PmRldi5wYXJlbnQgPSBkaXNrLT5kcml2ZXJmc19kZXY7DQogCWRpc2stPmRl
di5kZXZ0ID0gTUtERVYoZGlzay0+bWFqb3IsIGRpc2stPmZpcnN0X21pbm9y
KTsNCiANCkBAIC0zOTIsNiArMzk4LDcgQEAgdm9pZCByZWdpc3Rlcl9kaXNr
KHN0cnVjdCBnZW5kaXNrICpkaXNrKQ0KIA0KIAlpZiAoZGV2aWNlX2FkZCgm
ZGlzay0+ZGV2KSkNCiAJCXJldHVybjsNCisJYWxhbnAoImFmdGVyIGRldmlj
ZV9hZGQiLCBkaXNrKTsNCiAjaWZuZGVmIENPTkZJR19TWVNGU19ERVBSRUNB
VEVEDQogCWVyciA9IHN5c2ZzX2NyZWF0ZV9saW5rKCZibG9ja19kZXByLCAm
ZGlzay0+ZGV2LmtvYmosDQogCQkJCWtvYmplY3RfbmFtZSgmZGlzay0+ZGV2
LmtvYmopKTsNCkBAIC0zOTksOCArNDA2LDEwIEBAIHZvaWQgcmVnaXN0ZXJf
ZGlzayhzdHJ1Y3QgZ2VuZGlzayAqZGlzaykNCiAJCWRldmljZV9kZWwoJmRp
c2stPmRldik7DQogCQlyZXR1cm47DQogCX0NCisJYWxhbnAoImFmdGVyIHN5
c2ZzX2NyZWF0ZV9saW5rIiwgZGlzayk7DQogI2VuZGlmDQogIAlkaXNrX3N5
c2ZzX2FkZF9zdWJkaXJzKGRpc2spOw0KKwlhbGFucCgiYWZ0ZXIgZGlza19z
eXNmc19hZGRfc3ViZGlycyIsIGRpc2spOw0KIA0KIAkvKiBObyBtaW5vcnMg
dG8gdXNlIGZvciBwYXJ0aXRpb25zICovDQogCWlmIChkaXNrLT5taW5vcnMg
PT0gMSkNCkBAIC00MDksMTYgKzQxOCwyMCBAQCB2b2lkIHJlZ2lzdGVyX2Rp
c2soc3RydWN0IGdlbmRpc2sgKmRpc2spDQogCS8qIE5vIHN1Y2ggZGV2aWNl
IChlLmcuLCBtZWRpYSB3ZXJlIGp1c3QgcmVtb3ZlZCkgKi8NCiAJaWYgKCFn
ZXRfY2FwYWNpdHkoZGlzaykpDQogCQlnb3RvIGV4aXQ7DQorCWFsYW5wKCJh
ZnRlciBnZXRfY2FwYWNpdHkiLCBkaXNrKTsNCiANCiAJYmRldiA9IGJkZ2V0
X2Rpc2soZGlzaywgMCk7DQogCWlmICghYmRldikNCiAJCWdvdG8gZXhpdDsN
CisJYWxhbnAoImFmdGVyIGJkZ2V0X2Rpc2siLCBkaXNrKTsNCiANCiAJYmRl
di0+YmRfaW52YWxpZGF0ZWQgPSAxOw0KIAllcnIgPSBibGtkZXZfZ2V0KGJk
ZXYsIEZNT0RFX1JFQUQsIDApOw0KIAlpZiAoZXJyIDwgMCkNCiAJCWdvdG8g
ZXhpdDsNCisJYWxhbnAoImFmdGVyIGJsa2Rldl9nZXQiLCBkaXNrKTsNCiAJ
YmxrZGV2X3B1dChiZGV2KTsNCisJYWxhbnAoImFmdGVyIGJsa2Rldl9wdXQi
LCBkaXNrKTsNCiANCiBleGl0Og0KIAkvKiBhbm5vdW5jZSBkaXNrIGFmdGVy
IHBvc3NpYmxlIHBhcnRpdGlvbnMgYXJlIGNyZWF0ZWQgKi8NCkBAIC00MzIs
NiArNDQ1LDcgQEAgZXhpdDoNCiAJCQljb250aW51ZTsNCiAJCWtvYmplY3Rf
dWV2ZW50KCZwLT5kZXYua29iaiwgS09CSl9BREQpOw0KIAl9DQorCWFsYW5w
KCJlbmQgb2YgcmVnaXN0ZXJfZGlzayIsIGRpc2spOw0KIH0NCiANCiBpbnQg
cmVzY2FuX3BhcnRpdGlvbnMoc3RydWN0IGdlbmRpc2sgKmRpc2ssIHN0cnVj
dCBibG9ja19kZXZpY2UgKmJkZXYpDQpAQCAtNDk3LDI0ICs1MTEsMzQgQEAg
dm9pZCBkZWxfZ2VuZGlzayhzdHJ1Y3QgZ2VuZGlzayAqZGlzaykNCiB7DQog
CWludCBwOw0KIA0KKwlhbGFucCgic3RhcnQgb2YgZGVsX2dlbmRpc2siLCBk
aXNrKTsNCisNCiAJLyogaW52YWxpZGF0ZSBzdHVmZiAqLw0KIAlmb3IgKHAg
PSBkaXNrLT5taW5vcnMgLSAxOyBwID4gMDsgcC0tKSB7DQogCQlpbnZhbGlk
YXRlX3BhcnRpdGlvbihkaXNrLCBwKTsNCiAJCWRlbGV0ZV9wYXJ0aXRpb24o
ZGlzaywgcCk7DQogCX0NCisJYWxhbnAoImFmdGVyIGRlbGV0aW5nIHN1YnBh
cnRpdGlvbnMiLCBkaXNrKTsNCiAJaW52YWxpZGF0ZV9wYXJ0aXRpb24oZGlz
aywgMCk7DQorCWFsYW5wKCJhZnRlciBpbnZhbGlkYXRlX3BhcnRpdGlvbigw
KSIsIGRpc2spOw0KKw0KIAlkaXNrLT5jYXBhY2l0eSA9IDA7DQogCWRpc2st
PmZsYWdzICY9IH5HRU5IRF9GTF9VUDsNCiAJdW5saW5rX2dlbmRpc2soZGlz
ayk7DQorCWFsYW5wKCJhZnRlciB1bmxpbmtfZ2VuZGlzayIsIGRpc2spOw0K
IAlkaXNrX3N0YXRfc2V0X2FsbChkaXNrLCAwKTsNCiAJZGlzay0+c3RhbXAg
PSAwOw0KIA0KIAlrb2JqZWN0X3VucmVnaXN0ZXIoZGlzay0+aG9sZGVyX2Rp
cik7DQogCWtvYmplY3RfdW5yZWdpc3RlcihkaXNrLT5zbGF2ZV9kaXIpOw0K
KwlhbGFucCgiYWZ0ZXIga29iamVjdF91bnJlZ2lzdGVyIHN1YmRpcnMiLCBk
aXNrKTsNCiAJZGlzay0+ZHJpdmVyZnNfZGV2ID0gTlVMTDsNCiAjaWZuZGVm
IENPTkZJR19TWVNGU19ERVBSRUNBVEVEDQogCXN5c2ZzX3JlbW92ZV9saW5r
KCZibG9ja19kZXByLCBkaXNrLT5kZXYuYnVzX2lkKTsNCisJYWxhbnAoImFm
dGVyIHN5c2ZzX3JlbW92ZV9saW5rIiwgZGlzayk7DQogI2VuZGlmDQogCWRl
dmljZV9kZWwoJmRpc2stPmRldik7DQorCWFsYW5wKCJhZnRlciBkZXZpY2Vf
ZGVsIiwgZGlzayk7DQogCXB1dF9kZXZpY2UoJmRpc2stPmRldik7DQorCWFs
YW5wKCJhZnRlciBwdXRfZGV2aWNlIiwgZGlzayk7DQogfQ0K
---1559625215-95352328-1192813896=:3755--
