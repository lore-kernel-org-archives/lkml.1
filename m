Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbYKWQSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbYKWQSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbYKWQRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:17:54 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:47165 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbYKWQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:17:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=lJOmkuX5LSXzrzRnhOOTPn3aUbyTdoy/hFu2GEnH1ws2hZKAjr0jU+5fl04xgvA1wK
         Qpe16s4goY2gfmHSEZUNEGEDRKDJ8r+VYXz9QEnvzUL5mcfz+UnVorxbBbjYfUNoSZF6
         GFxlP9UOXY8nUyJRWbxAwz1fwrKfzSgI58IkY=
Message-ID: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
Date: Sun, 23 Nov 2008 17:17:50 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
As the subject says, I have a strange regression in latest git.
Sometimes resume from hibernating hangs _after_ the resume stage.
When the problem happens I usually have to powercycle my laptop.

The system managed to recover from the hang only twice and this time I
found in the logs:

Nov 23 16:43:14 hawking kernel: sd 0:0:0:0: [sda] Starting disk
Nov 23 16:43:14 hawking kernel: Restarting tasks ... done.
Nov 23 16:43:52 hawking kernel: ata1.01: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x6 frozen
Nov 23 16:43:52 hawking kernel: ata1.01: cmd
a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
Nov 23 16:43:52 hawking kernel:          cdb 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
Nov 23 16:43:52 hawking kernel:          res
40/00:03:00:00:00/00:00:00:00:00/b0 Emask 0x4 (timeout)
Nov 23 16:43:52 hawking kernel: ata1.01: status: { DRDY }
Nov 23 16:43:52 hawking kernel: ata1: soft resetting link
Nov 23 16:43:57 hawking kernel: ata1.01: qc timeout (cmd 0xa1)
Nov 23 16:43:57 hawking kernel: ata1.01: failed to IDENTIFY (I/O
error, err_mask=0x4)
Nov 23 16:43:57 hawking kernel: ata1.01: revalidation failed (errno=-5)
Nov 23 16:43:57 hawking kernel: ata1: soft resetting link
Nov 23 16:44:08 hawking kernel: ata1.01: qc timeout (cmd 0xa1)
Nov 23 16:44:08 hawking kernel: ata1.01: failed to IDENTIFY (I/O
error, err_mask=0x4)
Nov 23 16:44:08 hawking kernel: ata1.01: revalidation failed (errno=-5)
Nov 23 16:44:08 hawking kernel: ata1: soft resetting link
Nov 23 16:44:38 hawking kernel: ata1.00: configured for UDMA/100
Nov 23 16:44:38 hawking kernel: ata1.01: configured for MWDMA2
Nov 23 16:44:38 hawking kernel: ata1: EH complete
Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] 156301488 512-byte
hardware sectors: (80.0 GB/74.5 GiB)
Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Write Protect is off
Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] 156301488 512-byte
hardware sectors: (80.0 GB/74.5 GiB)
Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Write Protect is off
Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Nov 23 16:44:39 hawking kernel: sd 0:0:0:0: [sda] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA

This problem:

* never happened in 2.6.27.4
* happened many times in 2.6.27.5 and .6
* never happened in 2.6.27.7
* happened the first time with the current -rc series just now (the
logs are related to this one)

This is the first 2.6.28-rc kernel I tried.

I have to say that my kernel is tainted (fglrx and cisco_ipsec) but I
also managed to replicate the hangs also with non-tainted ones.

I already tried some bisection between 2.6.27.4 and 2.6.27.5 but with
no result, probably because I marked as "good" kernel that weren't
good at all. Unfortunately this bug happens really at random times.

During the bisection I always used non-tainted kernels.

If anyone has ideas, I can provide some more data; I can also try
another bisection series but I think it would take very long to get
some good results (I mean, some days of testing between two different
kernels just to reproduce the bug).

Regards,
Fabio
