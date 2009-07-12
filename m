Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZGLLLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZGLLLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZGLLK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:10:58 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49139 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZGLLK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=UXcz7yOI48+VJ0d7yPYeYJxOOMFVK6cULCJls079JN3aD3Eh+q8RCsEVLKjgNutsEP
         z97/8na4sPQiY7PYnXq3Mb4nXyJszwt0uepyH8lTtQ65XzoQUVNyLHo2REzE03LjQNRK
         l/8i6CgbakYLwHczZrufJJVjM0XmOJgsxTn3M=
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 13:10:55 +0200
Message-ID: <bc11cfae0907120410r27613eeeve186ed27871439a1@mail.gmail.com>
Subject: Re: tpm_tis: various cleanups, and support for Intel iTPM
From: Martin Pirker <lkml.collector@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Jun Andy Isaacson wrote:
>Several patches to improve drivers/char/tpm/tpm_tis.c

Testing these patches
with 2.6.30-gentoo-r2 (aka 2.6.30.1) and
with Intel TPM
on desktop ("q") ICH10 based system and
mobile system("s") ICH9 based system:



case 1:
desktop, 2.6.30-gentoo-r2
summary: kernel requires "force=1" for tpm_tis to load,
takes 2 minutes, but works afterwards

q m # dmesg |grep -i tpm
q m # uname -r -m
2.6.30-gentoo-r2 x86_64
q m # lsmod |grep -i tpm
q m # ls -la /dev/tpm*
ls: cannot access /dev/tpm*: No such file or directory
q m # time modprobe tpm_tis force=1
real    2m0.166s
user    0m0.000s
sys     0m0.000s
q m # ls -la /dev/tpm*
crw-rw---- 1 root root 10, 224 Jul  8 13:50 /dev/tpm0
q sys # ls -ld /sys/devices/platform/tpm_tis/*
-r--r--r-- 1 root root 4096 Jul  8 14:09 /sys/devices/platform/tpm_tis/active
--w--w---- 1 root root 4096 Jul  8 14:09 /sys/devices/platform/tpm_tis/cancel
-r--r--r-- 1 root root 4096 Jul  8 14:09 /sys/devices/platform/tpm_tis/caps
lrwxrwxrwx 1 root root    0 Jul  8 14:09
/sys/devices/platform/tpm_tis/driver ->
../../../bus/platform/drivers/tpm_tis
-r--r--r-- 1 root root 4096 Jul  8 14:09 /sys/devices/platform/tpm_tis/enabled
drwxr-xr-x 3 root root    0 Jul  8 13:50 /sys/devices/platform/tpm_tis/misc
-r--r--r-- 1 root root 4096 Jul  8 14:09 /sys/devices/platform/tpm_tis/modalias
-r--r--r-- 1 root root 4096 Jul  8 14:09 /sys/devices/platform/tpm_tis/owned
-r--r--r-- 1 root root 4096 Jul  8 14:09 /sys/devices/platform/tpm_tis/pcrs
drwxr-xr-x 2 root root    0 Jul  8 14:09 /sys/devices/platform/tpm_tis/power
-r--r--r-- 1 root root 4096 Jul  8 14:09 /sys/devices/platform/tpm_tis/pubek
lrwxrwxrwx 1 root root    0 Jul  8 13:50
/sys/devices/platform/tpm_tis/subsystem -> ../../../bus/platform
-r--r--r-- 1 root root 4096 Jul  8 14:09
/sys/devices/platform/tpm_tis/temp_deactivated
-rw-r--r-- 1 root root 4096 Jul  8 13:50 /sys/devices/platform/tpm_tis/uevent
q m # cat /sys/devices/platform/tpm_tis/pcrs
PCR-00: C1 86 AA F6 60 65 96 47 30 EB FC A7 D8 4B 1F D2 78 26 6D 39
[...]
PCR-23: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
q m #



case 2:
desktop, 2.6.30-gentoo-r2 with patches
summary: tpm_tis is autoloaded and works,
however, the helpful info things in /sys/devices/platform/tpm_tis are missing

q m # dmesg |grep -i tpm
[    6.899857] tpm_tis INTC0102:00: found 0xfed40000(0x5000)
[    6.899867] tpm_tis INTC0102:00: no IRQ found in _CRS, polling mode
[    6.899924] tpm_tis INTC0102:00: 1.2 TPM (8086:1040 rev 4)
q m # uname -r -m
2.6.30-gentoo-r2-tispatch x86_64
q m # lsmod |grep -i tpm
tpm_tis                14740  0
tpm                    18176  1 tpm_tis
tpm_bios                7744  1 tpm
q m # ls -la /dev/tpm*
crw-rw---- 1 root root 10, 224 Jul  8 14:12 /dev/tpm0
q m # ls -ld /sys/devices/platform/tpm_tis/*
ls: cannot access /sys/devices/platform/tpm_tis/*: No such file or directory

but
/sys/kernel/security/tpm0
/sys/kernel/security/tpm0/ascii_bios_measurements
/sys/kernel/security/tpm0/binary_bios_measurements



case 3:
mobile, 2.6.30-gentoo-r2
summary: TPM access does not work at all

s m # dmesg |grep -i tpm
s m # uname -r -m
2.6.30-gentoo-r2 x86_64
s m # lsmod |grep -i tpm
s m # ls -la /dev/tpm*
ls: cannot access /dev/tpm*: No such file or directory
s m # time modprobe tpm_tis

real    0m0.067s
user    0m0.000s
sys     0m0.008s
s m # ls -la /dev/tpm*
ls: cannot access /dev/tpm*: No such file or directory



case 4:
mobile, 2.6.30-gentoo-r2 with patches
summary: tpm_tis is autoloaded and works,
however, the helpful info things in /sys/devices/platform/tpm_tis are missing

s m # dmesg |grep -i tpm
[    3.559757] tpm_tis INTC0102:00: found 0xfed40000(0x5000)
[    3.559767] tpm_tis INTC0102:00: no IRQ found in _CRS, polling mode
[    3.559828] tpm_tis INTC0102:00: 1.2 TPM (8086:1020 rev 6)
[    3.559830] tpm_tis INTC0102:00: Intel iTPM workaround enabled
s m # uname -r -m
2.6.30-gentoo-r2-tispatch x86_64
s m # lsmod |grep -i tpm
tpm_tis                14740  0
tpm                    18176  1 tpm_tis
tpm_bios                7744  1 tpm
s m # ls -la /dev/tpm*
crw-rw---- 1 root root 10, 224 Jul 12 12:36 /dev/tpm0
s sys # ls -ld /sys/devices/platform/tpm_tis/*
ls: cannot access /sys/devices/platform/tpm_tis/*: No such file or directory
s sys # cat /sys/kernel/security/tpm0/ascii_bios_measurements
[...]




Overall impressions:
PCR readout with jTpmTools appears to be working ok if tpm_tis is working.
I havn't had the time to run the full jTSS self-test suite.
Curious fact: Intel TPM ships without Endorsement Key. Create one on
a desktop box, delete it by removing the CMOS battery. How does one do
that on a mobile? :-)

Next stop: try tboot on Intel TPM - however the patches do not seem to
apply cleanly to kernel and latest TrouSerS....


hope this helps,
Martin
