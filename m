Return-Path: <linux-kernel-owner+w=401wt.eu-S934476AbXJPRXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbXJPRXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762624AbXJPRXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:23:09 -0400
Received: from 193.4.221.87.dynamic.jazztel.es ([87.221.4.193]:38625 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761452AbXJPRXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:23:08 -0400
Date: Tue, 16 Oct 2007 19:23:10 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] FTDI Elan driver: Convert ftdi->u132_lock to mutex
Message-ID: <20071016172310.GC31288@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FTDI Elan driver: Convert the semaphore ftdi->u132_lock to the mutex
API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 538b535..d61e0ca 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -147,7 +147,7 @@ struct u132_target {
 /* Structure to hold all of our device specific stuff*/
 struct usb_ftdi {
         struct list_head ftdi_list;
-        struct semaphore u132_lock;
+        struct mutex u132_lock;
         int command_next;
         int command_head;
         struct u132_command command[COMMAND_SIZE];
@@ -330,39 +330,39 @@ static int ftdi_elan_hcd_init(struct usb_ftdi *ftdi)
 
 static void ftdi_elan_abandon_completions(struct usb_ftdi *ftdi)
 {
-        down(&ftdi->u132_lock);
+        mutex_lock(&ftdi->u132_lock);
         while (ftdi->respond_next > ftdi->respond_head) {
                 struct u132_respond *respond = &ftdi->respond[RESPOND_MASK &
                         ftdi->respond_head++];
                 *respond->result = -ESHUTDOWN;
                 *respond->value = 0;
                 complete(&respond->wait_completion);
-        } up(&ftdi->u132_lock);
+        } mutex_unlock(&ftdi->u132_lock);
 }
 
 static void ftdi_elan_abandon_targets(struct usb_ftdi *ftdi)
 {
         int ed_number = 4;
-        down(&ftdi->u132_lock);
+        mutex_lock(&ftdi->u132_lock);
         while (ed_number-- > 0) {
                 struct u132_target *target = &ftdi->target[ed_number];
                 if (target->active == 1) {
                         target->condition_code = TD_DEVNOTRESP;
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         ftdi_elan_do_callback(ftdi, target, NULL, 0);
-                        down(&ftdi->u132_lock);
+                        mutex_lock(&ftdi->u132_lock);
                 }
         }
         ftdi->recieved = 0;
         ftdi->expected = 4;
         ftdi->ed_found = 0;
-        up(&ftdi->u132_lock);
+        mutex_unlock(&ftdi->u132_lock);
 }
 
 static void ftdi_elan_flush_targets(struct usb_ftdi *ftdi)
 {
         int ed_number = 4;
-        down(&ftdi->u132_lock);
+        mutex_lock(&ftdi->u132_lock);
         while (ed_number-- > 0) {
                 struct u132_target *target = &ftdi->target[ed_number];
                 target->abandoning = 1;
@@ -382,9 +382,9 @@ static void ftdi_elan_flush_targets(struct usb_ftdi *ftdi)
                                 ftdi->command_next += 1;
                                 ftdi_elan_kick_command_queue(ftdi);
                         } else {
-                                up(&ftdi->u132_lock);
+                                mutex_unlock(&ftdi->u132_lock);
                                 msleep(100);
-                                down(&ftdi->u132_lock);
+                                mutex_lock(&ftdi->u132_lock);
                                 goto wait_1;
                         }
                 }
@@ -404,9 +404,9 @@ static void ftdi_elan_flush_targets(struct usb_ftdi *ftdi)
                                 ftdi->command_next += 1;
                                 ftdi_elan_kick_command_queue(ftdi);
                         } else {
-                                up(&ftdi->u132_lock);
+                                mutex_unlock(&ftdi->u132_lock);
                                 msleep(100);
-                                down(&ftdi->u132_lock);
+                                mutex_lock(&ftdi->u132_lock);
                                 goto wait_2;
                         }
                 }
