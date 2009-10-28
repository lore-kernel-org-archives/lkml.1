Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZJ1W2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZJ1W2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZJ1W2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:28:40 -0400
Received: from mailgw.kvados.cz ([194.213.53.146]:41505 "EHLO mailgw.kvados.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZJ1W2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:28:39 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2009 18:28:39 EDT
From: Milan Dadok <milan@dadok.name>
To: "'Greg Kroah-Hartman'" <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, "'Hank Janssen'" <hjanssen@microsoft.com>,
       "'Haiyang Zhang'" <haiyangz@microsoft.com>
Subject: [PATCH] 0/3 staging: hv: fix oops in vmbus 
Date: Wed, 28 Oct 2009 23:23:18 +0100
Message-ID: <001301ca581d$400f4980$c02ddc80$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcpYHT9qF7oZsVbYRf2xaYdJxHUbww==
Content-Language: cs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm sending patches to make hv_netvsc working correclly.
After these code corrections I can confirm, that hv drivers are loading
without error and 
network interface seth0 is working (Gentoo Guest)

Tested
ping, ssh, wget  Ok
iperf -c  don't work - network is lock somehow, console is still working

These two patches are needed too.
Haiyang Zhang's patch from 2009-10-23 18:14:24 [PATCH] Staging: hv: Fix null
pointer error after vmbus loading
Hank Janssen's patch from  2009-10-16 20:11:36 [PATCH 1/1] Staging: hv: Fix
vmbus load hang caused by faulty data

For udev events I used next udev config files (published in Microsoft
Hyper-V Linux IC)

Milan

---
diff -uprN /etc.old/udev/rules.d/20_netvs.rules
/etc/udev/rules.d/20_netvs.rules
--- /etc.old/udev/rules.d/20_netvs.rules        1970-01-01
01:00:00.000000000 +0100
+++ /etc/udev/rules.d/20_netvs.rules    2009-10-20 08:58:54.000000000 +0200
@@ -0,0 +1,2 @@
+SUBSYSTEM=="net", ENV{INTERFACE}=="seth[0-9]*",
RUN+="/etc/vmbus/netvsc.uevent $env{ACTION} $env{INTERFACE}"
+
diff -uprN /etc.old/udev/rules.d/20_vmbus.rules
/etc/udev/rules.d/20_vmbus.rules
--- /etc.old/udev/rules.d/20_vmbus.rules        1970-01-01
01:00:00.000000000 +0100
+++ /etc/udev/rules.d/20_vmbus.rules    2009-10-20 08:59:14.000000000 +0200
@@ -0,0 +1 @@
+SUBSYSTEM=="vmbus", RUN+="/etc/vmbus/vmbus.uevent $env{ACTION}
$env{VMBUS_DEVICE_CLASS_GUID}"
diff -uprN /etc.old/vmbus/vmbus.uevent /etc/vmbus/vmbus.uevent
--- /etc.old/vmbus/vmbus.uevent 1970-01-01 01:00:00.000000000 +0100
+++ /etc/vmbus/vmbus.uevent     2009-10-28 00:08:24.000000000 +0100
@@ -0,0 +1,56 @@
+#!/bin/bash
+#
+# Copyright (c) 2009, Microsoft Corporation.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+# This program is distributed in the hope it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+# more details.
+#
+# You should have received a copy of the GNU General Public License along
with
+# this program; if not, write to the Free Software Foundation, Inc., 59
Temple
+# Place - Suite 330, Boston, MA 02111-1307 USA.
+#
+# Authors:
+#   Haiyang Zhang <haiyangz@microsoft.com>
+#   Hank Janssen  <hjanssen@microsoft.com>
+#
+
+NETWORK_CLASS_GUID="{f8615163-df3e-46c5-913ff2d2f965ed0e}"
+STORAGE_CLASS_GUID="{ba6163d9-04a1-4d29-b60572e2ffb1dc7f}"
+
+usage() {
+ echo "Usage:"
+ echo -e "\t<add|remove> <vmbus device class guid>"
+ exit
+}
+
+# make sure we have 2 args
+[ -n "$1" ] || usage
+[ -n "$2" ] || usage
+
+ACTION=$1
+VMBUS_DEVICE_CLASS_GUID=$2
+
+if [ $ACTION = "add" ]; then
+       echo -n "adding device $VMBUS_DEVICE_CLASS_GUID..."
+       if [ $VMBUS_DEVICE_CLASS_GUID = $NETWORK_CLASS_GUID ]; then
+               /sbin/modprobe hv_netvsc
+       elif [ $VMBUS_DEVICE_CLASS_GUID = $STORAGE_CLASS_GUID ]; then
+               /sbin/modprobe hv_storvsc
+       else
+               echo "vmbus.uevent: unknown class id -
$VMBUS_DEVICE_CLASS_GUID"
+       fi
+       echo "done"
+elif [ $ACTION = "remove" ]; then
+       echo -n "removing device $VMBUS_DEVICE_CLASS_GUID..."
+       # TODO: add rmmod
+       echo "done"
+else
+       echo "unknown action - $ACTION"
+fi
+
diff -uprN /etc.old/vmbus/netvsc.uevent /etc/vmbus/netvsc.uevent
--- /etc.old/vmbus/netvsc.uevent        1970-01-01 01:00:00.000000000 +0100
+++ /etc/vmbus/netvsc.uevent    2009-10-28 00:17:53.000000000 +0100
@@ -0,0 +1,67 @@
+#!/bin/bash
+#
+# Copyright (c) 2009, Microsoft Corporation.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+# This program is distributed in the hope it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+# more details.
+#
+# You should have received a copy of the GNU General Public License along
with
+# this program; if not, write to the Free Software Foundation, Inc., 59
Temple
+# Place - Suite 330, Boston, MA 02111-1307 USA.
+#
+# Authors:
+#   Haiyang Zhang <haiyangz@microsoft.com>
+#   Hank Janssen  <hjanssen@microsoft.com>
+#
+
+usage() {
+ echo "Usage:"
+ echo -e "\t<add> <interface>"
+ exit
+}
+
+# make sure we have 2 args
+[ -n "$1" ] || usage
+[ -n "$2" ] || usage
+
+ACTION=$1
+INTERFACE=$2
+
+INTERFACE_CONFIG_FILE=
+
+if [ -f /etc/redhat-release ]; then
+  INTERFACE_CONFIG_DIR=/etc/sysconfig/network-scripts
+elif [ -f /etc/SuSE-release ]; then
+  INTERFACE_CONFIG_DIR=/etc/sysconfig/network
+else
+  INTERFACE_CONFIG_DIR=/etc/sysconfig/network-scripts
+fi
+
+# On Sles, let yast autogenerates the ifcfg file.
+if [ -f /etc/redhat-release ]; then
+       if [[ $ACTION = "add" && $INTERFACE =~ 'seth[0-9]+' ]]; then
+         INTERFACE_CONFIG_FILE=$INTERFACE_CONFIG_DIR/ifcfg-$INTERFACE
+         if [ ! -f $INTERFACE_CONFIG_FILE ]; then
+                echo -n "adding interface configuration file -
$INTERFACE_CONFIG_FILE..."
+                echo "DEVICE=$INTERFACE" > $INTERFACE_CONFIG_FILE
+                echo "BOOTPROTO=dhcp" >> $INTERFACE_CONFIG_FILE
+                if [ -f /etc/redhat-release ]; then
+                  echo "ONBOOT=yes" >> $INTERFACE_CONFIG_FILE
+                elif [ -f /etc/SuSE-release ]; then
+                  echo "STARTMODE=auto" >> $INTERFACE_CONFIG_FILE
+                else
+                  echo "ONBOOT=yes" >> $INTERFACE_CONFIG_FILE
+                fi
+         fi
+         echo "done"
+       fi
+fi
+
---


