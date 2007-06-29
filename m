Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbXF2RuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbXF2RuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760754AbXF2RuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:50:09 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:51177 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119AbXF2RuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:50:06 -0400
Message-ID: <46854646.6030805@control.lth.se>
Date: Fri, 29 Jun 2007 19:49:58 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: linux-kernel@vger.kernel.org, Manuel Estrada Sainz <ranty@debian.org>
Subject: Re: [PATCH] Documentation/firmware_class/firmware_sample_driver.c
References: <46827B20.6000501@control.lth.se> <a781481a0706280335l5ac5e0e1w6c29922598b7416f@mail.gmail.com>
In-Reply-To: <a781481a0706280335l5ac5e0e1w6c29922598b7416f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Hi,
> 
> [ It's good that you're trying to fix this, code in documentation should
> be setting standards, clearly. ]
> 
> On 6/27/07, Anders Blomdell <anders.blomdell@control.lth.se> wrote:
>> [...]
>> Minor modifications to make the example load and unload without Oops
>> [...]
>>  static int sample_init(void)
>>  {
>> -       device_initialize(&ghost_device);
>> +       device_register(&ghost_device);
>>         /* since there is no real hardware insertion I just call the
>>          * sample probe functions here */
>> -       sample_probe_specific();
>> +       /* sample_probe_specific(); */
>>         sample_probe_default();
>> -       sample_probe_async();
>> +       /*sample_probe_async();*/
>>         return 0;
>>  }
> 
> But IMO the above functions should be *fixed* to work properly instead
> of simply commenting them out. If they are un-fixable, why even keep
> the broken code in that file (only to mislead readers in future?). You
> might as well remove those calls (and the function definitions) completely.
> Best would be to fix them, of course.
> 
> My Rs. 0.02,
> Satyam

Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>

Minor modifications to make the example load and unload without Oops, with
suggestions from Satyam Sharma incorporated.

This is what unpatched version generates with 2.6.21.3

kernel: Oops: 0000 [#2]
...
kernel: Call Trace:
kernel:  [<c04ae541>] sysfs_create_dir+0x49/0x63
kernel:  [<c04e76ae>] kobject_shadow_add+0xd5/0x17d
kernel:  [<c04e7908>] kobject_set_name+0x2b/0x92
kernel:  [<c0556444>] device_add+0x9a/0x58e
kernel:  [<c0620b65>] klist_init+0x23/0x2e
kernel:  [<c055bfee>] _request_firmware+0x116/0x29f
kernel:  [<c062149f>] wait_for_completion+0x8b/0x93
kernel:  [<c055c20b>] request_firmware+0xf/0x11
kernel:  [<e09420d9>] sample_init+0x59/0xc0 [firmware_sample_driver]
kernel:  [<c0446c92>] sys_init_module+0x16b7/0x17ee
kernel:  [<c04294de>] printk+0x0/0x1f
kernel:  [<c0488436>] mntput_no_expire+0x11/0x6e
kernel:  [<c0404fa8>] syscall_call+0x7/0xb




diff -u Documentation/firmware_class/firmware_sample_driver.c
/tmp/fw/firmware_sample_driver.c
--- Documentation/firmware_class/firmware_sample_driver.c       2007-05-24
23:22:47.000000000 +0200
+++ /tmp/fw/firmware_sample_driver.c  2007-06-29 19:41:29.000000000 +0200
@@ -15,11 +15,16 @@

 #include "linux/firmware.h"

+static void ghost_release(struct device *dev)
+{
+       printk(KERN_DEBUG "firmware_sample_driver: ghost_release\n");
+}
+
 static struct device ghost_device = {
        .bus_id    = "ghost0",
+       .release   = ghost_release
 };

-
 static void sample_firmware_load(char *firmware, int size)
 {
        u8 buf[size+1];
@@ -32,7 +37,7 @@
 {
        /* uses the default method to get the firmware */
         const struct firmware *fw_entry;
-       printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted
:)\n");
+       printk(KERN_INFO "firmware_sample_driver SYNC:\n");

         if(request_firmware(&fw_entry, "sample_driver_fw", &ghost_device)!=0)
        {
@@ -47,27 +52,9 @@

        /* finish setting up the device */
 }
-static void sample_probe_specific(void)
-{
-       /* Uses some specific hotplug support to get the firmware from
-        * userspace  directly into the hardware, or via some sysfs file */
-
-       /* NOTE: This currently doesn't work */

-       printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted
:)\n");
+static char *context = "async context";

-        if(request_firmware(NULL, "sample_driver_fw", &ghost_device)!=0)
-       {
-               printk(KERN_ERR
-                      "firmware_sample_driver: Firmware load failed\n");
-               return;
-       }
-
-       /* request_firmware blocks until userspace finished, so at
-        * this point the firmware should be already in the device */
-
-       /* finish setting up the device */
-}
 static void sample_probe_async_cont(const struct firmware *fw, void *context)
 {
        if(!fw){
@@ -76,7 +63,7 @@
                return;
        }

-       printk(KERN_INFO "firmware_sample_driver: device pointer \"%s\"\n",
+       printk(KERN_INFO "firmware_sample_driver ASYNC: context \"%s\"\n",
               (char *)context);
        sample_firmware_load(fw->data, fw->size);
 }
@@ -84,9 +71,9 @@
 {
        /* Let's say that I can't sleep */
        int error;
-       error = request_firmware_nowait (THIS_MODULE, FW_ACTION_NOHOTPLUG,
+       error = request_firmware_nowait (THIS_MODULE, FW_ACTION_HOTPLUG,
                                         "sample_driver_fw", &ghost_device,
-                                        "my device pointer",
+                                        context,
                                         sample_probe_async_cont);
        if(error){
                printk(KERN_ERR
@@ -97,16 +84,18 @@

 static int sample_init(void)
 {
-       device_initialize(&ghost_device);
+       int ret = device_register(&ghost_device);
+       if (ret == 0) {
        /* since there is no real hardware insertion I just call the
         * sample probe functions here */
-       sample_probe_specific();
        sample_probe_default();
        sample_probe_async();
-       return 0;
+       }
+       return ret;
 }
 static void __exit sample_exit(void)
 {
+       device_unregister(&ghost_device);
 }

 module_init (sample_init);



-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden
