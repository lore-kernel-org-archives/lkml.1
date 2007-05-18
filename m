Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbXERH02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbXERH02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXERH0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:26:22 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48567
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbXERH0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:26:21 -0400
From: Rob Landley <rob@landley.net>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Subject: Re: UML doesn't compile in 2.6.21
Date: Fri, 18 May 2007 03:25:57 -0400
User-Agent: KMail/1.9.1
Cc: LKML <linux-kernel@vger.kernel.org>, jdike@karaya.com
References: <20070516224938.GN12319@pengutronix.de> <200705162111.19123.rob@landley.net> <20070517210538.GO12319@pengutronix.de>
In-Reply-To: <20070517210538.GO12319@pengutronix.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FUVTG873thDu9LT"
Message-Id: <200705180325.57693.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_FUVTG873thDu9LT
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 17 May 2007 5:05 pm, Robert Schwebel wrote:
> Rob,
> 
> On Wed, May 16, 2007 at 09:11:18PM -0400, Rob Landley wrote:
> > 2.6.21.1 built for me:
> > 
> > tar xvjf linux-2.6.21.1.tar.bz2 &&
> > cd linux-2.6.21.1 &&
> > cat > mini.conf << EOF
> > CONFIG_MODE_SKAS=y
> > CONFIG_BINFMT_ELF=y
> > CONFIG_HOSTFS=y
> > CONFIG_SYSCTL=y
> > CONFIG_STDERR_CONSOLE=y
> > CONFIG_UNIX98_PTYS=y
> > CONFIG_BLK_DEV_LOOP=y
> > CONFIG_LBD=y
> > CONFIG_EXT2_FS=y
> > CONFIG_PROC_FS=y
> > EOF
> > make ARCH=um allnoconfig KCONFIG_ALLCONFIG=mini.conf &&
> > make ARCH=um &&
> > ./linux rootfstype=hostfs rw init=/bin/sh
> > 
> > Does this not work for you?
> 
> Yes, this compiles - with this warning, btw:
> 
> WARNING: vmlinux - Section mismatch: reference to .init.text:lpj_setup 
from .got after '_GLOBAL_OFFSET_TABLE_' (at offset 0x814de34)
> WARNING: vmlinux - Section mismatch: reference 
to .init.text:set_reset_devices from .bss between 'stdout@@GLIBC_2.0' (at 
offset 0x814de40) and 'stderr@@GLIBC_2.0'
> 
> So it must be something with my configuration. I've tried to build a
> minimized configuration, see below.

You can either make a minimized configuration by hand, or you can use my 
shrinker script (which is slow, but can be left running in a background 
window).  I've attached the script.

For ARCH=um, you'd cd to your linux source directory that has the .config you 
want, and run it like:

  ARCH=um ./miniconfig.sh mini.conf

And it should produce a file "mini.conf" when it's done.  The progress 
indicator shows two numbers (111/222) which are the number of lines it's 
confirmed it needs to keep, and the total number of lines remaining in the 
file.  The one of the left counts up, the one on the right counts down, when 
they match, it's done.

Doing a better version of this in C as a patch to the kconfig infrastructure 
has been a todo item of mine for over two years. :(

> You can trigger the bug here by 
> changing "Enable loadable module support.

UML supports modules?  Huh.  (Yeah, I suppose it does.  I've never used it.)

So the bug is "module support doesn't compile in UML 2.6.21" then.  Might want 
to change the title and resubmit. :)

Rob

--Boundary-00=_FUVTG873thDu9LT
Content-Type: application/x-shellscript;
  name="miniconfig.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="miniconfig.sh"

#!/bin/sh

# miniconfig.sh copyright 2005 by Rob Landley <rob@landley.net>
# Licensed under the GNU General Public License version 2.

# Run this in the linux kernel build directory with a starting file, and
# it creates a file called mini.config with all the redundant lines of that
# .config removed.  The starting file must match what the kernel outputs.
# If it doesn't, then run "make oldconfig" on it to get one that does.

if [ $# -ne 1 ] || [ ! -f "$1" ]
then
  echo "Usage: miniconfig.sh configfile" 
  exit 1
fi

if [ "$1" == ".config" ]
then
  echo "It overwrites .config, rename it and try again."
  exit 1
fi

make allnoconfig KCONFIG_ALLCONFIG="$1" > /dev/null
if [ "$(diff .config "$1" | wc -l)" -ne 4 ]
then
  echo Sanity test failed, run make oldconfig on this file:
  diff -u .config "$1"
  exit 1
fi

cp $1 mini.config
echo "Calculating mini.config..."

LENGTH=`cat $1 | wc -l`

# Loop through all lines in the file 
I=1
while true
do
  if [ $I -gt $LENGTH ]
  then
    exit
  fi
  sed -n "${I}!p" mini.config > .config.test
  # Do a config with this file
  make allnoconfig KCONFIG_ALLCONFIG=.config.test > /dev/null

  # Compare.  The date changes so expect a small difference each time.
  D=`diff .config $1 | wc -l`
  if [ $D -eq 4 ]
  then
    mv .config.test mini.config
    LENGTH=$[$LENGTH-1]
  else
    I=$[$I + 1]
  fi
  echo -n -e $I/$LENGTH lines `cat mini.config | wc -c` bytes "\r"
done
echo

--Boundary-00=_FUVTG873thDu9LT--
