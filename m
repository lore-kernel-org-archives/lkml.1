Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbYJASfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbYJASfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYJASfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:35:13 -0400
Received: from mail.atheros.com ([12.36.123.2]:50346 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbYJASfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:35:11 -0400
Date: Wed, 1 Oct 2008 04:34:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "kaszak@gmail.com" <kaszak@gmail.com>,
       "lcostantino@gmail.com" <lcostantino@gmail.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: w35und wifi driver for linux-staging
Message-ID: <20081001113458.GC6126@tesla>
References: <20081001123656.GA30942@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081001123656.GA30942@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 05:36:56AM -0700, Pavel Machek wrote:
> Hi!
> 
> This is driver for w35und usb wifi -- also in kohjinsha
> subnotebook. It should work well enough to associate and ping, but it
> obviously needs to be rewritten two more times...
> 
> OTOH worst horrors (like embedded wifi stack) should have been fixed
> already...
> 
> (against 2.6.27-rc8).
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

Quick review just looking at only a few files.
This can be removed:

> diff --git a/drivers/net/wireless/winbond/winbondport/SVN_CHANGELOG b/drivers/net/wireless/winbond/winbondport/SVN_CHANGELOG
> diff --git a/drivers/net/wireless/winbond/winbondport/VersionNote.txt
> diff --git a/drivers/net/wireless/winbond/winbondport/VersionNote.txt b/drivers/net/wireless/winbond/winbondport/VersionNote.txt


> +++ b/drivers/net/wireless/winbond/winbondport/adapter.h
> @@ -0,0 +1,23 @@
> +//
> +// ADAPTER.H -
> +// Windows NDIS global variable 'Adapter' typedef
> +//

Better kdoc or /* use this style of comments */

> +#define MAX_ANSI_STRING                40
> +typedef struct WB32_ADAPTER
> +{

Typedefs need to be removed.

> +void CreateWpaIE(PWB32_ADAPTER Adapter, u16* iFildOffset, PUCHAR msg, struct  Management_Frame* msgHeader,
> +                                struct Association_Request_Frame_Body* msgBody, u16 iMSindex); //added by WS 05/14/05
> +

Please run patch against checkpatch.pl.

> +#ifdef _WPA2_
> +void CreateRsnIE(PWB32_ADAPTER Adapter, u16* iFildOffset, PUCHAR msg, struct  Management_Frame* msgHeader,
> +                                struct Association_Request_Frame_Body* msgBody, u16 iMSindex);//added by WS 05/14/05
> +
> +u16 SearchPmkid(PWB32_ADAPTER Adapter, struct  Management_Frame* msgHeader,
> +                                  struct PMKID_Information_Element * AssoReq_PMKID );
> +#endif
> +//=============================================================================
> +// IOCTLS defined for DUT (Device Under Test)



> +
> +// IOCTL_WB_802_11_DUT_MAC_ADDRESS
> +// Query: Return the dot11StationID
> +// Set  : Set the dot11StationID. Demo only.
> +//
> +#define IOCTL_WB_802_11_DUT_MAC_ADDRESS     CTL_CODE(  \
> +            FILE_DEVICE_UNKNOWN,                        \
> +            WB_IOCTL_DUT_INDEX + 1,                     \
> +            METHOD_BUFFERED,                            \
> +            FILE_ANY_ACCESS)
> +

IOCTL stuff? What? This unused anyway.

> +// IOCTL_WB_802_11_DUT_BSS_DESCRIPTION
> +// Query: Return the info. of the current connected BSS.
> +// Set  : None.
> +//
> +#define IOCTL_WB_802_11_DUT_BSS_DESCRIPTION   CTL_CODE(  \
> +            FILE_DEVICE_UNKNOWN,                          \
> +            WB_IOCTL_DUT_INDEX + 2,                       \
> +            METHOD_BUFFERED,                              \
> +            FILE_ANY_ACCESS)
> +

This too.

> +#define IOCTL_WB_802_11_DUT_TX_RATE_MODE CTL_CODE(    \
> +            FILE_DEVICE_UNKNOWN,                            \
> +            WB_IOCTL_DUT_INDEX + 30,                        \
> +            METHOD_BUFFERED,                                \
> +            FILE_ANY_ACCESS)

And this guy.. etc...

