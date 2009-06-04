Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZFDGrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZFDGrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZFDGr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 02:47:26 -0400
Received: from ns1.siteground150.com ([67.15.243.6]:47146 "EHLO
	serv01.siteground150.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZFDGr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 02:47:26 -0400
MIME-Version: 1.0
Date: Thu, 04 Jun 2009 01:47:18 -0500
From: <lkml@reliableembeddedsystems.com>
To: balbir@linux.vnet.ibm.com
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Robert Berger <robert.berger@reliableembeddedsystems.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: http://patchwork.kernel.org/patch/26483/ broke my system boot
In-Reply-To: <20090604063144.GB7504@balbir.in.ibm.com>
References: <20090603143944.GF29326@balbir.in.ibm.com> <20090603194526.GG3100@uranus.ravnborg.org> <20090604063144.GB7504@balbir.in.ibm.com>
Message-ID: <21fac393599ff68ff8edab1bade68ab2@reliableembeddedsystems.com>
User-Agent: RoundCube Webmail/0.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground150.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - reliableembeddedsystems.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir and all,

Sorry for the trouble and the missing changelog. I'm still learning;)

Can you please elaborate a bit more what exactly is broken?
Are you cross- or native compiling?

Here is what I tried to fix:

In my cross build environment (ELDK4.2) the following is defined:

export | grep DEPMOD
declare -x DEPMOD="/opt/eldk-4.2-ppc_4xx/usr/bin/depmod.pl"

without my patch it breaks like this:

 make V=1 ARCH=powerpc CROSS_COMPILE=ppc_4xx-
INSTALL_MOD_PATH=$ELDK_PREFIX/eldk-4.2-ppc_4xx/ppc_4xx modules_install
Warning: you may need to install module-init-tools
See http://www.codemonkey.org.uk/docs/post-halloween-2.6.txt
make -f
/opt/eldk-4.2-ppc_4xx/usr/src/linux-v2.6.29.1/scripts/Makefile.modinst
  mkdir -p
/opt/eldk-4.2-ppc_4xx/ppc_4xx/lib/modules/2.6.30-rc5-01317-g982dd86/kernel/drivers/scsi;
cp drivers/scsi/scsi_wait_scan.ko
/opt/eldk-4.2-ppc_4xx/ppc_4xx/lib/modules/2.6.30-rc5-01317-g982dd86/kernel/drivers/scsi
; true
/opt/eldk-4.2-ppc_4xx/ppc_4xx/lib/modules/2.6.30-rc5-01317-g982dd86/kernel/drivers/scsi/scsi_wait_scan.ko
make -f
/opt/eldk-4.2-ppc_4xx/usr/src/linux-v2.6.29.1/scripts/Makefile.fwinst
obj=firmware __fw_modinst
  if [ -r System.map -a -x /opt/eldk-4.2-ppc_4xx/usr/bin/depmod.pl ]; then
/opt/eldk-4.2-ppc_4xx/usr/bin/depmod.pl -ae -F System.map  -b
/opt/eldk-4.2-ppc_4xx/ppc_4xx  2.6.30-rc5-01317-g982dd86; fi
make: *** [_modinst_post] Error 1

with my patch it is more happy:

 make V=1 ARCH=powerpc CROSS_COMPILE=ppc_4xx-
INSTALL_MOD_PATH=$ELDK_PREFIX/eldk-4.2-ppc_4xx/ppc_4xx modules_install
Warning: you may need to install module-init-tools
See http://www.codemonkey.org.uk/docs/post-halloween-2.6.txt
make -f
/opt/eldk-4.2-ppc_4xx/usr/src/linux-v2.6.29.1/scripts/Makefile.modinst
  mkdir -p
/opt/eldk-4.2-ppc_4xx/ppc_4xx/lib/modules/2.6.30-rc5-01317-g982dd86/kernel/drivers/scsi;
cp drivers/scsi/scsi_wait_scan.ko
/opt/eldk-4.2-ppc_4xx/ppc_4xx/lib/modules/2.6.30-rc5-01317-g982dd86/kernel/drivers/scsi
; true
/opt/eldk-4.2-ppc_4xx/ppc_4xx/lib/modules/2.6.30-rc5-01317-g982dd86/kernel/drivers/scsi/scsi_wait_scan.ko
make -f
/opt/eldk-4.2-ppc_4xx/usr/src/linux-v2.6.29.1/scripts/Makefile.fwinst
obj=firmware __fw_modinst

I could most likely just undefine DEPMOD in the environment.

(here DEPMOD is not defined):

make v=1 ARCH=powerpc CROSS_COMPILE=ppc_4xx-
INSTALL_MOD_PATH=$ELDK_PREFIX/eldk-4.2-ppc_4xx/ppc_4xx modules_install
  INSTALL drivers/scsi/scsi_wait_scan.ko
  DEPMOD  2.6.30-rc5-01317-g982dd86

This seems to be working fine as well.

I did not try the native compilation. Maybe the problem is there?

Regards,

Robert


On Thu, 4 Jun 2009 14:31:44 +0800, Balbir Singh <balbir@linux.vnet.ibm.com>
wrote:
> * Sam Ravnborg <sam@ravnborg.org> [2009-06-03 21:45:26]:
> 
>> On Wed, Jun 03, 2009 at 10:39:44PM +0800, Balbir Singh wrote:
>> > After spending some time figuring out why my system failed to reboot,
>> > checking config options, kernel version, modules installed. I figured
>> > out that the patch in http://patchwork.kernel.org/patch/26483/ broke
>> > the system boot on the latest mmotm. Reverting it helped my system
>> > call depmod and hence boot.
>> > 
>> > The patch is really unhelpful, since the changelog is completely
>> > empty. Sigh!
>> 
>> Yeah, sorry for not nak'ing it earlier. Has been busy.
>> Andrew removed it from -mm and I notified the author about the
>> problems with the patch (in private mail it seems - I just replied to
>> what I had).
> 
> Cool! Thanks for the update. I'll get the latest mmotm and test as
> well.
