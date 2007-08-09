Return-Path: <linux-kernel-owner+w=401wt.eu-S940508AbXHIONT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940508AbXHIONT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940262AbXHIOMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:12:44 -0400
Received: from mail.atmel.fr ([81.80.104.162]:61491 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939275AbXHIOMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:12:41 -0400
Message-ID: <46BB200F.5090300@rfo.atmel.com>
Date: Thu, 09 Aug 2007 16:09:19 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: ?? <wux@landicorp.com>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] mmc: at91_mci: add multiwrite cap
References: <46B9926B.3090707@rfo.atmel.com>	<20070808121147.1433d055@poseidon.drzeus.cx>	<46B9D6EE.4040705@rfo.atmel.com> <20070808170108.4db814d1@poseidon.drzeus.cx>
In-Reply-To: <20070808170108.4db814d1@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> On Wed, 08 Aug 2007 16:45:02 +0200
> Nicolas Ferre <nicolas.ferre@rfo.atmel.com> wrote:
> 
>> Pierre,
>>
>> I am a little confused : the probe function does not seem to get 
>> called... (I tried both module an in-kernel form / inserting sd or
>> mmc cards).
>>
>> The modules is correctly inserted : mmc_register_driver() returns 0.
>>
>> Did I miss something ?
>>
> 
> You might need to make sure that mmc_block isn't attaching to the card.

Ok thank you : it was the point.

Results : in brief :
- there is work to be done ;-)
- multiwrite test result is : OK

I had to modify the mmc_test to workaround the driver being stuck.
I attach the patch so you can figure out the testcase I ran :

diff -u b/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
--- b/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -149,7 +149,8 @@
 	printk(KERN_INFO "%s: Testing reading power of two block sizes...\n",
 		mmc_hostname(card->host));
 