@@ -414,13 +414,13 @@ static void ftdi_elan_flush_targets(struct usb_ftdi *ftdi)
         ftdi->recieved = 0;
         ftdi->expected = 4;
         ftdi->ed_found = 0;
-        up(&ftdi->u132_lock);
+        mutex_unlock(&ftdi->u132_lock);
 }
 
 static void ftdi_elan_cancel_targets(struct usb_ftdi *ftdi)
 {
         int ed_number = 4;
-        down(&ftdi->u132_lock);
+        mutex_lock(&ftdi->u132_lock);
         while (ed_number-- > 0) {
                 struct u132_target *target = &ftdi->target[ed_number];
                 target->abandoning = 1;
@@ -440,9 +440,9 @@ static void ftdi_elan_cancel_targets(struct usb_ftdi *ftdi)
                                 ftdi->command_next += 1;
                                 ftdi_elan_kick_command_queue(ftdi);
                         } else {
-                                up(&ftdi->u132_lock);
+                                mutex_unlock(&ftdi->u132_lock);
                                 msleep(100);
-                                down(&ftdi->u132_lock);
+                                mutex_lock(&ftdi->u132_lock);
                                 goto wait;
                         }
                 }
@@ -450,7 +450,7 @@ static void ftdi_elan_cancel_targets(struct usb_ftdi *ftdi)
         ftdi->recieved = 0;
         ftdi->expected = 4;
         ftdi->ed_found = 0;
-        up(&ftdi->u132_lock);
+        mutex_unlock(&ftdi->u132_lock);
 }
 
 static void ftdi_elan_kick_command_queue(struct usb_ftdi *ftdi)
