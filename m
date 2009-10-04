Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZJDKuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZJDKuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 06:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbZJDKt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 06:49:59 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:62329 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZJDKt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 06:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=N7oBTPGdbHmTDIdk4N0Zg4xagnO7JrbIIh8Xy5Q7FoKDWgTCjjnt9OOznjAX9ejAi8
         omQZBbeU0f2ue1uDd2xUsSd3CS3KG+qpcyjUN6TgRelDzqmjvxZNng9Ak7hEA+ksp7VF
         fGBeDZ3D20Y1dGFmAcIvi/kN6drTvko5/Rk/Q=
MIME-Version: 1.0
Date: Sun, 4 Oct 2009 12:49:19 +0200
Message-ID: <4e5e476b0910040349l21b69a97o7a11b2138bc8f573@mail.gmail.com>
Subject: [bisected] commit: a9327cac440be4d8333bba975cbbf76045096275 causes 
	iostat output
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>, knikanth@suse.de,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
with 2.6.32-rc1 I started getting the following strange output from
"iostat -kx 2":
Linux 2.6.31bisect (et2) 	04/10/2009 	_i686_	(2 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10,70    0,00    3,16   15,75    0,00   70,38

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda              18,22     0,00    0,67    0,01    14,77     0,02
43,94     0,01   10,53 39043915,03 2629219,87
sdb              60,89     9,68   50,79    3,04  1724,43    50,52
65,95     0,70   13,06 488437,47 2629219,87

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2,72    0,00    0,74    0,00    0,00   96,53

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00
0,00     0,00    0,00   0,00 100,00
sdb               0,00     0,00    0,00    0,00     0,00     0,00
0,00     0,00    0,00   0,00 100,00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           6,68    0,00    0,99    0,00    0,00   92,33

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00
0,00     0,00    0,00   0,00 100,00
sdb               0,00     0,00    0,00    0,00     0,00     0,00
0,00     0,00    0,00   0,00 100,00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4,40    0,00    0,73    1,47    0,00   93,40

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00
0,00     0,00    0,00   0,00 100,00
sdb               0,00     4,00    0,00    3,00     0,00    28,00
18,67     0,06   19,50 333,33 100,00

Global values for service time and utilization are garbage. For
interval values, utilization is always 100%, and service time is
higher than normal.

I bisected it down to:
[a9327cac440be4d8333bba975cbbf76045096275] Seperate read and write
statistics of in_flight requests
and verified that reverting just that commit indeed solves the issue
on 2.6.32-rc1.

My sysstat package is:
[corrado@et2 linux-2.6]$ rpm -qi sysstat
Name        : sysstat                      Relocations: (not relocatable)
Version     : 9.0.1                             Vendor: Mandriva
Release     : 1mdv2009.1                    Build Date: mer 11 mar
2009 20:50:16 CET
Install Date: lun 27 lug 2009 21:25:13 CEST      Build Host: n2.mandriva.com
Group       : System/Configuration/Other    Source RPM:
sysstat-9.0.1-1mdv2009.1.src.rpm
Size        : 681881                           License: GPL
Signature   : DSA/SHA1, gio 23 apr 2009 20:40:00 CEST, Key ID 445935f878d019f5
Packager    : Frederik Himpe <fhimpe@mandriva.org>
URL         : http://perso.wanadoo.fr/sebastien.godard
Summary     : Includes the sar and iostat system monitoring commands
Description :
This package provides the sar and iostat commands for the Linux
operating system, similar to their traditional UNIX counterparts.
They enable system monitoring of disk, network, and other IO activity.

Thanks,
Corrado
-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