> +++ b/drivers/net/wireless/winbond/winbondport/linux/Makefile
> @@ -0,0 +1,37 @@
> +#=========================================================================
> +#
> +#  Module Name:
> +#  w35und.ko Makefile for the ISSC wireless networking driver in linux kernel 2.6.x
> +#  Port from Original
> +
> +#  Abstract:
> +#  Linux 2.6 driver for IS89C35D 802.11 a/b/g Wireless USB
> +#
> +#=========================================================================
> +
> +
> +# This is not used for build when the wifi module is build into kernel
> +#
> +       KERNELDIR := /lib/modules/$(shell uname -r)/build
> +       PWD := $(shell pwd)
> +       WPA_DIR=../wpa
> +
> +obj-m := w35und.o
> +
> +w35und-objs := wbusb.o wb35reg.o wb35rx.o wb35tx.o\
> +       ../bssdbase.o ../ds_tkip.o ../knl.o ../mds.o ../mlme_assoc.o ../mlme_auth.o ../mlmetask.o ../mlmetxrx.o \
> +       ../mto.o ../phy_calibration.o ../reg.o ../roamtask.o ../rxisr.o ../scan_probe.o ../scantask.o \
> +       ../sme_api.o ../smetask.o ../wbhal.o ../wblinux.o \
> +       $(WPA_DIR)/eap.o $(WPA_DIR)/4Way.o $(WPA_DIR)/Adapter_Bridge.o $(WPA_DIR)/STLFunction.o \
> +       $(WPA_DIR)/passphrase.o $(WPA_DIR)/prf.o  \

> + $(WPA_DIR)/rc4.o $(WPA_DIR)/sha1.o $(WPA_DIR)/hmac_sha1.o \
> +       $(WPA_DIR)/hmac_md5.o $(WPA_DIR)/md5.o $(WPA_DIR)/aes.o $(WPA_DIR)/aes_wrap.o

The kernel has most of these if not all.

> +++ b/drivers/net/wireless/winbond/winbondport/linux/Makefile.debug

Make this a CONFIG option instead of using another file.

> diff --git a/drivers/net/wireless/winbond/winbondport/linux/README.PORT b/drivers/net/wireless/winbond/winbondport/linux/README.PORT

Can be removed or moved to Documentation/networking/ somewhere if its really useful.

> +++ b/drivers/net/wireless/winbond/winbondport/linux/README.RXART

This can be removed.

> diff --git a/drivers/net/wireless/winbond/winbondport/linux/README.txt b/drivers/net/wireless/winbond/winbondport/linux/README.txt

Documentation/networking/ somewhere, but this documentation is not
relevant for the kernel.

> +0. To build driver
> +       #cd linux/
> +        #make
> +
> +       ( For debug mode )
> +        #cp Makefile.debug Makefile
> +        #make
> +
> +        #make install  ( if want it on /lib/modules..)
> +
> +        w35und.ko should be created

Like this.

> +
> +1. Installation
> +
> +       # insmod w35und.ko    or    #modprobe w35und  ( if "make install", ( check depmod too.. ) )
> +
> +       Notes:
> +       After your inserted this module to system, your can use special commands
> +       of user guider to connect your desired AP or IBSS station. After connected,
> +       you can use this command to assign an IP address and up it.
> +
> +       # ifconfig wlan0 xxx.xxx.xxx.xxx. up
> +
> +
> +
> +2. Un-Installation
> +
> +       # rmmod w35und
> +
> +       Notes:
> +       If you have up our driver, you must down your dirver with this command
> +       before you remove this module:
> +
> +       #ifconfig wlan0 down
> +
> +
> +
> +3. User Guide
> +
> +  3.0.1  <Set/Get region>
> +
> +       # iwpriv wlan0 set_region XXX
> +       # iwpriv wlan0 get_region
> +
> +       Notes:
> +               XXX is a string, includes : Europe, Japan, USA, Reg_Unknown

Please consider using cfg80211 and new regulatory framework for this.
Then you can refer to iw:

http://wireless.kernel.org/en/users/Documentation/iw

Regulatory stuff:

http://wireless.kernel.org/en/developers/Regulatory

Also please read Documentation/networking/regulatory.txt

> diff --git a/drivers/net/wireless/winbond/winbondport/linux/common.h b/drivers/net/wireless/winbond/winbondport/linux/common.h

Please keep files in its own directory.

> +unsigned char
> +Wb35Reg_Read(phw_data_t pHwData, u16 RegisterNo,  PULONG pRegisterValue )
> +{

Please install sparse and then compile the driver using C=1, and correct
the warnings.

Ok well that should take a while..

  Luis
