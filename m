Return-Path: <linux-kernel-owner+w=401wt.eu-S932613AbXBNW2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbXBNW2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932611AbXBNW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:28:00 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52211 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbXBNW17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:27:59 -0500
Subject: Re: [PATCH 2.6.21-rc1] ehea: dynamic add / remove port
From: John Rose <johnrose@austin.ibm.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Raisch <RAISCH@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <MEDER@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, stefan.roscher@de.ibm.com,
       netdev <netdev@vger.kernel.org>, Nathan Fontenot <nfont@austin.ibm.com>
In-Reply-To: <200702141536.28665.ossthema@de.ibm.com>
References: <200702141536.28665.ossthema@de.ibm.com>
Content-Type: text/plain
Message-Id: <1171491906.30473.3.camel@sinatra.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.6 (1.4.6-2) 
Date: Wed, 14 Feb 2007 16:25:06 -0600
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

A few high level comments, then some really insignificant ones.

First, is there a reason why we shouldn't have a sysfs entry/kobject for
each logical port?  How is it possible to determine, from the adapter
sysfs directory, the current number of ports for that adapter?  A port
sysfs directory could include attributes like the OF path to the port,
the state of the port, etc etc.

Second, the probe and remove functions do not communicate whether an add
or remove was successful.  Combine this with the lack of port
information in the adapter sysfs directory, and the userspace tool has
no way of verifying a dynamic add/remove.

+		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
+						    NULL);
+		if (!dn_log_port_id) {
+			ehea_error("bad device node: dn_log_port_id=%p",
+				   dn_log_port_id);

Wouldn't this print NULL every time for dn_log_port_id?  Would the OF
path for eth_dn make for a more useful error msg?

+		ehea_info("%s -> logial port id #%d",

Spelling :)

 	if (port_setup_ok)
-		ret = 0;	/* At least some ports are setup correctly */
+		return 0;	/* At least some ports are setup correctly */
 	else
-		ret = -EINVAL;
+		return -EINVAL;

The else is unnecessary.

 static int __devexit ehea_remove(struct ibmebus_dev *dev)
 {
 	struct ehea_adapter *adapter = dev->ofdev.dev.driver_data;
 	u64 hret;
 	int i;
 
-	for (i = 0; i < adapter->num_ports; i++)
+	for (i = 0; i < EHEA_MAX_PORTS; i++)
 		if (adapter->port[i]) {
 			ehea_shutdown_single_port(adapter->port[i]);
 			adapter->port[i] = NULL;
 		}

Else break?

Thanks-
John

