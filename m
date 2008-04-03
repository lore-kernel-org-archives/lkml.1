Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYDCAC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYDCAC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbYDCACr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:02:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60347 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbYDCACp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:02:45 -0400
Date: Thu, 3 Apr 2008 02:03:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: cleanup wbusb.c a bit
Message-ID: <20080403000321.GA5013@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

List winbond in wireless/Makefile, and some cleanups for wbusb.c

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit f60117d14ef6307c35e9cd4d47c0f3c723dc32f3
tree a31c8fd49b1b5511e5640a080ca94439189485d7
parent d1d1070111b458e9a5670b33838077ebe7d81dd4
author Pavel <pavel@amd.ucw.cz> Thu, 03 Apr 2008 02:01:42 +0200
committer Pavel <pavel@amd.ucw.cz> Thu, 03 Apr 2008 02:01:42 +0200

 drivers/net/wireless/Makefile                      |    2 
 .../net/wireless/winbond/winbondport/linux/wbusb.c |  110 ++++-------------------
 2 files changed, 20 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 091dfe2..9eb0411 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -49,6 +49,8 @@ obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndi
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
 obj-$(CONFIG_LIBERTAS)		+= libertas/
 
+obj-y				+= winbond/
+
 rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index 89e0527..2f2347c 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -28,48 +28,31 @@ static struct usb_device_id Id_Table[] =
 ;
 MODULE_DEVICE_TABLE(usb,Id_Table);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	static struct usb_driver wb35_driver = {
-			name:	    "w35und",
-			probe:		wb35_probe,
-			disconnect:	wb35_disconnect,
-			id_table:   Id_Table,
-	};
-#else
 	static struct usb_driver wb35_driver = {
 			.name =		"w35und",
 			.probe =	wb35_probe,
 			.disconnect = wb35_disconnect,
 			.id_table = Id_Table,
 	};
-#endif
 
 int __init wb35_init( void )
 {
-    #ifdef _PE_USB_INI_DUMP_
-	WBDEBUG(("sizeof ADAPTER = %d\n", sizeof(ADAPTER) ));
-	WBDEBUG(("[w35und]driver init\n"));
-    #endif
+	printk("sizeof ADAPTER = %d\n", sizeof(ADAPTER) );
+	printk("[w35und]driver init\n");
 	return usb_register( &wb35_driver );
 }
 
 void __exit wb35_exit( void )
 {
-    #ifdef _PE_USB_INI_DUMP_
-	WBDEBUG(("[w35und]driver exit\n"));
-    #endif
-    usb_deregister( &wb35_driver );
+	printk(("[w35und]driver exit\n"));
+	usb_deregister( &wb35_driver );
 }
 
 module_init( wb35_init );
 module_exit( wb35_exit );
 
 //Usb kernel subsystem will call this function when a new device is plugged into.
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-void *wb35_probe( struct usb_device *udev, unsigned int ifnum, const struct usb_device_id *id_table )
-#else
 int wb35_probe( struct usb_interface *intf,const struct usb_device_id *id_table )
