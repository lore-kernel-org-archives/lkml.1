Return-Path: <linux-kernel-owner+w=401wt.eu-S1765587AbXIMGeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765587AbXIMGeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXIMGeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:34:07 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:24853 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbXIMGeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hph/06SAa7wK5khCtV0QuhEVEV6yuhTLD61hjbaTdB4JTa4lfKsg0lDkW6yXXU39oj3lAhR6/LHNwa5LCOTKrjIt7qS2CnjmUDZYLDSNFHDjgknq3wUqZiuWtz/+aK260K7M3M1xo+c1gmnn/wNRB4TsvkOTbky0KupvGnNGqZI=
Message-ID: <b6fcc0a0709122334qa31fffby4afbf857c92efb89@mail.gmail.com>
Date: Thu, 13 Sep 2007 10:34:02 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: fix unterminated pci_device_id lists
Cc: "Greg KH" <greg@kroah.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Kees Cook" <kees@ubuntu.com>, linux-kernel@vger.kernel.org,
       "Ben Collins" <bcollins@ubuntu.com>,
       "Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <20070912160827.e359a53b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org>
	 <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
	 <20070912215356.GC23294@kroah.com>
	 <20070912160827.e359a53b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[non-terminated PCI ids arrays]

Here is compile-time hack (yep, warped and whitespace damaged :))
It's better than modpost-time hack. because it triggers earlier.
It's worse than modpost-time hack, because of tree-wide changes.

diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index f4e4298..b895b5f 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -237,7 +237,7 @@ static const struct {
 };


-static struct pci_device_id rtl8139_pci_tbl[] = {
+PCI_MODULE_DEVICE_TABLE_BEGIN(rtl8139_pci_tbl)
 	{0x10ec, 0x8139, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
 	{0x10ec, 0x8138, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
 	{0x1113, 0x1211, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
@@ -273,10 +273,7 @@ static struct pci_device_id rtl8139_pci_tbl[] = {
 	{PCI_ANY_ID, 0x8139, 0x10ec, 0x8139, 0, 0, RTL8139 },
 	{PCI_ANY_ID, 0x8139, 0x1186, 0x1300, 0, 0, RTL8139 },
 	{PCI_ANY_ID, 0x8139, 0x13d1, 0xab06, 0, 0, RTL8139 },
-
-	{0,}
-};
-MODULE_DEVICE_TABLE (pci, rtl8139_pci_tbl);
+PCI_MODULE_DEVICE_TABLE_END

 static struct {
 	const char str[ETH_GSTRING_LEN];
diff --git a/include/linux/module.h b/include/linux/module.h
index b6a646c..aef3cd9 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -137,6 +137,13 @@ extern struct module __this_module;
 #define MODULE_DEVICE_TABLE(type,name)		\
   MODULE_GENERIC_TABLE(type##_device,name)

+#define PCI_MODULE_DEVICE_TABLE_BEGIN(name)	\
+	MODULE_DEVICE_TABLE(pci, name);		\
+	static struct pci_device_id name[] = {
+
+#define PCI_MODULE_DEVICE_TABLE_END		\
+	{}};
+
 /* Version of form [<epoch>:]<version>[-<extra-version>].
    Or for CVS/RCS ID version, everything but the number is stripped.
   <epoch>: A (small) unsigned integer which allows you to start versions
