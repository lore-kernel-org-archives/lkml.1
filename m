Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbZFLOXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbZFLOXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZFLOXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:23:04 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:57441 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbZFLOXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:23:03 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core temperature
Date: Fri, 12 Jun 2009 09:23:00 -0500
User-Agent: KMail/1.9.9
Cc: Jean Delvare <khali@linux-fr.org>,
       Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <20090609083406.GE25316@prithivi.gnumonks.org> <20090612125450.GK30843@prithivi.gnumonks.org> <200906120841.08114.lkml@morethan.org>
In-Reply-To: <200906120841.08114.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906120923.02851.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 12 2009, Michael S. Zick wrote:
> On Fri June 12 2009, Harald Welte wrote:
> > On Fri, Jun 12, 2009 at 06:46:45AM -0500, Michael S. Zick wrote:
> > > > Temperature values are supposed to be expressed in millidegrees C, not
> > > > degrees C as it seems to be doing (although 25 degrees C seems pretty
> > > > low for a CPU temperature?) The drivers needs to multiply values by
> > > > 1000 before exporting them to sysfs. Then "sensors" will report the
> > > > correct temperature value.
> > > > 
> > > 
> > > Ah, 25 degrees C is room temperature - real hard for the junction temperature
> > > to be 25 degrees C with power applied; lacking an infinitely perfect heatsink.
> > > 
> > > Look for an "off by one" error in shifting or masking the value.
> > 
> > there is no shifting and the masking is 0xffffffff :)
> > 
> > it might be that the BIOS is doing something wrong when programming the
> > calibration MSR's at early botoup.  I would need the contents of MSR 
> > 0x1160 ... 0x116C as well as 0x1152 and 0x1153 to be able to determine that.
> > 
> 
> root@cb01:~# for r in 0x1160 0x1161 0x1162 0x1163 0x1164 0x1165 0x1166 0x1167 0x1168 0x1169 0x116a 0x116b 0x116c 0x1152 0x1153 ; do ./rdmsr $r ; done
> MSR register 0x1160 => 08:04:98:10:b7:ef:8f:f4
> MSR register 0x1161 => 08:04:98:10:b7:fb:af:f4
> MSR register 0x1162 => 08:04:98:10:b7:ec:ff:f4
> MSR register 0x1163 => 08:04:98:10:b7:fa:cf:f4
> MSR register 0x1164 => 08:04:98:10:b7:f4:cf:f4
> MSR register 0x1165 => 08:04:98:10:b7:f3:2f:f4
> MSR register 0x1166 => 08:04:98:10:b7:f1:7f:f4
> MSR register 0x1167 => 08:04:98:10:b7:f2:0f:f4
> MSR register 0x1168 => 08:04:98:10:b7:ef:0f:f4
> MSR register 0x1169 => 08:04:98:10:b7:fc:8f:f4
> MSR register 0x116a => 08:04:98:10:b7:ef:8f:f4
> MSR register 0x116b => 08:04:98:10:b7:f8:bf:f4
> MSR register 0x116c => 08:04:98:10:b7:f9:df:f4
> MSR register 0x1152 => 08:04:98:10:b7:ed:5f:f4
> MSR register 0x1153 => 08:04:98:10:b7:ed:cf:f4
> 
> The high 32b look strange in that output - might be
> the utility I used (attached).
> 

Yes - that utility had problems with casting the address;
I think I fixed that, this looks better:

root@cb01:~# for r in 0x1160 0x1161 0x1162 0x1163 0x1164 0x1165 0x1166 0x1167 0x1168 0x1169 0x116a 0x116b 0x116c 0x1152 0x1153 ; do ./rdmsrll $r ; done
MSR register 0x1160 => 08:04:83:94:bf:86:e1:d8
MSR register 0x1161 => 08:04:83:94:bf:ec:73:78
MSR register 0x1162 => 08:04:83:94:bf:bf:4b:58
MSR register 0x1163 => 08:04:83:94:bf:bc:82:28
MSR register 0x1164 => 08:04:83:94:bf:b1:1d:98
MSR register 0x1165 => 08:04:83:94:bf:cb:09:88
MSR register 0x1166 => 08:04:83:94:bf:d0:03:e8
MSR register 0x1167 => 08:04:83:94:bf:91:26:18
MSR register 0x1168 => 08:04:83:94:bf:99:26:38
MSR register 0x1169 => 08:04:83:94:bf:b3:f1:08
MSR register 0x116a => 08:04:83:94:bf:d5:42:88
MSR register 0x116b => 08:04:83:94:bf:f8:b6:28
MSR register 0x116c => 08:04:83:94:bf:f6:68:88
MSR register 0x1152 => 08:04:83:94:bf:d5:b4:f8
MSR register 0x1153 => 08:04:83:94:bf:bd:d5:28

Mike
> Mike
> 
> 