@@ -886,14 +886,14 @@ static char *have_ed_set_response(struct usb_ftdi *ftdi,
         char *b)
 {
         int payload = (ed_length >> 0) & 0x07FF;
-        down(&ftdi->u132_lock);
+        mutex_lock(&ftdi->u132_lock);
         target->actual = 0;
         target->non_null = (ed_length >> 15) & 0x0001;
         target->repeat_number = (ed_length >> 11) & 0x000F;
         if (ed_type == 0x02) {
                 if (payload == 0 || target->abandoning > 0) {
                         target->abandoning = 0;
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                                 payload);
                         ftdi->recieved = 0;
@@ -903,13 +903,13 @@ static char *have_ed_set_response(struct usb_ftdi *ftdi,
                 } else {
                         ftdi->expected = 4 + payload;
                         ftdi->ed_found = 1;
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return b;
                 }
         } else if (ed_type == 0x03) {
                 if (payload == 0 || target->abandoning > 0) {
                         target->abandoning = 0;
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                                 payload);
                         ftdi->recieved = 0;
@@ -919,12 +919,12 @@ static char *have_ed_set_response(struct usb_ftdi *ftdi,
                 } else {
                         ftdi->expected = 4 + payload;
                         ftdi->ed_found = 1;
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return b;
                 }
         } else if (ed_type == 0x01) {
                 target->abandoning = 0;
-                up(&ftdi->u132_lock);
+                mutex_unlock(&ftdi->u132_lock);
                 ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                         payload);
                 ftdi->recieved = 0;
@@ -933,7 +933,7 @@ static char *have_ed_set_response(struct usb_ftdi *ftdi,
                 return ftdi->response;
         } else {
                 target->abandoning = 0;
-                up(&ftdi->u132_lock);
+                mutex_unlock(&ftdi->u132_lock);
                 ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                         payload);
                 ftdi->recieved = 0;
@@ -947,12 +947,12 @@ static char *have_ed_get_response(struct usb_ftdi *ftdi,
         struct u132_target *target, u16 ed_length, int ed_number, int ed_type,
         char *b)
 {
-        down(&ftdi->u132_lock);
+        mutex_lock(&ftdi->u132_lock);
         target->condition_code = TD_DEVNOTRESP;
         target->actual = (ed_length >> 0) & 0x01FF;
         target->non_null = (ed_length >> 15) & 0x0001;
         target->repeat_number = (ed_length >> 11) & 0x000F;
-        up(&ftdi->u132_lock);
+        mutex_unlock(&ftdi->u132_lock);
         if (target->active)
                 ftdi_elan_do_callback(ftdi, target, NULL, 0);
         target->abandoning = 0;
@@ -1278,7 +1278,7 @@ static int ftdi_elan_write_reg(struct usb_ftdi *ftdi, u32 data)
                 return -ENODEV;
         } else {
                 int command_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 if (command_size < COMMAND_SIZE) {
                         struct u132_command *command = &ftdi->command[
@@ -1292,10 +1292,10 @@ static int ftdi_elan_write_reg(struct usb_ftdi *ftdi, u32 data)
                         command->buffer = &command->value;
                         ftdi->command_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1310,7 +1310,7 @@ static int ftdi_elan_write_config(struct usb_ftdi *ftdi, int config_offset,
                 return -ENODEV;
         } else {
                 int command_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 if (command_size < COMMAND_SIZE) {
                         struct u132_command *command = &ftdi->command[
@@ -1324,10 +1324,10 @@ static int ftdi_elan_write_config(struct usb_ftdi *ftdi, int config_offset,
                         command->buffer = &command->value;
                         ftdi->command_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1342,7 +1342,7 @@ static int ftdi_elan_write_pcimem(struct usb_ftdi *ftdi, int mem_offset,
                 return -ENODEV;
         } else {
                 int command_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 if (command_size < COMMAND_SIZE) {
                         struct u132_command *command = &ftdi->command[
@@ -1356,10 +1356,10 @@ static int ftdi_elan_write_pcimem(struct usb_ftdi *ftdi, int mem_offset,
                         command->buffer = &command->value;
                         ftdi->command_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1382,7 +1382,7 @@ static int ftdi_elan_read_reg(struct usb_ftdi *ftdi, u32 *data)
         } else {
                 int command_size;
                 int respond_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 respond_size = ftdi->respond_next - ftdi->respond_head;
                 if (command_size < COMMAND_SIZE && respond_size < RESPOND_SIZE)
@@ -1405,11 +1405,11 @@ static int ftdi_elan_read_reg(struct usb_ftdi *ftdi, u32 *data)
                         ftdi->command_next += 1;
                         ftdi->respond_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         wait_for_completion(&respond->wait_completion);
                         return result;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1425,7 +1425,7 @@ static int ftdi_elan_read_config(struct usb_ftdi *ftdi, int config_offset,
         } else {
                 int command_size;
                 int respond_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 respond_size = ftdi->respond_next - ftdi->respond_head;
                 if (command_size < COMMAND_SIZE && respond_size < RESPOND_SIZE)
@@ -1449,11 +1449,11 @@ static int ftdi_elan_read_config(struct usb_ftdi *ftdi, int config_offset,
                         ftdi->command_next += 1;
                         ftdi->respond_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         wait_for_completion(&respond->wait_completion);
                         return result;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1469,7 +1469,7 @@ static int ftdi_elan_read_pcimem(struct usb_ftdi *ftdi, int mem_offset,
         } else {
                 int command_size;
                 int respond_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 respond_size = ftdi->respond_next - ftdi->respond_head;
                 if (command_size < COMMAND_SIZE && respond_size < RESPOND_SIZE)
@@ -1493,11 +1493,11 @@ static int ftdi_elan_read_pcimem(struct usb_ftdi *ftdi, int mem_offset,
                         ftdi->command_next += 1;
                         ftdi->respond_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         wait_for_completion(&respond->wait_completion);
                         return result;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1529,7 +1529,7 @@ static int ftdi_elan_edset_setup(struct usb_ftdi *ftdi, u8 ed_number,
                 return -ENODEV;
         } else {
                 int command_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 if (command_size < COMMAND_SIZE) {
                         struct u132_target *target = &ftdi->target[ed];
@@ -1550,10 +1550,10 @@ static int ftdi_elan_edset_setup(struct usb_ftdi *ftdi, u8 ed_number,
                         target->active = 1;
                         ftdi->command_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1586,7 +1586,7 @@ static int ftdi_elan_edset_input(struct usb_ftdi *ftdi, u8 ed_number,
                 return -ENODEV;
         } else {
                 int command_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 if (command_size < COMMAND_SIZE) {
                         struct u132_target *target = &ftdi->target[ed];
@@ -1615,10 +1615,10 @@ static int ftdi_elan_edset_input(struct usb_ftdi *ftdi, u8 ed_number,
                         target->active = 1;
                         ftdi->command_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1651,7 +1651,7 @@ static int ftdi_elan_edset_empty(struct usb_ftdi *ftdi, u8 ed_number,
                 return -ENODEV;
         } else {
                 int command_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 if (command_size < COMMAND_SIZE) {
                         struct u132_target *target = &ftdi->target[ed];
@@ -1672,10 +1672,10 @@ static int ftdi_elan_edset_empty(struct usb_ftdi *ftdi, u8 ed_number,
                         target->active = 1;
                         ftdi->command_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1708,7 +1708,7 @@ static int ftdi_elan_edset_output(struct usb_ftdi *ftdi, u8 ed_number,
                 return -ENODEV;
         } else {
                 int command_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 if (command_size < COMMAND_SIZE) {
                         u8 *b;
@@ -1751,10 +1751,10 @@ static int ftdi_elan_edset_output(struct usb_ftdi *ftdi, u8 ed_number,
                         target->active = 1;
                         ftdi->command_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1787,7 +1787,7 @@ static int ftdi_elan_edset_single(struct usb_ftdi *ftdi, u8 ed_number,
                 return -ENODEV;
         } else {
                 int command_size;
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 command_size = ftdi->command_next - ftdi->command_head;
                 if (command_size < COMMAND_SIZE) {
                         int remaining_length = urb->transfer_buffer_length -
@@ -1816,10 +1816,10 @@ static int ftdi_elan_edset_single(struct usb_ftdi *ftdi, u8 ed_number,
                         target->active = 1;
                         ftdi->command_next += 1;
                         ftdi_elan_kick_command_queue(ftdi);
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         msleep(100);
                         goto wait;
                 }
@@ -1849,9 +1849,9 @@ static int ftdi_elan_edset_flush(struct usb_ftdi *ftdi, u8 ed_number,
                 return -ENODEV;
         } else {
                 struct u132_target *target = &ftdi->target[ed];
-                down(&ftdi->u132_lock);
+                mutex_lock(&ftdi->u132_lock);
                 if (target->abandoning > 0) {
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 } else {
                         target->abandoning = 1;
@@ -1873,13 +1873,13 @@ static int ftdi_elan_edset_flush(struct usb_ftdi *ftdi, u8 ed_number,
                                         ftdi->command_next += 1;
                                         ftdi_elan_kick_command_queue(ftdi);
                                 } else {
-                                        up(&ftdi->u132_lock);
+                                        mutex_unlock(&ftdi->u132_lock);
                                         msleep(100);
-                                        down(&ftdi->u132_lock);
+                                        mutex_lock(&ftdi->u132_lock);
                                         goto wait_1;
                                 }
                         }
-                        up(&ftdi->u132_lock);
+                        mutex_unlock(&ftdi->u132_lock);
                         return 0;
                 }
         }
@@ -2791,7 +2791,7 @@ static int ftdi_elan_probe(struct usb_interface *interface,
         init_MUTEX(&ftdi->sw_lock);
         ftdi->udev = usb_get_dev(interface_to_usbdev(interface));
         ftdi->interface = interface;
-        init_MUTEX(&ftdi->u132_lock);
+        mutex_init(&ftdi->u132_lock);
         ftdi->expected = 4;
         iface_desc = interface->cur_altsetting;
         for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

  Control over the use of one's ideas really constitutes control over other
  people's lives; and it is usually used to make their lives more difficult.
                          (Richard Stallman)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