-#endif
 {
 	PADAPTER	Adapter;
 	PWBLINUX	pWbLinux;
@@ -84,27 +67,14 @@ #endif
 	ULONG	ltmp;
 
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	struct usb_device *udev = interface_to_usbdev(intf);
 	int res = -ENOMEM;
 	usb_get_dev(udev);
-#endif
 
-    #ifdef _PE_USB_INI_DUMP_
-	WBDEBUG(("[w35und]wb35_probe ->\n"));
-    #endif
+	printk("[w35und]wb35_probe ->\n");
 
 	do
 	{
-		#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-		if( usb_set_configuration( udev, udev->config[0].bConfigurationValue ) ) 
-		{
-			#ifdef _PE_USB_INI_DUMP_
-			WBDEBUG(("[w35und]usb_set_configuration() failed\n"));
-			#endif
-			break;
-		}
-		#endif
 
 		// 20060630.1 Add for check HW basically
 		for( i=0; i<(sizeof(Id_Table)/sizeof(struct usb_device_id)); i++ )
@@ -143,31 +113,17 @@ #endif
 			break;
 
 
-		#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-		netdev = init_etherdev( NULL, sizeof(ADAPTER) );
-		#else
 		netdev = alloc_etherdev( sizeof(ADAPTER) );
-		#endif
 
-		if( !netdev )
-		{
-			#ifdef _PE_USB_INI_DUMP_
-			WBDEBUG(("[w35und]init_etherdev out of memory\n"));
-			#endif
+		if (!netdev) {
+			printk("[w35und]init_etherdev out of memory\n");
 
-			#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 			module_put(THIS_MODULE);
-			#endif
-
 			break;
 		}
 
 		// Clear out the adapter block, which sets all default values to FALSE, or NULL.
-		#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-		Adapter = netdev->priv;
-		#else
-		Adapter = netdev_priv( netdev );
-		#endif
+		Adapter = netdev_priv(netdev);
 
 		OS_MEMORY_CLEAR( Adapter, sizeof(ADAPTER) );
 		pWbLinux = &Adapter->WbLinux;
@@ -178,37 +134,24 @@ #endif
 		//set the interface name for this device.
 		//dev_alloc_name(	netdev, "wlan%d");
 
-		//to fill the owner field of netdev for kernel usage count 
-	       #if  LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)  
-	       SET_MODULE_OWNER( netdev );
-	       #endif
-		// Determine that the USB type is working at 1.1 or 2.0
-		#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-		interface = udev->config[0].interface[ifnum].altsetting;
-		endpoint = interface[ifnum].endpoint;
-		#else
+
 	        //Cambiado
 	        interface = intf->cur_altsetting;
 	        endpoint = &interface->endpoint[0].desc;
 
 	   	   //&(intf->altsetting->endpoint);
-		#endif
 
 		if( endpoint[2].wMaxPacketSize == 512 )
 		{
-			#ifdef _PE_USB_INI_DUMP_
-			WBDEBUG(("[w35und] Working on USB 2.0\n"));
-			#endif
+			printk("[w35und] Working on USB 2.0\n");
 			pWbUsb->IsUsb20 = 1;
 		}
 		#ifdef _PE_STATE_DUMP_	
 		WBDEBUG(("WbWLanInitialize(1)\n"));
 		#endif
-		if( !WbWLanInitialize( Adapter ) )
+		if (!WbWLanInitialize( Adapter ))
 		{
-			#ifdef _PE_USB_INI_DUMP_
-			WBDEBUG(("[w35und]WbWLanInitialize fail\n"));
-			#endif
+			printk("[w35und]WbWLanInitialize fail\n");
 			break;
 		}
 		//For test,Added by WangJS 2006.9.1
@@ -218,8 +161,8 @@ #endif
 
 		//Set MAC Address - by Someone - since 2.6.24-rc2
 		{
-		phw_data_t pHwData = &Adapter->sHwData;
-		hal_get_permanent_address( pHwData, netdev->dev_addr );
+			phw_data_t pHwData = &Adapter->sHwData;
+			hal_get_permanent_address(pHwData, netdev->dev_addr);
 		}
 
 		//////////////////////////////////////////////////
@@ -229,9 +172,8 @@ #endif
 
 		//Moved later, to make possible the changing of MAC
 		//Needs some more work
-		dev_alloc_name(	netdev, "wlan%d");
+		dev_alloc_name(netdev, "wlan%d");
 
-		#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 		SET_NETDEV_DEV( netdev, &intf->dev );
 		if( register_netdev( netdev ) !=0 )
 		{
@@ -241,31 +183,15 @@ #endif
 			break;
 		}
 		usb_set_intfdata( intf, Adapter );
-		#endif
 
-		#ifdef _PE_USB_INI_DUMP_
-		WBDEBUG(("[w35und] _probe OK\n"));
-		#endif
-
-		#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-		return Adapter;
-		#else
+		printk("[w35und] _probe OK\n");
 		return 0;
-		#endif
 
-	}while(FALSE);
+	} while(FALSE);
 
-	#if LINUX_VERSION_CODE <KERNEL_VERSION(2,5,0)
-	if( Adapter )
-		kfree( Adapter );
-	if( netdev )
-		kfree( netdev );
-	return NULL;
-	#else
-	if( netdev )
+	if (netdev)
 		free_netdev( netdev );
 	return -ENOMEM;
-	#endif
 }
 
 BOOL

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