-	for (i = 1;i <= 512;i <<= 1) {
+//	for (i = 1;i <= 512;i <<= 1) {
+	for (i = 512;i <= 512;i <<= 2) { /*must have size%4 == 0*/
 		memset(&mrq, 0, sizeof(struct mmc_request));
 
 		mrq.cmd = &cmd;
@@ -194,7 +195,9 @@
 	printk(KERN_INFO "%s: Testing writing power of two block sizes...\n",
 		mmc_hostname(card->host));
 
-	for (i = 1;i <= 512;i <<= 1) {
+//	for (i = 1;i <= 512;i <<= 1) {
+	for (i = 512;i <= 512;i <<= 2) { /*must have size%4 == 0*/
+		printk(".");
 		memset(&mrq, 0, sizeof(struct mmc_request));
 
 		mrq.cmd = &cmd;
@@ -221,6 +224,7 @@
 	}
 
 out:
+	printk("\n");
 	printk(KERN_INFO "%s: Result: %s\n", mmc_hostname(card->host),
 		ret ? "FAIL" : "OK");
 
@@ -470,13 +474,15 @@
 
 static int mmc_test_probe(struct mmc_card *card)
 {
+	printk(KERN_INFO "%s: About to test mmc subsystem\n", mmc_hostname(card->host));
+
 	mmc_claim_host(card->host);
 
 	test_pow2_writes(card);
 	test_pow2_reads(card);
 
-	test_weird_writes(card);
-	test_weird_reads(card);
+	//test_weird_writes(card);
+	//test_weird_reads(card);
 
 	test_bytes_xfer_single(card);
 	test_bytes_xfer_multi(card);
@@ -502,7 +508,13 @@
 
 static int __init mmc_test_init(void)
 {
-	return mmc_register_driver(&mmc_driver);
+	int ret = 0;
+
+	printk(KERN_ERR "eessaaii\n");
+	ret = mmc_register_driver(&mmc_driver);
+	printk(KERN_ERR "eessaaii = %d\n", ret);
+
+	return ret;
 }
 
 static void __exit mmc_test_exit(void)


And here is the output :

With a SD card :
root@at91sam9263ek:~$ mmc0: card is read-write
mmc0: new SD card at address 0002
mmc0: About to test mmc subsystem
mmc0: Testing writing power of two block sizes...
.<7>mmc0: starting CMD16 arg 00000200 flags 00000015

mmc0: Result: OK
mmc0: Testing reading power of two block sizes...
mmc0: Result: OK
mmc0: Testing correct bytes_xfered for a single block...
mmc0: Result: OK
mmc0: Testing correct bytes_xfered for multiple blocks...
mmc0: Result: OK
mmc0: Testing that host waits for busy...
kernel BUG at drivers/mmc/core/core.c:139!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1]
Modules linked in: mmc_test
CPU: 0    Not tainted  (2.6.23-rc2 #30)
PC is at __bug+0x20/0x2c
LR is at release_console_sem+0x1cc/0x1e4
pc : [<c0027f54>]    lr : [<c003a928>]    psr: 60000013
sp : c3d1fc28  ip : 00000000  fp : c3d1fc34
r10: c3e49e00  r9 : c3e49e00  r8 : 00000000
r7 : c3cc3400  r6 : c3cc34ac  r5 : c3d1fda4  r4 : c3d1fd20
r3 : 00000000  r2 : c029caa8  r1 : 000074b2  r0 : 0000002e
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0005317f  Table: 22cd4000  DAC: 00000017
Process kmmcd (pid: 814, stack limit = 0xc3d1e260)
Stack: (0xc3d1fc28 to 0xc3d20000)
fc20:                   c3d1fc7c c3d1fc38 c0173a74 c0027f44 0000001d 00000019
fc40: 00000000 c3d1fc50 c0077894 00000000 c3d1fc50 c3d1fc50 00001400 c3d1fda4
fc60: 00001400 00000001 c2fce000 00000200 c3d1fcb4 c3d1fc80 bf000108 c0173948
fc80: c03319c0 00000000 00000000 00001400 c3d1fda4 0000000a 00000001 c3e49e00
fca0: 00000000 00000200 c3d1fd14 c3d1fcb8 bf000324 bf000020 00000200 00000400
fcc0: c3d1fda4 00000010 00000200 00000900 00000000 00000000 00000000 00000015
fce0: 00000005 00000000 00000000 c3d1fc84 c3d1fda4 c0131630 c3e49e00 c3d1fe1c
fd00: c3e49e70 00000000 c3d1fdd4 c3d1fd18 bf000700 bf000230 00000200 c3d1fd90
fd20: 0ee6b280 00000000 00000200 0000000a 00000000 00000100 00000000 00000000
fd40: 00000000 00000001 c3d1fc80 0000000c 00000000 00000000 00000000 00000000
fd60: 00000000 0000001d 00000000 00000000 00000000 00000000 00000019 00000000
fd80: 00000000 00000000 00000000 00000000 00000035 00000000 00000000 00000000
fda0: c3d1fda4 c3d1fd78 c3d1fd20 c3d1fd4c c3d1fc4c c0173bc8 c3d1fde4 c3e49e08
fdc0: c0131630 bf000ff4 c3d1fde4 c3d1fdd8 c01741dc bf000358 c3d1fe04 c3d1fde8
fde0: c0131578 c01741cc 00000000 c0131630 c3e49e08 c3d1fe1c c3d1fe14 c3d1fe08
fe00: c0131640 c01314a4 c3d1fe44 c3d1fe18 c0130758 c0131640 00000000 c02af270
fe20: c02af270 bf001048 c3e49e08 c3e49ec8 c3e49e08 00000000 c3d1fe5c c3d1fe48
fe40: c01316e0 c0130718 c3e49e08 c02af174 c3d1fe74 c3d1fe60 c01306b8 c0131680
fe60: c3e49e08 00000000 c3d1feb4 c3d1fe78 c012f1d4 c0130690 c3e49e00 c3cc3408
fe80: c3e49eac 00000000 c003af3c c3e49e00 00000000 c3e49e08 0000000c 00000041
fea0: c3e49e00 c3cc3400 c3d1fedc c3d1feb8 c0174390 c012eed4 00000002 c2e7bf00
fec0: c2e7bf00 00000000 00000001 0000000c c3d1ff34 c3d1fee0 c01760a4 c01742f0
fee0: c2e7bf00 00000029 00000000 00443235 00004432 00000044 41343253 44323536
ff00: 10234842 04006c77 00000000 c3d1ff54 c3cc34ac c3cc3560 c3cc3400 00000000
ff20: 00000000 00000000 c3d1ff7c c3d1ff38 c0173d78 c0175b04 00000002 00000000
ff40: 00000015 00000000 00000000 c0046d14 00000000 00ff8000 c3d1ff9c c3d06320
ff60: c3d1e000 c0173be0 00000000 00000000 c3d1ff9c c3d1ff80 c0049de0 c0173bf0
ff80: c3d06328 c3d1ffa4 c3d18000 c3d06320 c3d1ffd4 c3d1ffa0 c004a88c c0049d34
ffa0: c004db9c 00000000 c3d18000 c004dee8 c3d1ffb0 c3d1ffb0 c3d1e000 c3d06320
ffc0: c004a7e4 00000000 c3d1fff4 c3d1ffd8 c004dbbc c004a7f4 00000000 00000000
ffe0: 00000000 00000000 00000000 c3d1fff8 c003d354 c004db70 cc33cc13 cc33cc33
Backtrace:
[<c0027f34>] (__bug+0x0/0x2c) from [<c0173a74>] (mmc_wait_for_req+0x13c/0x214)
[<c0173938>] (mmc_wait_for_req+0x0/0x214) from [<bf000108>] (do_transfer+0xf8/0x168 [mmc_test])
 r8:00000200 r7:c2fce000 r6:00000001 r5:00001400 r4:c3d1fda4
[<bf000010>] (do_transfer+0x0/0x168 [mmc_test]) from [<bf000324>] (do_valid_transfer+0x104/0x128 [mmc_test])
[<bf000220>] (do_valid_transfer+0x0/0x128 [mmc_test]) from [<bf000700>] (mmc_test_probe+0x3b8/0x4fc [mmc_test])
[<bf000348>] (mmc_test_probe+0x0/0x4fc [mmc_test]) from [<c01741dc>] (mmc_bus_probe+0x20/0x24)
 r6:bf000ff4 r5:c0131630 r4:c3e49e08
[<c01741bc>] (mmc_bus_probe+0x0/0x24) from [<c0131578>] (driver_probe_device+0xe4/0x19c)
[<c0131494>] (driver_probe_device+0x0/0x19c) from [<c0131640>] (__device_attach+0x10/0x14)
 r7:c3d1fe1c r6:c3e49e08 r5:c0131630 r4:00000000
[<c0131630>] (__device_attach+0x0/0x14) from [<c0130758>] (bus_for_each_drv+0x50/0x8c)
[<c0130708>] (bus_for_each_drv+0x0/0x8c) from [<c01316e0>] (device_attach+0x70/0x9c)
 r7:00000000 r6:c3e49e08 r5:c3e49ec8 r4:c3e49e08
[<c0131670>] (device_attach+0x0/0x9c) from [<c01306b8>] (bus_attach_device+0x38/0x88)
 r5:c02af174 r4:c3e49e08
[<c0130680>] (bus_attach_device+0x0/0x88) from [<c012f1d4>] (device_add+0x310/0x580)
 r5:00000000 r4:c3e49e08
[<c012eec4>] (device_add+0x0/0x580) from [<c0174390>] (mmc_add_card+0xb0/0x13c)
[<c01742e0>] (mmc_add_card+0x0/0x13c) from [<c01760a4>] (mmc_attach_sd+0x5b0/0x728)
 r7:0000000c r6:00000001 r5:00000000 r4:c2e7bf00
[<c0175af4>] (mmc_attach_sd+0x0/0x728) from [<c0173d78>] (mmc_rescan+0x198/0x258)
[<c0173be0>] (mmc_rescan+0x0/0x258) from [<c0049de0>] (run_workqueue+0xbc/0x148)
 r8:00000000 r7:00000000 r6:c0173be0 r5:c3d1e000 r4:c3d06320
[<c0049d24>] (run_workqueue+0x0/0x148) from [<c004a88c>] (worker_thread+0xa8/0xbc)
 r7:c3d06320 r6:c3d18000 r5:c3d1ffa4 r4:c3d06328
[<c004a7e4>] (worker_thread+0x0/0xbc) from [<c004dbbc>] (kthread+0x5c/0x94)
 r7:00000000 r6:c004a7e4 r5:c3d06320 r4:c3d1e000
[<c004db60>] (kthread+0x0/0x94) from [<c003d354>] (do_exit+0x0/0x7a0)
 r6:00000000 r5:00000000 r4:00000000
Code: e1a01000 e59f000c eb004bf0 e3a03000 (e5833000)

I do not know if the OOps is due to a bad behavior of the driver during the 
wait for busy test...

And with a MMC : quite the same results but with :

mmc0: Testing correct bytes_xfered for a single block...
mmc0: Result: FAIL

Regards,
-- 
Nicolas Ferre

